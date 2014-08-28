//
//  SwitchDetailViewController.m
//  SmartSwitch
//
//  Created by sdzg on 14-8-11.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "SwitchDetailViewController.h"
#import "SwitchDataCeneter.h"
#import "ElecRealTimeView.h"
#import "SocketView.h"
#import "DelayViewController.h"
#import "TimerViewController.h"
#define kElecRefreshInterval 2
#define kSwitchRefreshInterval 2

@interface SwitchDetailViewController ()<UIScrollViewDelegate,
                                         EGORefreshTableHeaderDelegate,
                                         UdpRequestDelegate, SocketViewDelegate>
@property(strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property(strong, nonatomic) IBOutlet UIView *contentView;
@property(strong, nonatomic) IBOutlet ElecRealTimeView *viewOfElecRealTime;
@property(strong, nonatomic) IBOutlet SocketView *viewSocket1;
@property(strong, nonatomic) IBOutlet SocketView *viewSocket2;
@property(strong, nonatomic) IBOutlet UILabel *lblCurrentValue;
- (IBAction)showHistoryElec:(id)sender;

@property(strong, nonatomic) EGORefreshTableHeaderView *refreshHeaderView;
@property(assign, nonatomic) BOOL reloading;
@property(strong, nonatomic) NSTimer *timerElec;
@property(strong, nonatomic) NSTimer *timerSwitch;
@property(strong, nonatomic) UdpRequest *request0BOr0D, *request33Or35,
    *request11Or13, *request17Or19, *request53Or55, *request5DOr5F;

//数据
@property(strong, nonatomic) NSMutableArray *powers;
@property(strong, nonatomic) SDZGSwitch *aSwitch;
@end

@implementation SwitchDetailViewController
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
  [self setupDefaultValue];

  self.navigationItem.title = self.aSwitch.name;
  self.navigationItem.leftBarButtonItem =
      [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fh"]
                                       style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(pop:)];
  self.navigationItem.rightBarButtonItem =
      [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"tj"]
                                       style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(showAddMenu:)];
  self.scrollView.delegate = self;

  self.refreshHeaderView = [[EGORefreshTableHeaderView alloc]
       initWithFrame:CGRectMake(0.0f, 0.0f - self.scrollView.bounds.size.height,
                                self.scrollView.frame.size.width,
                                self.scrollView.bounds.size.height)
      arrowImageName:@"whiteArrow"
           textColor:[UIColor whiteColor]];
  self.refreshHeaderView.backgroundColor = [UIColor clearColor];
  self.refreshHeaderView.delegate = self;
  [self.scrollView addSubview:self.refreshHeaderView];
  [self.refreshHeaderView refreshLastUpdatedDate];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self firstSend];
}

