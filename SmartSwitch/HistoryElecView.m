//
//  HistoryElecView.m
//  SmartSwitch
//
//  Created by 文正光 on 14-8-24.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "HistoryElecView.h"
#import <PNChart.h>
#define kBarWidth 25
#define kHistroryElecAnnimationInterval 0.3

@interface HistoryElecView ()
@property(strong, nonatomic) IBOutlet UIScrollView *scrollViewMonth;
@property(strong, nonatomic) IBOutlet UIScrollView *scrollViewDay;
@property(strong, nonatomic) IBOutlet UIScrollView *scrollViewBarChart;
@property(strong, nonatomic) IBOutlet UILabel *lblDate;
@property(strong, nonatomic) IBOutlet UILabel *lblValue;
@property(strong, nonatomic) IBOutlet UIButton *btnMonth;
@property(strong, nonatomic) IBOutlet UIButton *btnDay;
@property(strong, nonatomic) IBOutlet UILabel *lblValue1;
@property(strong, nonatomic) IBOutlet UILabel *lblValue2;
@property(strong, nonatomic) IBOutlet UILabel *lblValue3;
@property(strong, nonatomic) IBOutlet UILabel *lblValue4;
@property(strong, nonatomic) IBOutlet UILabel *lblValue5;
@property(strong, nonatomic) IBOutlet UILabel *lblValue6;

- (IBAction)selectMonth:(id)sender;
- (IBAction)selectDay:(id)sender;
- (IBAction)goPre:(id)sender;
- (IBAction)goNext:(id)sender;

@property(assign, nonatomic) int currentYear;   //当前年
@property(assign, nonatomic) int currentMonth;  //当前月
@property(assign, nonatomic) int currentDay;    //当前日

@property(assign, nonatomic) int selectedMonth;  //选中月
@property(assign, nonatomic) int selectedDay;    //选中日
@property(strong, nonatomic) UIButton *btnSelectedMonth;
@property(strong, nonatomic) UIButton *btnSelectedDay;
@end

@implementation HistoryElecView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
  }
  return self;
}

- (void)awakeFromNib {
  [self setupValue];

  //默认选中今天
  NSDate *currentDate = [NSDate date];
  self.currentYear = [currentDate year];
  self.currentDay = [currentDate day];
  self.currentMonth = [currentDate month];
  self.selectedDay = self.currentDay;
  self.selectedMonth = self.currentMonth;
  [self setupMonthInScrollView];
  [self setupDayInScrollView];

  [self setMonthsWithSelectedMonth:self.selectedMonth];
  NSDateComponents *lastDayInMonth =
      [[currentDate dateMonthEnd] dateComponentsDate];
  [self setDays:lastDayInMonth.day selectedDay:self.selectedDay];
}

- (void)layoutSubviews {
  [super layoutSubviews];
  debugLog(@"layout subviews");
  if (self.times.count > 0 && self.values.count > 0) {
    [self strokeChartInScrollView];
  }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)setupValue {
  self.lblValue1.text = @"";
  self.lblValue2.text = @"";
  self.lblValue3.text = @"";
  self.lblValue4.text = @"";
  self.lblValue5.text = @"";
  self.lblValue6.text = @"";
  self.lblDate.text = @"";
  self.lblValue.text = @"";
  self.times = [@[] mutableCopy];
  self.values = [@[] mutableCopy];
}

