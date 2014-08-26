//
//  HistoryElectricityViewController.m
//  SmartSwitch
//
//  Created by sdzg on 14-8-12.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "HistoryElectricityViewController.h"
#import "SwitchDataCeneter.h"
#import "HistoryElecView.h"
#import "HistoryElec.h"

@interface HistoryElectricityViewController ()<UdpRequestDelegate,
                                               HistoryElecViewDelegate>
@property(strong, nonatomic) IBOutlet HistoryElecView *viewOfHistoryElec;
@property(strong, nonatomic) HistoryElecParam *param;
@property(strong, nonatomic) HistoryElec *historyElec;

@property(strong, nonatomic) SDZGSwitch *aSwitch;
@property(strong, nonatomic) UdpRequest *request;
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

- (void)setup {
  self.viewOfHistoryElec.delegate = self;
  self.historyElec = [[HistoryElec alloc] init];
  NSDate *currentDate = [NSDate date];
  int currentYear = [currentDate year];
  int currentDay = [currentDate day];
  int currentMonth = [currentDate month];
  self.param = [self.historyElec getParam:currentYear
                            selectedMonth:currentMonth
                                 startDay:currentDay
                                   endDay:currentDay];
  [self senMsg63];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  self.aSwitch = [[SwitchDataCeneter sharedInstance].switchs
      objectAtIndex:[SwitchDataCeneter sharedInstance].selectedIndexPath.row];
  self.navigationItem.title = @"历史电量";
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
      initWithImage:[UIImage imageNamed:@"fh"]
              style:UIBarButtonItemStylePlain
             target:self.navigationController
             action:@selector(popViewControllerAnimated:)];
  [self setup];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)currentYear:(int)year
      selectedMonth:(int)selectedMonth
           startDay:(int)startDay
             endDay:(int)endDay {
  self.param = [self.historyElec getParam:year
                            selectedMonth:selectedMonth
                                 startDay:startDay
                                   endDay:endDay];
  [self senMsg63];
}

- (void)senMsg63 {
  if (!self.request) {
    self.request = [UdpRequest manager];
    self.request.delegate = self;
  }
  debugLog(@"begintime is %d and endtime is %f", (int)self.param.beginTime,
           self.param.endTime);
  [self.request sendMsg63:self.aSwitch
                beginTime:self.param.beginTime
                  endTime:self.param.endTime
                 interval:self.param.interval
                 sendMode:ActiveMode];
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
//- (void)pop:(id)sender {
//  [self.navigationController popViewControllerAnimated:YES];
//}

#pragma mark - UdpRequestDelegate
- (void)responseMsg:(CC3xMessage *)message address:(NSData *)address {
  switch (message.msgId) {
    case 0x64:
      if (message.state == 0) {
        //          message.historyElecCount
        //          message.historyElecs
        if (message.historyElecCount) {
          HistoryElecResponse *response =
              [message.historyElecs objectAtIndex:0];
          debugLog(@"time is %d", response.time);
        }
      }
      break;

    default:
      break;
  }
}
@end
