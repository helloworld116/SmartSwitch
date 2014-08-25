//
//  TimeDisplayView.m
//  SmartSwitch
//
//  Created by sdzg on 14-8-25.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "TimeDisplayView.h"
@interface TimeDisplayView ()
@property(nonatomic, strong) IBOutlet UIImageView *imgViewHour1;
@property(nonatomic, strong) IBOutlet UIImageView *imgViewHour2;
@property(nonatomic, strong) IBOutlet UIImageView *imgViewMin1;
@property(nonatomic, strong) IBOutlet UIImageView *imgViewMin2;
@property(nonatomic, strong) IBOutlet UIImageView *imgViewSec1;
@property(nonatomic, strong) IBOutlet UIImageView *imgViewSec2;

@property(nonatomic, assign) int seconds;  //需要倒计时的秒数
@end

@implementation TimeDisplayView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
  }
  return self;
}

- (void)awakeFromNib {
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
}
@end
