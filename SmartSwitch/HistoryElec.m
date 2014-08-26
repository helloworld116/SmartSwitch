//
//  HistoryElec.m
//  SmartSwitch
//
//  Created by sdzg on 14-8-26.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "HistoryElec.h"
#define kTimeIntervalDay 3600
#define kTimeIntervalMonth 3600 * 24

@implementation HistoryElecParam

@end

@interface HistoryElecData ()

@end

@interface HistoryElec ()
@property(strong, nonatomic) NSDateFormatter *dateFormatter;
@end

@implementation HistoryElec
- (id)init {
  self = [super init];
  if (self) {
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
  }
  return self;
}

- (HistoryElecParam *)getParam:(int)currentYear
                 selectedMonth:(int)selectedMonth
                      startDay:(int)startDay
                        endDay:(int)endDay {
  NSString *startDateString =
      [NSString stringWithFormat:@"%d-%d-%d 00:00:00", currentYear,
                                 selectedMonth, startDay];
  NSString *endDateString;
  int interval;
  if (startDay == endDay) {
    //开始日和结束日相同，则说明查询的是某一天，否则查询的是某一月
    interval = kTimeIntervalDay;
    endDateString =
        [NSString stringWithFormat:@"%d-%d-%d 23:59:59", currentYear,
                                   selectedMonth, startDay];
  } else {
    interval = kTimeIntervalMonth;
    endDateString =
        [NSString stringWithFormat:@"%d-%d-%d 23:59:59", currentYear,
                                   selectedMonth, endDay];
  }
  NSTimeInterval start = [[self.dateFormatter
      dateFromString:startDateString] timeIntervalSince1970];
  NSTimeInterval end =
      [[self.dateFormatter dateFromString:endDateString] timeIntervalSince1970];
  HistoryElecParam *param = [[HistoryElecParam alloc] init];
  param.beginTime = start;
  param.endTime = end;
  param.interval = interval;
  return param;
}

- (HistoryElecData *)data:(NSArray *)responseArray
                    param:(HistoryElecParam *)param {
  NSMutableDictionary *needDict = [@{} mutableCopy];
  int needCount = (param.endTime + 1 - param.beginTime) / param.interval;
  NSString *key;

  for (int i = 0; i < needCount; i++) {
    key = [NSString
        stringWithFormat:@"%d", (int)(param.beginTime + i * param.interval)];
    [needDict setObject:@(0) forKey:key];
  }
  for (HistoryElecResponse *response in responseArray) {
    NSString *key = [NSString stringWithFormat:@"%d", response.time];
    response.power;
  }
  return nil;
}
@end

@implementation HistoryElecResponse
- (id)initWithTime:(int)time power:(int)power {
  self = [super init];
  if (self) {
    self.time = time;
    self.power = power;
  }
  return self;
}
@end
