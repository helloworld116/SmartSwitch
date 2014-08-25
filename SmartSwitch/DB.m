//
//  DB.m
//  SmartSwitch
//
//  Created by 文正光 on 14-8-25.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "DB.h"
#import <FMDB/FMDB.h>

@interface DB ()
@property (nonatomic, strong) FMDatabase *db;
@end

@implementation DB

- (void)createDatabase {
  NSString *dbPath =
      [PATH_OF_DOCUMENT stringByAppendingPathComponent:@"smartswitch.db"];
  self.db = [FMDatabase databaseWithPath:dbPath];
}

- (BOOL)createTables {
  if ([self.db open]) {
    NSString *sql =
        @"create table switch(id integer primary key autoincrement,name "
        @"text,networkstatus integer,mac text,ip text,lockstatus "
        @"integer,version integer,tag integer,imagename text,password "
        @"text);create table socket(id integer primary key "
        @"autoincrement,switchid integer,socketid integer,name text,delaytime "
        @"integer,delayaction integer,socketstatus integer,imagename "
        @"text);create table timertask(id integer primary key "
        @"autoincrement,socketid integer,week integer,actiontime "
        @"integer,iseffective numeric,actiontype integer);";
    BOOL success = [self.db executeStatements:sql];
    if (success) {
      debugLog(@"创建表成功");
    } else {
      debugLog(@"创建表失败");
    }
    [self.db close];
    return success;
  }
  return NO;
}

- (void)saveSwitch:(SDZGSwitch *)aSwitch {
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
