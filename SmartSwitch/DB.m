//
//  DB.m
//  SmartSwitch
//
//  Created by 文正光 on 14-8-25.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "DB.h"
#import <FMDB/FMDB.h>

@interface DBUtil ()
@property(nonatomic, strong) FMDatabase *db;
@end

@implementation DBUtil

- (id)init {
  self = [super init];
  if (self) {
    [self createDatabase];
    if (![self isExistTable:@"switch"]) {
      [self createTableSwitch];
    }
    if (![self isExistTable:@"socket"]) {
      [self createTableSocket];
    }
    if (![self isExistTable:@"timertask"]) {
      [self createTableTimerTask];
    }
    if (![self isExistTable:@"scene"]) {
      [self createTableScene];
    }
    if (![self isExistTable:@"scenedetail"]) {
      [self createTableSceneDetail];
    }
  }
  return self;
}

+ (instancetype)sharedInstance {
  static DBUtil *dbUtil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{ dbUtil = [[DBUtil alloc] init]; });
  return dbUtil;
}

- (void)createDatabase {
  NSString *dbPath =
      [PATH_OF_DOCUMENT stringByAppendingPathComponent:@"smartswitch.db"];
  self.db = [FMDatabase databaseWithPath:dbPath];
}

- (BOOL)createTableSwitch {
  if ([self.db open]) {
    NSString *sql =
        @"create table switch(id integer primary key autoincrement,name "
        @"text,networkstatus integer,mac text,ip text,port integer,lockstatus "
        @"integer,version integer,tag integer,imagename text,password "
        @"text);";
    BOOL success = [self.db executeUpdate:sql];
    if (success) {
      debugLog(@"创建表switch成功");
    } else {
      debugLog(@"创建表switch失败");
    }
    [self.db close];
    return success;
  }
  return NO;
}

- (BOOL)createTableSocket {
  if ([self.db open]) {
    NSString *sql = @"create table socket(id integer primary key  "
        @"autoincrement,mac text,socketid integer,name "
        @"text,delaytime integer,delayaction "
        @"integer,socketstatus integer,imagename text);";
    BOOL success = [self.db executeUpdate:sql];
    if (success) {
      debugLog(@"创建表socket成功");
    } else {
      debugLog(@"创建表socket失败");
    }
    [self.db close];
    return success;
  }
  return NO;
}

- (BOOL)createTableTimerTask {
  if ([self.db open]) {
    NSString *sql = @"create table timertask(id integer primary key "
        @"autoincrement,mac text,socketid integer,week integer,actiontime "
        @"integer,iseffective numeric,actiontype integer);";
    BOOL success = [self.db executeUpdate:sql];
    if (success) {
      debugLog(@"创建表timertask成功");
    } else {
      debugLog(@"创建表timertask失败");
    }
    [self.db close];
    return success;
  }
  return NO;
}

- (BOOL)createTableScene {
  if ([self.db open]) {
    NSString *sql =
        @"create table scene(id integer primary key autoincrement,name text);";
    BOOL success = [self.db executeUpdate:sql];
    if (success) {
      debugLog(@"创建表scene成功");
    } else {
      debugLog(@"创建表scene失败");
    }
    [self.db close];
    return success;
  }
  return NO;
}

- (BOOL)createTableSceneDetail {
  if ([self.db open]) {
    NSString *sql = @"create table scenedetail(id integer primary key "
        @"autoincrement,sceneid integer,mac text,action "
        @"integer,socketid integer);";
    BOOL success = [self.db executeUpdate:sql];
    if (success) {
      debugLog(@"创建表sceneeetail成功");
    } else {
      debugLog(@"创建表scenedetail失败");
    }
    [self.db close];
    return success;
  }
  return NO;
}

- (BOOL)isExistTable:(NSString *)tableName {
  NSString *name = nil;
  BOOL isExistTable = NO;
  FMDatabase *db = self.db;
  if ([db open]) {
    NSString *sql =
        [NSString stringWithFormat:@"select name from sqlite_master where "
                                   @"type = 'table' and name = '%@'",
                                   tableName];
    FMResultSet *rs = [db executeQuery:sql];
    while ([rs next]) {
      name = [rs stringForColumn:@"name"];

      if ([name isEqualToString:tableName]) {
        isExistTable = YES;
      }
    }
    [db close];
  }
  return isExistTable;
}

