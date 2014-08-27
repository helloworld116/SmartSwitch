//
//  TimerViewController.m
//  SmartSwitch
//
//  Created by sdzg on 14-8-13.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "TimerViewController.h"
#import "TimerCell.h"
#import "TimerEditViewController.h"

@interface TimerViewController ()<UdpRequestDelegate, UIActionSheetDelegate>
@property (nonatomic, strong) UdpRequest *request;
@property (nonatomic, strong) NSArray *timers;
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
  //增加长按事件
  UILongPressGestureRecognizer *longPressGesture =
      [[UILongPressGestureRecognizer alloc]
          initWithTarget:self
                  action:@selector(handlerLongPress:)];
  longPressGesture.minimumPressDuration = 0.5;
  [cell addGestureRecognizer:longPressGesture];
  return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  SDZGTimerTask *timer = [self.timers objectAtIndex:indexPath.row];
  TimerEditViewController *nextVC = [self.storyboard
      instantiateViewControllerWithIdentifier:@"TimerEditViewController"];
  nextVC.timers = self.timers;
  nextVC.timer = timer;
  [self.navigationController pushViewController:nextVC animated:YES];
}

#pragma mark - UINavigationBar
- (void)addTimer:(id)sender {
  TimerEditViewController *nextVC = [self.storyboard
      instantiateViewControllerWithIdentifier:@"TimerEditViewController"];
  nextVC.timers = self.timers;
  [self.navigationController pushViewController:nextVC animated:YES];
}

#pragma mark - SceneListCellHandler
- (void)handlerLongPress:(UILongPressGestureRecognizer *)gestureRecognizer {
  CGPoint p = [gestureRecognizer locationInView:self.view];
  NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];
  if (indexPath && gestureRecognizer.state == UIGestureRecognizerStateBegan) {
    debugLog(@"indexPath is %d", indexPath.row);
    UIActionSheet *actionSheet =
        [[UIActionSheet alloc] initWithTitle:@"确定删除定时列表"
                                    delegate:self
                           cancelButtonTitle:@"取消"
                      destructiveButtonTitle:nil
                           otherButtonTitles:@"删除", nil];
    [actionSheet showInView:self.view];
  }
}

- (void)actionSheet:(UIActionSheet *)actionSheet
    clickedButtonAtIndex:(NSInteger)buttonIndex {
  NSLog(@"index is %d", buttonIndex);
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