- (void)viewWillDisappear:(BOOL)animated {
  [self invalidateTimer];
  [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
}

- (void)setupDefaultValue {
  self.aSwitch = [[SwitchDataCeneter sharedInstance].switchs
      objectAtIndex:[SwitchDataCeneter sharedInstance].selectedIndexPath.row];
  self.powers = [@[] mutableCopy];
  // TODO: 名称从数据库中取
  SDZGSocket *socket1 = [self.aSwitch.sockets objectAtIndex:0];
  [self.viewSocket1 socketId:socket1.socketId
                  socketName:socket1.name
                      status:socket1.socketStatus
                       timer:0
                       delay:0];
  self.viewSocket1.delegate = self;

  SDZGSocket *socket2 = [self.aSwitch.sockets objectAtIndex:1];
  [self.viewSocket2 socketId:socket2.socketId
                  socketName:socket2.name
                      status:socket2.socketStatus
                       timer:0
                       delay:0];
  self.viewSocket2.delegate = self;

  self.viewOfElecRealTime.lblCurrent = self.lblCurrentValue;
}

- (void)firstSend {
  // TODO: 优先级 及时电量>名称>定时>延时>开关状态
  //  dispatch_queue_t queue =
  //      dispatch_queue_create("com.dispatch.serial", DISPATCH_QUEUE_SERIAL);

  dispatch_queue_t queue =
      dispatch_queue_create("com.itouchco.www", DISPATCH_QUEUE_CONCURRENT);
  static NSTimeInterval seconds = 0.5;

  //  dispatch_barrier_async(queue, ^{
  //      [self sendMsg0BOr0D];
  //      [NSThread sleepForTimeInterval:seconds];
  //  });
  //  dispatch_barrier_async(queue, ^{
  //      [self send17Or19];
  //      [NSThread sleepForTimeInterval:2 * seconds];
  //  });
  //  dispatch_barrier_async(queue, ^{
  //      [self sendMsg33Or35];
  //      [NSThread sleepForTimeInterval:seconds];
  //  });
  //  dispatch_barrier_async(queue, ^{
  //      [self send53Or55];
  //      [NSThread sleepForTimeInterval:2 * seconds];
  //  });
  //  dispatch_barrier_async(queue, ^{
  //      [self send5DOr5F];
  //      [NSThread sleepForTimeInterval:seconds];
  //  });

  [self setTimer];

  //  [self send5DOr5F];
}

#pragma mark - Timer
- (void)setTimer {
  self.timerElec = [NSTimer timerWithTimeInterval:kElecRefreshInterval
                                           target:self
                                         selector:@selector(sendMsg33Or35)
                                         userInfo:nil
                                          repeats:YES];
  [self.timerElec fire];
  [[NSRunLoop currentRunLoop] addTimer:self.timerElec
                               forMode:NSRunLoopCommonModes];

  //  self.timerSwitch = [NSTimer timerWithTimeInterval:kSwitchRefreshInterval
  //                                             target:self
  //                                           selector:@selector(sendMsg0BOr0D)
  //                                           userInfo:nil
  //                                            repeats:YES];
  //  [self.timerSwitch fire];
  //  [[NSRunLoop currentRunLoop] addTimer:self.timerSwitch
  //                               forMode:NSRunLoopCommonModes];
}

- (void)invalidateTimer {
  if (self.timerSwitch) {
    [self.timerSwitch invalidate];
    self.timerSwitch = nil;
  }
  if (self.timerElec) {
    [self.timerElec invalidate];
    self.timerElec = nil;
  }
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

- (void)showAddMenu:(id)sender {
  //  UIBarButtonItem *item = (UIBarButtonItem *)sender;
  [KxMenu setTintColor:[UIColor blackColor]];
  [KxMenu
      showMenuInView:self.view
            fromRect:CGRectMake(self.view.frame.size.width - 35, -20, 20, 20)
           menuItems:@[
                       [KxMenuItem menuItem:@"延时任务"
                                      image:[UIImage imageNamed:@"tjcj"]
                                     target:self
                                     action:@selector(menuItem1:)],
                       [KxMenuItem menuItem:@"定时任务"
                                      image:[UIImage imageNamed:@"tjcj"]
                                     target:self
                                     action:@selector(menuItem2:)],
                       [KxMenuItem menuItem:@"历史电量"
                                      image:[UIImage imageNamed:@"tjcj"]
                                     target:self
                                     action:@selector(menuItem3:)],
                       [KxMenuItem menuItem:@"开关名称"
                                      image:[UIImage imageNamed:@"tjcj"]
                                     target:self
                                     action:@selector(menuItem4:)]
                     ]];
}

- (void)menuItem1:(id)sender {
  //延时
  UIViewController *nextVC = [self.storyboard
      instantiateViewControllerWithIdentifier:@"DelayViewController"];
  [self.navigationController pushViewController:nextVC animated:YES];
}

- (void)menuItem2:(id)sender {
  //定时
  UIViewController *nextVC = [self.storyboard
      instantiateViewControllerWithIdentifier:@"TimerViewController"];
  [self.navigationController pushViewController:nextVC animated:YES];
}

- (void)menuItem3:(id)sender {
  //历史电量
}

- (void)menuItem4:(id)sender {
  //开关名称
  UIViewController *nextVC = [self.storyboard
      instantiateViewControllerWithIdentifier:@"SwitchInfoViewController"];
  [self.navigationController pushViewController:nextVC animated:YES];
}

#pragma mark Data Source Loading / Reloading Methods
- (void)reloadTableViewDataSource {
  //  should be calling your tableviews data source model to reload
  //  put here just for demo
  _reloading = YES;
}

- (void)doneLoadingTableViewData {
  //  model should call this when its done loading
  _reloading = NO;
  [_refreshHeaderView
      egoRefreshScrollViewDataSourceDidFinishedLoading:self.scrollView];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate {
  [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:
            (EGORefreshTableHeaderView *)view {
  [self reloadTableViewDataSource];
  [self performSelector:@selector(doneLoadingTableViewData)
             withObject:nil
             afterDelay:3.0];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:
            (EGORefreshTableHeaderView *)view {
  return _reloading;  // should return if data source model is reloading
}

- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:
                (EGORefreshTableHeaderView *)view {
  return [NSDate date];  // should return date data source was last changed
}
#pragma mark - 发送UDP
//开关状态
- (void)sendMsg0BOr0D {
  if (!self.request0BOr0D) {
    self.request0BOr0D = [UdpRequest manager];
    self.request0BOr0D.delegate = self;
  }
  [self.request0BOr0D sendMsg0BOr0D:self.aSwitch sendMode:ActiveMode];
}

//控制插孔开关
- (void)sendMsg11Or13:(int)socketId {
  if (!self.request11Or13) {
    self.request11Or13 = [UdpRequest manager];
    self.request11Or13.delegate = self;
  }
  [self.request11Or13 sendMsg11Or13:self.aSwitch
                           socketId:socketId
                           sendMode:ActiveMode];
}

//定时列表
- (void)send17Or19 {
  // TODO:修复
  //  dispatch_queue_t queue =
  //      dispatch_queue_create("timer.com.itouchco.www",
  //      DISPATCH_QUEUE_SERIAL);
  //  for (SDZGSocket *socket in self.aSwitch.sockets) {
  //    dispatch_async(queue, ^{
  //        self.request17Or19 = [UdpRequest manager];
  //        self.request17Or19.delegate = self;
  //        [self.request17Or19 sendMsg17Or19:self.aSwitch
  //                                 socketId:socket.socketId
  //                                 sendMode:ActiveMode];
  //        //        [NSThread sleepForTimeInterval:0.5];
  //    });
  //  }
  self.request17Or19 = [UdpRequest manager];
  self.request17Or19.delegate = self;
  [self.request17Or19 sendMsg17Or19:self.aSwitch
                           socketId:2
                           sendMode:ActiveMode];
}

//实时电量
- (void)sendMsg33Or35 {
  if (!self.request33Or35) {
    self.request33Or35 = [UdpRequest manager];
    self.request33Or35.delegate = self;
  }
  [self.request33Or35 sendMsg33Or35:self.aSwitch sendMode:ActiveMode];
}

//延时任务
- (void)send53Or55 {
  // TODO: 修改
  //  for (SDZGSocket *socket in self.aSwitch.sockets) {
  //    dispatch_queue_t queue = dispatch_queue_create("delay.com.itouchco.www",
  //                                                   DISPATCH_QUEUE_CONCURRENT);
  //    dispatch_barrier_async(queue, ^{
  //        self.request53Or55 = [UdpRequest manager];
  //        self.request53Or55.delegate = self;
  //        [self.request53Or55 sendMsg53Or55:self.aSwitch
  //                                 socketId:socket.socketId
  //                                 sendMode:ActiveMode];
  //        [NSThread sleepForTimeInterval:0.5];
  //    });
  //  }
  self.request53Or55 = [UdpRequest manager];
  self.request53Or55.delegate = self;
  [self.request53Or55 sendMsg53Or55:self.aSwitch
                           socketId:1
                           sendMode:ActiveMode];
}

//查询设备名称
- (void)send5DOr5F {
  self.request5DOr5F = [UdpRequest manager];
  self.request5DOr5F.delegate = self;
  [self.request5DOr5F sendMsg5DOr5F:self.aSwitch sendMode:ActiveMode];
}

#pragma mark - UdpRequestDelegate UDP响应
- (void)responseMsg:(CC3xMessage *)message address:(NSData *)address {
  switch (message.msgId) {
    case 0xc:
    case 0xe:
      self.aSwitch.name = message.deviceName;
      debugLog(@"message.onStatus is %d", message.onStatus);
      break;
    case 0x12:
    case 0x14:
      [self responseMsg12Or14:message];
      break;
    case 0x18:
    case 0x1a:
      switch (message.socketId) {
        case 1:

          break;
        case 2:

          break;
        default:
          break;
      }
      break;
    case 0x34:
    case 0x36:
      //      message.state;
      //      message.power;
      [self.powers addObject:@(message.power)];
      self.viewOfElecRealTime.powers = self.powers;
      break;
    case 0x54:
    case 0x56:
      switch (message.socketId) {
        case 1:
          if (message.delay) {
            [self.viewSocket1 countDown:message.delay * 60];
          }
          break;
        case 2:
          if (message.delay) {
            [self.viewSocket2 countDown:message.delay * 60];
          }
          break;
        default:
          break;
      }
      break;
    case 0x5e:
    case 0x60:
      if (![self.aSwitch.name isEqualToString:message.deviceName]) {
        self.aSwitch.name = message.deviceName;
        self.navigationItem.title = message.deviceName;
      }
      if (message.socketNames.count == 2) {
        [self.viewSocket1 setSocketName:message.socketNames[0]];
        [self.viewSocket2 setSocketName:message.socketNames[1]];
      }
      break;
    default:
      break;
  }
}

- (void)responseMsg12Or14:(CC3xMessage *)message {
  if (message.state == 0) {
    SDZGSocket *socket =
        [self.aSwitch.sockets objectAtIndex:(message.socketId - 1)];
    socket.socketStatus = !socket.socketStatus;
    switch (message.socketId) {
      case 1:
        [self.viewSocket1 setSocketStatus:socket.socketStatus];
        break;
      case 2:
        [self.viewSocket2 setSocketStatus:socket.socketStatus];
        break;
      default:
        break;
    }
  }
}

#pragma mark - SocketViewDelegate SocketView事件
- (void)socketTimer:(int)socketId {
  TimerViewController *nextVC = [self.storyboard
      instantiateViewControllerWithIdentifier:@"TimerViewController"];
  nextVC.socketId = socketId;
  nextVC.aSwitch = self.aSwitch;
  [self.navigationController pushViewController:nextVC animated:YES];
}

- (void)socketDelay:(int)socketId {
  DelayViewController *nextVC = [self.storyboard
      instantiateViewControllerWithIdentifier:@"DelayViewController"];
  nextVC.socketId = socketId;
  nextVC.aSwitch = self.aSwitch;
  [self.navigationController pushViewController:nextVC animated:YES];
}

- (void)socketChangeStatus:(int)socketId {
  [self sendMsg11Or13:socketId];
}

- (IBAction)showHistoryElec:(id)sender {
  UIViewController *nextVC =
      [self.storyboard instantiateViewControllerWithIdentifier:
                           @"HistoryElectricityViewController"];
  [self.navigationController pushViewController:nextVC animated:YES];
}
@end