- (void)strokeChartInScrollView {
  //已经绘制了重新绘制
  if ([self.scrollViewBarChart subviews]) {
    for (UIView *view in [self.scrollViewBarChart subviews]) {
      [view removeFromSuperview];
    }
  }
  CGFloat width = (self.times.count * 1.5) * kBarWidth;
  self.scrollViewBarChart.contentSize =
      CGSizeMake(width, self.scrollViewBarChart.frame.size.height);
  PNBarChart *barChart = [[PNBarChart alloc]
      initWithFrame:CGRectMake(0, 0, width,
                               self.scrollViewBarChart.frame.size.height + 24)];
  barChart.backgroundColor = [UIColor clearColor];
  barChart.barBackgroundColor =
      [UIColor colorWithHexString:@"#99ccff" alpha:0.1];
  __weak HistoryElecView *weakSelf = self;
  __block int i = 0;
  barChart.yLabelFormatter = ^(CGFloat yValue) {
      ++i;
      CGFloat yValueParsed = yValue;
      NSString *labelText = [NSString stringWithFormat:@"%1.fw", yValueParsed];
      switch (i) {
        case 1:
          weakSelf.lblValue1.text = labelText;
          break;
        case 2:
          weakSelf.lblValue2.text = labelText;
          break;
        case 3:
          weakSelf.lblValue3.text = labelText;
          break;
        case 4:
          weakSelf.lblValue4.text = labelText;
          break;
        case 5:
          weakSelf.lblValue5.text = labelText;
          break;
        default:
          break;
      }
      return labelText;
  };
  self.lblValue6.text = @"0w";
  if (self.btnDay.selected) {
    self.lblDate.text =
        [NSString stringWithFormat:@"%d-%d-%d", self.currentYear,
                                   self.selectedMonth, self.selectedDay];
  } else {
    self.lblDate.text = [NSString
        stringWithFormat:@"%d-%d", self.currentYear, self.selectedMonth];
  }
  self.lblValue.text =
      [NSString stringWithFormat:
                    @"平均功率：%dw",
                    [[self.values valueForKeyPath:@"@avg.self"] integerValue]];
  barChart.yLabelSum = 5;
  barChart.yChartLabelWidth = 0.f;
  barChart.barWidth = kBarWidth;
  barChart.labelTextColor = [UIColor whiteColor];
  [barChart setXLabels:self.times];
  [barChart setYValues:self.values];
  [barChart setStrokeColor:[UIColor colorWithHexString:@"#ccffff" alpha:0.5]];
  [barChart strokeChart];
  [self.scrollViewBarChart addSubview:barChart];
}

#pragma mark - 月与日滚动控件
- (void)setupMonthInScrollView {
  self.scrollViewMonth.contentSize =
      CGSizeMake(55 * 12, self.scrollViewMonth.frame.size.height);
  for (int i = 1; i <= 12; i++) {
    CGRect rect = CGRectMake((i - 1) * 55 + 5, 7, 45, 25);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = rect;
    [btn setBackgroundImage:[UIImage imageNamed:@"rq"]
                   forState:UIControlStateSelected];
    [btn setBackgroundImage:nil forState:UIControlStateNormal];
    [btn setTitle:[NSString stringWithFormat:@"%d月", i]
         forState:UIControlStateNormal];
    [btn addTarget:self
                  action:@selector(selectOneMonth:)
        forControlEvents:UIControlEventTouchUpInside];
    [self.scrollViewMonth addSubview:btn];
  }
}

- (void)setMonthsWithSelectedMonth:(NSUInteger)selectedMonth {
  UIButton *btn = (UIButton *)
      [[self.scrollViewMonth subviews] objectAtIndex:selectedMonth - 1];
  btn.selected = YES;
  self.btnSelectedMonth = btn;
  self.scrollViewMonth.contentOffset = CGPointMake((selectedMonth - 3) * 55, 0);
}

- (void)setupDayInScrollView {
  int days = 31;
  self.scrollViewDay.contentSize =
      CGSizeMake(55 * days, self.scrollViewDay.frame.size.height);
  for (int i = 1; i <= days; i++) {
    CGRect rect = CGRectMake((i - 1) * 55 + 5, 7, 45, 25);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = rect;
    [btn setBackgroundImage:[UIImage imageNamed:@"rq"]
                   forState:UIControlStateSelected];
    [btn setBackgroundImage:nil forState:UIControlStateNormal];
    [btn setTitle:[NSString stringWithFormat:@"%d日", i]
         forState:UIControlStateNormal];
    [btn addTarget:self
                  action:@selector(selectOneDay:)
        forControlEvents:UIControlEventTouchUpInside];
    [self.scrollViewDay addSubview:btn];
  }
}

- (void)setDays:(NSUInteger)days selectedDay:(NSUInteger)selectedDay {
  self.scrollViewDay.contentSize =
      CGSizeMake(55 * days, self.scrollViewDay.frame.size.height);
  for (int i = 28 + 1; i <= 31; i++) {
    //最后几个可能在之前被设置为隐藏，需要重新显示
    UIButton *btn =
        (UIButton *)[[self.scrollViewDay subviews] objectAtIndex:i - 1];
    btn.hidden = NO;
  }
  for (int i = days + 1; i <= 31; i++) {
    UIButton *btn =
        (UIButton *)[[self.scrollViewDay subviews] objectAtIndex:i - 1];
    btn.hidden = YES;
  }
  UIButton *btn =
      (UIButton *)[[self.scrollViewDay subviews] objectAtIndex:selectedDay - 1];
  btn.selected = YES;
  self.btnSelectedDay = btn;
  self.scrollViewDay.contentOffset = CGPointMake((selectedDay - 4) * 55, 0);
}

