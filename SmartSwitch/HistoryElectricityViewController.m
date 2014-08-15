//
//  HistoryElectricityViewController.m
//  SmartSwitch
//
//  Created by sdzg on 14-8-12.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "HistoryElectricityViewController.h"
#import <PNChart.h>
#import <NSDate+Calendar.h>
#define kBarWidth 25

@interface HistoryElectricityViewController ()
@property(strong, nonatomic) IBOutlet UIScrollView *scrollViewMonth;
@property(strong, nonatomic) IBOutlet UIScrollView *scrollViewDay;
@property(strong, nonatomic) IBOutlet UIScrollView *scrollViewBarChart;
@property(strong, nonatomic) IBOutlet UIView *viewImgContainer;

@property(strong, nonatomic) NSArray *times;
@property(strong, nonatomic) NSArray *values;

@end

@implementation HistoryElectricityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  self.navigationItem.title = @"历史电量";
  self.navigationItem.leftBarButtonItem =
      [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fh"]
                                       style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(pop:)];
  self.times = @[
    @"1",
    @"2",
    @"3",
    @"4",
    @"5",
    @"6",
    @"7",
    @"8",
    @"9",
    @"10",
    @"11",
    @"12",
    @"13",
    @"14"
  ];
  self.values =
      @[ @1, @24, @12, @18, @30, @10, @21, @1, @24, @12, @18, @30, @10, @21 ];
  NSDate *currentDate = [NSDate date];
  [self setMonthsWithSelectedMonth:[currentDate month]];
  NSDateComponents *lastDayInMonth =
      [[currentDate dateMonthEnd] dateComponentsDate];
  [self setDays:lastDayInMonth.day selectedDay:[currentDate day]];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  CGFloat width = (self.times.count * 1.5) * kBarWidth;
  self.scrollViewBarChart.contentSize =
      CGSizeMake(width, self.scrollViewBarChart.frame.size.height);
  PNBarChart *barChart = [[PNBarChart alloc]
      initWithFrame:CGRectMake(0, 0, width,
                               self.scrollViewBarChart.frame.size.height + 24)];
  barChart.backgroundColor = [UIColor clearColor];
  barChart.barBackgroundColor =
      [UIColor colorWithHexString:@"#99ccff" alpha:0.1];
  //    [UIColor colorWithHex:0x99ccff alpha:0.1];
  barChart.yLabelFormatter = ^(CGFloat yValue) {
      CGFloat yValueParsed = yValue;
      NSString *labelText = [NSString stringWithFormat:@"%1.fw", yValueParsed];
      //      NSLog(@".....is %@", labelText);
      return labelText;
  };
  //  barChart.labelMarginTop = 5.0;
  barChart.yLabelSum = 5;
  //  barChart.showLabel = NO;
  barChart.yChartLabelWidth = 0.f;
  //  barChart.labelMarginTop = 0.f;
  barChart.barWidth = kBarWidth;
  barChart.labelTextColor = [UIColor whiteColor];
  [barChart setXLabels:self.times];
  [barChart setYValues:self.values];
  [barChart setStrokeColor:[UIColor colorWithHexString:@"#ccffff" alpha:0.5]];
  [barChart strokeChart];

  //    barChart.delegate = self;
  [self.scrollViewBarChart addSubview:barChart];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - 导航栏事件
- (void)pop:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)setMonthsWithSelectedMonth:(NSUInteger)selectedMonth {
  if ([[self.scrollViewMonth subviews] count]) {
  } else {
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
      if (i == selectedMonth) {
        btn.selected = YES;
      }
      [self.scrollViewMonth addSubview:btn];
    }
  }
  self.scrollViewMonth.contentOffset = CGPointMake((selectedMonth - 3) * 55, 0);
}

- (void)setDays:(NSUInteger)days selectedDay:(NSUInteger)selectedDay {
  if ([[self.scrollViewDay subviews] count]) {
  } else {
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
      if (i == selectedDay) {
        btn.selected = YES;
      }
      [self.scrollViewDay addSubview:btn];
    }
  }
  self.scrollViewDay.contentOffset = CGPointMake((selectedDay - 4) * 55, 0);
}
@end
