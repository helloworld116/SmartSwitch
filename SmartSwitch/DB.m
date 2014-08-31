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
      [self createTableTimerTask];
    }
    if (![self isExistTable:@"scenedetail"]) {
      [self createTableTimerTask];
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
        @"text,networkstatus integer,mac text,ip text,lockstatus "
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
        @"autoincrement,switchid integer,socketid integer,name "
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
        @"autoincrement,socketid integer,week integer,actiontime "
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
    NSString *selectSql = @"select count(id) as sid from switch where mac=?";
    FMResultSet *socketResult = [self.db executeQuery:selectSql, aSwitch.mac];
    if ([socketResult next]) {
      int sid = [socketResult intForColumn:@"sid"];
      if (sid) {
        NSString *sql = @"update switch set "
            @"name=?,networkstatus=?,lockstatus=?,version=?,tag=?,"
            @"imagename=?,password=? where mac=?";
        [self.db executeUpdate:sql, aSwitch.name, @(aSwitch.networkStatus),
                               @(aSwitch.lockStatus), @(aSwitch.version), @(0),
                               aSwitch.imageName, aSwitch.password,
                               aSwitch.mac];
      } else {
        NSString *sql = @"insert into "
            @"switch(name,networkstatus,mac,ip,lockstatus,version,tag,"
            @"imagename,password) value(?,?,?,?,?,?,?,?,?)";
        [self.db executeUpdate:sql, aSwitch.name, @(aSwitch.networkStatus),
                               aSwitch.mac, aSwitch.ip, @(aSwitch.lockStatus),
                               @(aSwitch.version), @(0), aSwitch.imageName,
                               aSwitch.password];
      }
    }
  }
}

- (void)saveSwitchs:(NSArray *)switchs {
  if (switchs && switchs.count) {
    for (SDZGSwitch *aSwitch in switchs) {
      NSString *sql = @"select * from switch";
    }
  }
}

- (NSArray *)getSwitchs {
  NSMutableArray *switchs = [@[] mutableCopy];
  NSString *switchSql = @"select * from switch";
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

    int switchId = [switchResult intForColumn:@"id"];
    NSString *socketSql = @"select * from socket where switchid is ?";
    FMResultSet *socketResult = [self.db executeQuery:socketSql, @(switchId)];
    while (socketResult.next) {
      SDZGSocket *socket = [[SDZGSocket alloc] init];
      socket.socketId = [socketResult intForColumn:@"socketId"];
      socket.name = [socketResult stringForColumn:@"name"];
      socket.imageName = [socketResult stringForColumn:@"imagename"];
      socket.delayTime = [socketResult intForColumn:@"delaytime"];
      socket.delayAction = [socketResult intForColumn:@"delayaction"];
      socket.socketStatus = [socketResult intForColumn:@"socketstatus"];
      socket.timerList = [@[] mutableCopy];

      int socketIndentify = [socketResult intForColumn:@"id"];
      NSString *timertaskSql = @"select * from timer where socketid is ?";
      FMResultSet *timertaskResult =
          [self.db executeQuery:timertaskSql, socketIndentify];
      while (timertaskResult.next) {
        SDZGTimerTask *timerTask = [[SDZGTimerTask alloc] init];
        timerTask.week = [timertaskResult intForColumn:@"week"];
        timerTask.actionTime = [timertaskResult intForColumn:@"actiontime"];
        timerTask.isEffective = [timertaskResult boolForColumn:@"iseffective"];
        timerTask.timerActionType =
            [timertaskResult intForColumn:@"actiontype"];
        [socket.timerList addObject:timerTask];
      }
      [aSwitch.sockets addObject:socket];
    }
    [switchs addObject:aSwitch];
  }
  return switchs;
}
@end
