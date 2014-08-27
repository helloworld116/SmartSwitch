//
//  TimerViewController.m
//  SmartSwitch
//
//  Created by sdzg on 14-8-13.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "TimerViewController.h"
#import "TimerCell.h"

@interface TimerViewController ()<UdpRequestDelegate>
@property(nonatomic, strong) UdpRequest *request;
@property(nonatomic, strong) NSArray *timers;
@end

@implementation TimerViewController

- (id)initWithStyle:(UITableViewStyle)style {
  self = [super initWithStyle:style];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)setup {
  self.request = [UdpRequest manager];
  self.request.delegate = self;
  [self sendMsg17Or19];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationItem.title = @"定时列表";
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
      initWithImage:[UIImage imageNamed:@"fh"]
              style:UIBarButtonItemStylePlain
             target:self.navigationController
             action:@selector(popViewControllerAnimated:)];
  self.navigationItem.rightBarButtonItem =
      [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"tj"]
                                       style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(addTimer:)];
  [self setup];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  return self.timers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellId = @"TimerCell";
  TimerCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId
                                                    forIndexPath:indexPath];

  SDZGTimerTask *task = [self.timers objectAtIndex:indexPath.row];
  [cell setCellInfo:task];
  return cell;
}

#pragma mark - UINavigationBar
- (void)addTimer:(id)sender {
  UIViewController *nextVC = [self.storyboard
      instantiateViewControllerWithIdentifier:@"TimerEditViewController"];
  [self.navigationController pushViewController:nextVC animated:YES];
}

#pragma mark - 定时列表查询请求
- (void)sendMsg17Or19 {
  [self.request sendMsg17Or19:self.aSwitch
                     socketId:self.socketId
                     sendMode:ActiveMode];
}

#pragma mark - UdpRequest代理
- (void)responseMsg:(CC3xMessage *)message address:(NSData *)address {
  switch (message.msgId) {
    //设置延时
    case 0x18:
    case 0x1a:
      [self responseMsg18Or1A:message];
      break;
    default:
      break;
  }
}

- (void)responseMsg18Or1A:(CC3xMessage *)message {
  self.timers = message.timerTaskList;
  debugLog(@"timers is %@", self.timers);
  dispatch_async(dispatch_get_main_queue(), ^{ [self.tableView reloadData]; });
}
@end