#pragma mark - 按钮事件
- (IBAction)selectMonth:(id)sender {
  [UIView animateWithDuration:kHistroryElecAnnimationInterval
                   animations:^{
                       self.btnMonth.selected = YES;
                       self.btnDay.selected = NO;
                       self.scrollViewDay.hidden = YES;
                   }];
  NSDate *date = [[NSDate date] dateBySettingMonth:self.selectedMonth];
  NSDateComponents *lastDayInMonth = [[date dateMonthEnd] dateComponentsDate];
  [self sendParam:1 endDay:lastDayInMonth.day];
}

- (IBAction)selectDay:(id)sender {
  [UIView animateWithDuration:kHistroryElecAnnimationInterval
                   animations:^{
                       self.btnDay.selected = YES;
                       self.btnMonth.selected = NO;
                       self.scrollViewDay.hidden = NO;
                   }];
  [self sendParam:self.selectedDay endDay:self.selectedDay];
}

- (IBAction)goPre:(id)sender {
  if (self.btnMonth.selected) {
    //选中的是月，跳转到前一月
  } else {
    //选中的是日，跳转到上一日
    if (self.selectedDay == 1) {
      //跳转到上一月的最后一天
      self.selectedMonth -= 1;

    } else {
      self.selectedDay -= 1;
      [UIView animateWithDuration:kHistroryElecAnnimationInterval
                       animations:^{//                self
                                  }];
    }
  }
}

- (IBAction)goNext:(id)sender {
  if (self.btnMonth.selected) {
    //选中的是月，跳转到下一月
  } else {
    //选中的是日，跳转到下一日
  }
}

//选中某个具体的日
- (void)selectOneDay:(id)sender {
  UIButton *btn = (UIButton *)sender;
  NSString *numString = [[[btn currentTitle]
      componentsSeparatedByCharactersInSet:
          [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
      componentsJoinedByString:@""];
  self.selectedDay = [numString intValue];
  if (self.btnSelectedDay != btn) {
    [UIView animateWithDuration:kHistroryElecAnnimationInterval
                     animations:^{
                         self.btnSelectedDay.selected = NO;
                         btn.selected = YES;
                         self.btnSelectedDay = btn;
                     }];
  }
  [self sendParam:self.selectedDay endDay:self.selectedDay];
}

//选中某个具体的月
- (void)selectOneMonth:(id)sender {
  UIButton *btn = (UIButton *)sender;
  NSString *numString = [[[btn currentTitle]
      componentsSeparatedByCharactersInSet:
          [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
      componentsJoinedByString:@""];
  self.selectedMonth = [numString intValue];
  //修改当前月份的天数选中数
  NSDate *date = [[NSDate date] dateBySettingMonth:self.selectedMonth];
  NSDateComponents *lastDayInMonth = [[date dateMonthEnd] dateComponentsDate];
  int selectedDay;
  //确定选中的天
  if (self.selectedDay > lastDayInMonth.day) {
    selectedDay = lastDayInMonth.day;
  } else {
    selectedDay = self.selectedDay;
  }
  [self setDays:lastDayInMonth.day selectedDay:selectedDay];
  //修改展现
  if (self.btnSelectedMonth != btn) {
    [UIView animateWithDuration:kHistroryElecAnnimationInterval
                     animations:^{
                         self.btnSelectedMonth.selected = NO;
                         btn.selected = YES;
                         self.btnSelectedMonth = btn;
                     }];
  }
  int startDay, endDay;
  //判断日是否显示
  if (self.btnDay.selected) {
    //查询时间为某月某日
    startDay = self.selectedDay;
    endDay = self.selectedDay;
  } else {
    //查询时间为某月
    startDay = 1;
    endDay = lastDayInMonth.day;
  }
  [self sendParam:startDay endDay:endDay];
}

- (void)sendParam:(int)startDay endDay:(int)endDay {
  if ([self.delegate respondsToSelector:@selector(currentYear:
                                                selectedMonth:
                                                     startDay:
                                                       endDay:)]) {
    [self.delegate currentYear:self.currentYear
                 selectedMonth:self.selectedMonth
                      startDay:startDay
                        endDay:endDay];
  }
}

@end
