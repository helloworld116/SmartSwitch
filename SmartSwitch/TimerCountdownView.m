//
//  TimerCountdownView.m
//  SmartSwitch
//
//  Created by sdzg on 14-8-25.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "TimerCountdownView.h"
#define kDelayInSeconds 1
@interface TimerCountdownView ()
@property(nonatomic, strong) IBOutlet UIImageView *imgViewHour1;
@property(nonatomic, strong) IBOutlet UIImageView *imgViewHour2;
@property(nonatomic, strong) IBOutlet UIImageView *imgViewMin1;
@property(nonatomic, strong) IBOutlet UIImageView *imgViewMin2;
@property(nonatomic, strong) IBOutlet UIImageView *imgViewSec1;
@property(nonatomic, strong) IBOutlet UIImageView *imgViewSec2;

@property(nonatomic, assign) int seconds;  //需要倒计时的秒数
@property(nonatomic, strong) dispatch_source_t timer;
@end

@implementation TimerCountdownView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
  }
  return self;
}

- (void)awakeFromNib {
  [self setToZero];
}

- (void)countDown:(int)seconds {
  if (seconds) {
    self.seconds = seconds;
    __weak id weakSelf = self;
    if (self.timer) {
      dispatch_source_cancel(self.timer);
    }
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,
                                        dispatch_get_main_queue());
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0),
                              (unsigned)(kDelayInSeconds * NSEC_PER_SEC), 0);
    dispatch_source_set_event_handler(_timer, ^{ [weakSelf updateView]; });
    dispatch_resume(_timer);
  }
}

- (void)updateView {
  if (self.seconds) {
    NSString *imgHour1Name, *imgHour2Name, *imgMin1Name, *imgMin2Name,
        *imgSec1Name, *imgSec2Name;
    int hour = self.seconds / 3600;                           //小时
    int minutes = (self.seconds - 3600 * hour) / 60;          //分钟
    int seconds = self.seconds - 3600 * hour - 60 * minutes;  //秒
    imgHour1Name = [NSString stringWithFormat:@"%d", hour / 10];
    imgHour2Name = [NSString stringWithFormat:@"%d", hour % 10];
    imgMin1Name = [NSString stringWithFormat:@"%d", minutes / 10];
    imgMin2Name = [NSString stringWithFormat:@"%d", minutes % 10];
    imgSec1Name = [NSString stringWithFormat:@"%d", seconds / 10];
    imgSec2Name = [NSString stringWithFormat:@"%d", seconds % 10];
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.imgViewHour1.image =
                             [UIImage imageNamed:imgHour1Name];
                         self.imgViewHour2.image =
                             [UIImage imageNamed:imgHour2Name];
                         self.imgViewMin1.image =
                             [UIImage imageNamed:imgMin1Name];
                         self.imgViewMin2.image =
                             [UIImage imageNamed:imgMin2Name];
                         self.imgViewSec1.image =
                             [UIImage imageNamed:imgSec1Name];
                         self.imgViewSec2.image =
                             [UIImage imageNamed:imgSec2Name];
                     }];
    self.seconds--;
  } else {
    [self setToZero];
    dispatch_source_cancel(self.timer);
  }
}

- (void)setToZero {
  NSString *imgName = @"0";
  self.imgViewHour1.image = [UIImage imageNamed:imgName];
  self.imgViewHour2.image = [UIImage imageNamed:imgName];
  self.imgViewMin1.image = [UIImage imageNamed:imgName];
  self.imgViewMin2.image = [UIImage imageNamed:imgName];
  self.imgViewSec1.image = [UIImage imageNamed:imgName];
  self.imgViewSec2.image = [UIImage imageNamed:imgName];
}

- (void)dealloc {
  if (self.timer) {
    dispatch_source_cancel(self.timer);
  }
}
@end
