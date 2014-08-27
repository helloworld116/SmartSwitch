//
//  SDZGSwitch.m
//  SmartSwitch
//
//  Created by sdzg on 14-8-19.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "SDZGSwitch.h"

@implementation SDZGSwitch

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
  return self.week & aDay;
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
    return @"开";
  } else {
    return @"关";
  }
}

- (BOOL)actionEffective {
  return self.isEffective;
}
@end
