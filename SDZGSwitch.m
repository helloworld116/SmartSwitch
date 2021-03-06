//
//  SDZGSwitch.m
//  SmartSwitch
//
//  Created by sdzg on 14-8-19.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "SDZGSwitch.h"

@implementation SDZGSwitch
+ (SDZGSwitch *)parseMessageCOrEToSwitch:(CC3xMessage *)message {
  SDZGSwitch *aSwitch = [[SDZGSwitch alloc] init];
  aSwitch.mac = message.mac;
  aSwitch.ip = message.ip;
  aSwitch.port = message.port;
  aSwitch.name = message.deviceName;
  aSwitch.version = message.version;
  aSwitch.lockStatus = message.lockStatus;
  if (message.msgId == 0xc) {
    aSwitch.networkStatus = SWITCH_LOCAL;
  } else if (message.msgId == 0xe) {
    aSwitch.networkStatus = SWITCH_REMOTE;
  } else {
    aSwitch.networkStatus = SWITCH_OFFLINE;
  }
  aSwitch.sockets = [@[] mutableCopy];
  SDZGSocket *socket1 = [[SDZGSocket alloc] init];
  socket1.socketId = 1;
  socket1.socketStatus = ((message.onStatus & 1 << 0) == 1 << 0);
  [aSwitch.sockets addObject:socket1];

  SDZGSocket *socket2 = [[SDZGSocket alloc] init];
  socket2.socketId = 2;
  socket2.socketStatus = ((message.onStatus & 1 << 1) == 1 << 1);
  [aSwitch.sockets addObject:socket2];
  return aSwitch;
}
@end

@implementation SDZGSocket

@end

@implementation SDZGTimerTask
- (id)initWithWeek:(unsigned char)week
         actionTime:(unsigned int)actionTime
        isEffective:(BOOL)isEffective
    timerActionType:(TimerActionType)timerActionType {
  self = [super init];
  if (self) {
    self.week = week;
    self.actionTime = actionTime;
    self.isEffective = isEffective;
    self.timerActionType = timerActionType;
  }
  return self;
}

- (BOOL)isDayOn:(DAYTYPE)aDay {
  return (self.week & aDay) == aDay;
}

- (NSString *)actionWeekString {
  NSMutableString *weekStr = [NSMutableString string];
  if (self.week == 127) {
    [weekStr appendString:@"每天"];
  } else if (self.week == 0) {
    [weekStr appendString:@"执行一次"];
  } else {
    if ([self isDayOn:MONDAY]) {
      [weekStr appendString:@"周一"];
    }
    if ([self isDayOn:TUESDAY]) {
      if ([weekStr length]) {
        [weekStr appendString:@"、"];
      }
      [weekStr appendString:@"周二"];
    }
    if ([self isDayOn:WENSDAY]) {
      if ([weekStr length]) {
        [weekStr appendString:@"、"];
      }
      [weekStr appendString:@"周三"];
    }
    if ([self isDayOn:THURSDAY]) {
      if ([weekStr length]) {
        [weekStr appendString:@"、"];
      }
      [weekStr appendString:@"周四"];
    }
    if ([self isDayOn:FRIDAY]) {
      if ([weekStr length]) {
        [weekStr appendString:@"、"];
      }
      [weekStr appendString:@"周五"];
    }
    if ([self isDayOn:SATURDAY]) {
      if ([weekStr length]) {
        [weekStr appendString:@"、"];
      }
      [weekStr appendString:@"周六"];
    }
    if ([self isDayOn:SUNDAY]) {
      if ([weekStr length]) {
        [weekStr appendString:@"、"];
      }
      [weekStr appendString:@"周日"];
    }
  }
  return weekStr;
}

- (NSString *)actionTimeString {
  return [NSString stringWithFormat:@"%02d:%02d", self.actionTime / 3600,
                                    (self.actionTime % 3600) / 60];
}

- (NSString *)actionTypeString {
  if (TimerActionTypeOn == self.timerActionType) {
    return @"开启";
  } else {
    return @"关闭";
  }
}

- (BOOL)actionEffective {
  return self.isEffective;
}

#pragma mark 定时获取需要显示的最近时间
+ (int)getShowSeconds:(NSArray *)timers {
  if (timers && timers.count) {
    //当前时间
    NSDate *currentDate = [NSDate date];
    NSCalendar *gregorian =
        [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps =
        [gregorian components:NSWeekdayCalendarUnit fromDate:currentDate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd 00:00:00"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    //当日零时
    NSDate *zeroDate = [dateFormatter dateFromString:dateString];
    //当前时间距离零时的秒数
    NSTimeInterval diff =
        [currentDate timeIntervalSince1970] - [zeroDate timeIntervalSince1970];
    //公历，国外的习惯，周日是一周的开始，也就是说周日返回1，周六返回7
    int weekday = [comps weekday];
    if (weekday == 1) {
      weekday = 8;
    }
    weekday -= 2;
    //保存操作打开，且今天包含在定时列表、设定时间晚于当前时间并且操作打开的task集合
    NSMutableArray *actionTimeList = [NSMutableArray array];
    for (SDZGTimerTask *task in timers) {
      if (task.week & (1 << weekday)) {
        //时间还未到并且操作打开
        if (diff < task.actionTime && task.isEffective) {
          [actionTimeList addObject:@(task.actionTime)];
        }
      }
    }
    int min = 0;
    if (actionTimeList.count) {
      min = [[actionTimeList valueForKeyPath:@"@min.self"] integerValue];
    }
    return min;
  }
  return 0;
}
@end
