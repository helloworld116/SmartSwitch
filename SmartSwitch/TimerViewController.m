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
#define kAddTimer -1

@interface TimerViewController ()<UdpRequestDelegate, UIActionSheetDelegate>
@property(nonatomic, strong) UdpRequest *request;
@property(nonatomic, strong) NSMutableArray *timers;

@property(nonatomic, strong)
    NSIndexPath *editIndexPath;  //正在编辑或删除的indexPath
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
  self.timers = [@[] mutableCopy];
  self.request = [UdpRequest manager];
  self.request.delegate = self;
  [self sendMsg17Or19];
  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(addOrEditTimerNotification:)
             name:kAddOrEditTimerNotification
           object:nil];
  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(timerSwitchValueChanged:)
             name:kTimerSwitchValueChanged
           object:nil];
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

- (void)dealloc {
  [[NSNotificationCenter defaultCenter]
      removeObserver:self
                name:kAddOrEditTimerNotification
              object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:kTimerSwitchValueChanged
                                                object:nil];
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
  [nextVC setParamSwitch:self.aSwitch
                socketId:self.socketId
                  timers:self.timers
                   timer:timer
                   index:indexPath.row];
  [self.navigationController pushViewController:nextVC animated:YES];
}

#pragma mark - UINavigationBar
- (void)addTimer:(id)sender {
  TimerEditViewController *nextVC = [self.storyboard
      instantiateViewControllerWithIdentifier:@"TimerEditViewController"];
  [nextVC setParamSwitch:self.aSwitch
                socketId:self.socketId
                  timers:self.timers
                   timer:nil
                   index:kAddTimer];
  [self.navigationController pushViewController:nextVC animated:YES];
}

#pragma mark - SceneListCellHandler
- (void)handlerLongPress:(UILongPressGestureRecognizer *)gestureRecognizer {
  CGPoint p = [gestureRecognizer locationInView:self.view];
  NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];
  if (indexPath && gestureRecognizer.state == UIGestureRecognizerStateBegan) {
    self.editIndexPath = indexPath;
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
  if (buttonIndex == 0) {
    //删除
    [self.timers removeObjectAtIndex:self.editIndexPath.row];
    [self sendMsg1DOr1F];
  }
}

#pragma mark - AddOrEditTimerNotification
- (void)addOrEditTimerNotification:(NSNotification *)notification {
  NSDictionary *userIofo = [notification userInfo];
  int type = [[userIofo objectForKey:@"type"] intValue];
  NSIndexPath *indexPath;
  NSString *message;
  switch (type) {
    case kAddTimer:
      message = @"添加成功";
      indexPath =
          [NSIndexPath indexPathForRow:self.timers.count - 1 inSection:0];
      [self.tableView beginUpdates];
      [self.tableView insertRowsAtIndexPaths:@[ indexPath ]
                            withRowAnimation:UITableViewRowAnimationRight];
      [self.tableView endUpdates];
      break;
    default:
      message = @"修改成功";
      indexPath = [NSIndexPath indexPathForRow:type inSection:0];
      [self.tableView reloadRowsAtIndexPaths:@[ indexPath ]
                            withRowAnimation:UITableViewRowAnimationAutomatic];
      break;
  }
  [self.view
      makeToast:message
       duration:1.f
       position:[NSValue
                    valueWithCGPoint:CGPointMake(
                                         self.view.frame.size.width / 2,
                                         self.view.frame.size.height - 40)]];
}

- (void)timerSwitchValueChanged:(NSNotification *)notification {
}

#pragma mark - 定时列表查询请求
- (void)sendMsg17Or19 {
  [self.request sendMsg17Or19:self.aSwitch
                     socketId:self.socketId
                     sendMode:ActiveMode];
}

- (void)sendMsg1DOr1F {
  [self.request sendMsg1DOr1F:self.aSwitch
                     socketId:self.socketId
                     timeList:self.timers
                     sendMode:ActiveMode];
}

#pragma mark - UdpRequest代理
- (void)responseMsg:(CC3xMessage *)message address:(NSData *)address {
  switch (message.msgId) {
    //查询定时
    case 0x18:
    case 0x1a:
      [self responseMsg18Or1A:message];
      break;
    //设置定时
    case 0x1e:
    case 0x20:
      [self responseMsg1EOr20:message];
      break;
    default:
      break;
  }
}

- (void)responseMsg18Or1A:(CC3xMessage *)message {
  if (message.timerTaskList) {
    [self.timers addObjectsFromArray:message.timerTaskList];
  }
  dispatch_async(dispatch_get_main_queue(), ^{
      if (self.timers.count) {
        [self.tableView reloadData];
      }
  });
}

- (void)responseMsg1EOr20:(CC3xMessage *)message {
  if (message.state == 0) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[ self.editIndexPath ]
                              withRowAnimation:UITableViewRowAnimationLeft];
        [self.tableView endUpdates];
    });
  }
}
@end
