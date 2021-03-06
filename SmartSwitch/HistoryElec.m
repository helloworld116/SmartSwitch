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

@implementation HistoryElecData

@end

@interface HistoryElec ()
@property(strong, nonatomic) NSDateFormatter *dateFormatter;
@end

@implementation HistoryElec
- (id)init {
  self = [super init];
  if (self) {
    self.dateFormatter = [[NSDateFormatter alloc] init];
  }
  return self;
}

- (HistoryElecParam *)getParam:(int)currentYear
                 selectedMonth:(int)selectedMonth
                      startDay:(int)startDay
                        endDay:(int)endDay {
  [self.dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
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

- (HistoryElecData *)parseResponse:(NSArray *)responseArray
                             param:(HistoryElecParam *)param {
  NSMutableDictionary *needDict = [@{} mutableCopy];
  int needCount = (param.endTime + 1 - param.beginTime) / param.interval;
  NSString *key;
  //设置默认值为0
  for (int i = 0; i < needCount; i++) {
    key = [NSString
        stringWithFormat:@"%d", (int)(param.beginTime + i * param.interval)];
    [needDict setObject:@(0) forKey:key];
  }
  //替换服务器响应的数据
  if (responseArray && responseArray.count) {
    for (HistoryElecResponse *response in responseArray) {
      NSString *key = [NSString stringWithFormat:@"%d", response.time];
      [needDict setObject:@(response.power) forKey:key];
    }
  }

  HistoryElecData *data = [[HistoryElecData alloc] init];
  if (param.interval == kTimeIntervalDay) {
    [self.dateFormatter setDateFormat:@"HH:mm"];
  } else if (param.interval == kTimeIntervalMonth) {
    [self.dateFormatter setDateFormat:@"MM-dd"];
  }
  NSMutableArray *times = [@[] mutableCopy];
  NSMutableArray *values = [@[] mutableCopy];
  NSString *formatterDateStr;
  int value;
  //排序后的时间戳
  NSArray *timeArray = [[needDict allKeys]
      sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
          return [obj1 intValue] - [obj2 intValue];
      }];
  for (NSString *dateInterval in timeArray) {
    NSDate *date =
        [NSDate dateWithTimeIntervalSince1970:[dateInterval intValue]];
    formatterDateStr = [self.dateFormatter stringFromDate:date];
    value = [[needDict objectForKey:dateInterval] intValue];
    [times addObject:formatterDateStr];
    [values addObject:@(value)];
  }
  data.times = times;
  data.values = values;
  return data;
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
