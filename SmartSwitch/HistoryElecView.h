//
//  HistoryElecView.h
//  SmartSwitch
//
//  Created by sdzg on 14-8-24.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NSDate+Calendar.h>

@protocol HistoryElecViewDelegate<NSObject>
- (void)currentYear:(int)year
      selectedMonth:(int)selectedMonth
           startDay:(int)startDay
             endDay:(int)endDay;
@end

@interface HistoryElecView : UIView
@property (nonatomic, assign) id<HistoryElecViewDelegate> delegate;
@property (strong, nonatomic) NSArray *times;
@property (strong, nonatomic) NSArray *values;
@end
