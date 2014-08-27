//
//  TimerEditViewController.m
//  SmartSwitch
//
//  Created by sdzg on 14-8-14.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "TimerEditViewController.h"
#import "CycleViewController.h"

@interface TimerEditViewController ()<PassValueDelegate>
@property (strong, nonatomic) IBOutlet UIView *cellView1;
@property (strong, nonatomic) IBOutlet UIView *cellView2;
@property (strong, nonatomic) IBOutlet UIView *cellView3;
@property (strong, nonatomic) IBOutlet UILabel *lblTime;
@property (strong, nonatomic) IBOutlet UILabel *lblRepeatDesc;
@property (strong, nonatomic) IBOutlet UISwitch *_switch;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
- (IBAction)switchValueChanged:(id)sender;
- (IBAction)showDatePicker:(id)sender;
- (IBAction)changeWeek:(id)sender;
- (IBAction)touchBackground:(id)sender;
- (IBAction)timeValueChanged:(id)sender;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@end

@implementation TimerEditViewController

- (void)setup {
  self.cellView1.layer.borderWidth = 1.0f;
  self.cellView1.layer.borderColor = [UIColor lightGrayColor].CGColor;
  self.cellView1.layer.cornerRadius = 1.5f;
  self.cellView2.layer.borderWidth = 1.0f;
  self.cellView2.layer.borderColor = [UIColor lightGrayColor].CGColor;
  self.cellView2.layer.cornerRadius = 1.5f;
  self.cellView3.layer.borderWidth = 1.0f;
  self.cellView3.layer.borderColor = [UIColor lightGrayColor].CGColor;
  self.cellView3.layer.cornerRadius = 1.5f;
  //设置公用的时间选择器
  self.dateFormatter = [[NSDateFormatter alloc] init];
  [self.dateFormatter setDateFormat:@"HH:mm"];
  if (!self.timer) {
    // timer不存在，则表明正在进行添加操作
    self.timer = [[SDZGTimerTask alloc] init];
    self.timer.timerActionType = TimerActionTypeOn; //默认开
  }
  self.lblTime.text = [self.timer actionTimeString];
  self.lblRepeatDesc.text = [self.timer actionWeekString];
  self._switch.on = self.timer.timerActionType;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.navigationItem.title = @"定时任务";
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
      initWithImage:[UIImage imageNamed:@"fh"]
              style:UIBarButtonItemStylePlain
             target:self.navigationController
             action:@selector(popViewControllerAnimated:)];
  self.navigationItem.rightBarButtonItem =
      [[UIBarButtonItem alloc] initWithTitle:@"保存"
                                       style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(save:)];
  [self setup];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - UINavigationBar事件
- (void)save:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
- (IBAction)showDatePicker:(id)sender {
  [UIView animateWithDuration:0.3
                   animations:^{
                       NSDate *defaultDate = [self.dateFormatter
                           dateFromString:[self.timer actionTimeString]];
                       self.datePicker.date = defaultDate;
                       self.datePicker.hidden = NO;
                   }];
}

- (IBAction)changeWeek:(id)sender {
  if (!self.datePicker.hidden) {
    [UIView animateWithDuration:0.3
                     animations:^{ self.datePicker.hidden = YES; }];
  }
  CycleViewController *nextVC = [self.storyboard
      instantiateViewControllerWithIdentifier:@"CycleViewController"];
  nextVC.week = self.timer.week;
  nextVC.delegate = self;
  [self.navigationController pushViewController:nextVC animated:YES];
}

- (IBAction)touchBackground:(id)sender {
  if (!self.datePicker.hidden) {
    [UIView animateWithDuration:0.3
                     animations:^{ self.datePicker.hidden = YES; }];
  }
}

- (IBAction)timeValueChanged:(id)sender {
  //时间选择时，输出格式
  NSString *dateString =
      [self.dateFormatter stringFromDate:self.datePicker.date];
  self.lblTime.text = dateString;
}

- (IBAction)switchValueChanged:(id)sender {
}

#pragma mark - PassValueDelegate
- (void)passValue:(id)value {
  int week = [value intValue];
  self.timer.week = week;
  self.lblRepeatDesc.text = [self.timer actionWeekString];
}
@end