- (void)saveSwitch:(SDZGSwitch *)aSwitch {
  if ([self.db open]) {
    NSString *sql = @"select count(id) as sid from switch where mac=?";
    FMResultSet *switchResult = [self.db executeQuery:sql, aSwitch.mac];
    if ([switchResult next]) {
      int sid = [switchResult intForColumn:@"sid"];
      if (sid) {
        NSString *sql = @"update switch set "
            @"name=?,networkstatus=?,lockstatus=?,version=?,tag=?,"
            @"imagename=?,password=?,port=? where mac=?";
        [self.db executeUpdate:sql, aSwitch.name, @(aSwitch.networkStatus),
                               @(aSwitch.lockStatus), @(aSwitch.version), @(0),
                               aSwitch.imageName, aSwitch.password,
                               @(aSwitch.port), aSwitch.mac];
      } else {
        NSString *sql = @"insert into "
            @"switch(name,networkstatus,mac,ip,port,lockstatus,version,tag,"
            @"imagename,password) values(?,?,?,?,?,?,?,?,?,?)";
        [self.db executeUpdate:sql, aSwitch.name, @(aSwitch.networkStatus),
                               aSwitch.mac, aSwitch.ip, @(aSwitch.port),
                               @(aSwitch.lockStatus), @(aSwitch.version), @(0),
                               aSwitch.imageName, aSwitch.password];
      }
    }
    sql = @"delete from socket where mac=?";
    [self.db executeUpdate:sql, aSwitch.mac];
    sql = @"delete from timertask where mac=?";
    [self.db executeUpdate:sql, aSwitch.mac];
    for (SDZGSocket *socket in aSwitch.sockets) {
      sql = @"insert into "
          @"socket(mac,socketid,name,delaytime,delayaction,socketstatus,"
          @"imagename) values(?,?,?,?,?,?,?)";
      [self.db executeUpdate:sql, aSwitch.mac, @(socket.socketId), socket.name,
                             @(socket.delayTime), @(socket.delayAction),
                             @(socket.socketStatus), socket.imageName];
      for (SDZGTimerTask *timer in socket.timerList) {
        sql = @"insert into " @"timertask(mac,socketid,weeek,actiontime,"
            @"actiontype,iseffective) values(?,?,?,?,?,?)";
        [self.db executeUpdate:sql, aSwitch.mac, @(socket.socketId),
                               @(timer.week), @(timer.timerActionType),
                               @(timer.isEffective)];
      }
    }
    [self.db close];
  }
}

- (void)saveSwitchs:(NSArray *)switchs {
  if (switchs && switchs.count) {
    for (SDZGSwitch *aSwitch in switchs) {
      [self saveSwitch:aSwitch];
    }
  }
}

- (NSArray *)getSwitchs {
  NSMutableArray *switchs = [@[] mutableCopy];
  NSString *switchSql = @"select * from switch";
  if ([self.db open]) {
    FMResultSet *switchResult = [self.db executeQuery:switchSql];
    while (switchResult.next) {
      SDZGSwitch *aSwitch = [[SDZGSwitch alloc] init];
      aSwitch.name = [switchResult stringForColumn:@"name"];
      aSwitch.ip = [switchResult stringForColumn:@"ip"];
      aSwitch.mac = [switchResult stringForColumn:@"mac"];
      aSwitch.imageName = [switchResult stringForColumn:@"imagename"];
      aSwitch.password = [switchResult stringForColumn:@"password"];
      aSwitch.port = [switchResult intForColumn:@"port"];
      aSwitch.networkStatus = [switchResult intForColumn:@"networkstatus"];
      aSwitch.lockStatus = [switchResult intForColumn:@"lockstatus"];
      aSwitch.version = [switchResult intForColumn:@"version"];
      aSwitch.tag = [switchResult intForColumn:@"tag"];
      aSwitch.sockets = [@[] mutableCopy];

      NSString *socketSql = @"select * from socket where mac = ?";
      FMResultSet *socketResult = [self.db executeQuery:socketSql, aSwitch.mac];
      while (socketResult.next) {
        SDZGSocket *socket = [[SDZGSocket alloc] init];
        socket.socketId = [socketResult intForColumn:@"socketid"];
        socket.name = [socketResult stringForColumn:@"name"];
        socket.imageName = [socketResult stringForColumn:@"imagename"];
        socket.delayTime = [socketResult intForColumn:@"delaytime"];
        socket.delayAction = [socketResult intForColumn:@"delayaction"];
        socket.socketStatus = [socketResult intForColumn:@"socketstatus"];
        socket.timerList = [@[] mutableCopy];

        NSString *timertaskSql =
            @"select * from timer where mac =? and socketid=?";
        FMResultSet *timertaskResult =
            [self.db executeQuery:timertaskSql, aSwitch.mac, socket.socketId];
        while (timertaskResult.next) {
          SDZGTimerTask *timerTask = [[SDZGTimerTask alloc] init];
          timerTask.week = [timertaskResult intForColumn:@"week"];
          timerTask.actionTime = [timertaskResult intForColumn:@"actiontime"];
          timerTask.isEffective =
              [timertaskResult boolForColumn:@"iseffective"];
          timerTask.timerActionType =
              [timertaskResult intForColumn:@"actiontype"];
          [socket.timerList addObject:timerTask];
        }
        [aSwitch.sockets addObject:socket];
      }
      [switchs addObject:aSwitch];
    }
    [self.db close];
  }
  return switchs;
}
@end
