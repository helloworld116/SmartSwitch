//
//  SwitchDetailViewController.m
//  SmartSwitch
//
//  Created by sdzg on 14-8-11.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "SwitchDetailViewController.h"
#import "SwitchDataCeneter.h"

@interface SwitchDetailViewController ()<UIScrollViewDelegate,
                                         EGORefreshTableHeaderDelegate>
@property(strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property(strong, nonatomic) IBOutlet UIView *contentView;

@property(strong, nonatomic) EGORefreshTableHeaderView *refreshHeaderView;
@property(assign, nonatomic) BOOL reloading;

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
  self.aSwitch = [[SwitchDataCeneter sharedInstance].switchs
      objectAtIndex:[SwitchDataCeneter sharedInstance].selectedIndexPath.row];

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

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
}

- (void)firstSend {
  //  [self sendMsg0BOr0D];
  //  [self send17Or19];
  //  [self sendMsg33Or35];
  //  [self send53Or55];
  [self send5DOr5F];
}

//开关状态
- (void)sendMsg0BOr0D {
  [[UdpRequest sharedInstance] sendMsg0BOr0D:self.aSwitch
                                    sendMode:ActiveMode
                                successBlock:^(CC3xMessage *message) {}
                             noResponseBlock:nil
                              noRequestBlock:nil
                                  errorBlock:nil];
}

//控制插孔开关
- (void)sendMsg11Or13:(int)socketId {
  [[UdpRequest sharedInstance] sendMsg11Or13:self.aSwitch
                                    socketId:1
                                    sendMode:ActiveMode
                                successBlock:^(CC3xMessage *message) {}
                             noResponseBlock:nil
                              noRequestBlock:nil
                                  errorBlock:nil];
}

//定时列表
- (void)send17Or19 {
  for (SDZGSocket *socket in self.aSwitch.sockets) {
    [[UdpRequest sharedInstance] sendMsg17Or19:self.aSwitch
                                      socketId:socket.socketId
                                      sendMode:ActiveMode
                                  successBlock:^(CC3xMessage *message) {}
                               noResponseBlock:nil
                                noRequestBlock:nil
                                    errorBlock:nil];
  }
}

//实时电量
- (void)sendMsg33Or35 {
  [[UdpRequest sharedInstance] sendMsg33Or35:self.aSwitch
                                    sendMode:ActiveMode
                                successBlock:^(CC3xMessage *message) {}
                             noResponseBlock:nil
                              noRequestBlock:nil
                                  errorBlock:nil];
}

//延时任务
- (void)send53Or55 {
  for (SDZGSocket *socket in self.aSwitch.sockets) {
    [[UdpRequest sharedInstance] sendMsg53Or55:self.aSwitch
                                      socketId:socket.socketId
                                      sendMode:ActiveMode
                                  successBlock:^(CC3xMessage *message) {}
                               noResponseBlock:nil
                                noRequestBlock:nil
                                    errorBlock:nil];
  }
}

//查询设备名称
- (void)send5DOr5F {
  [[UdpRequest sharedInstance] sendMsg5DOr5F:self.aSwitch
                                    sendMode:ActiveMode
                                successBlock:^(CC3xMessage *message) {}
                             noResponseBlock:nil
                              noRequestBlock:nil
                                  errorBlock:nil];
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
  UIViewController *nextVC =
      [self.storyboard instantiateViewControllerWithIdentifier:
                           @"HistoryElectricityViewController"];
  [self.navigationController pushViewController:nextVC animated:YES];
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
@end
