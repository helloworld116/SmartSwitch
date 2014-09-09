//
//  SwitchAndSceneViewController.m
//  SmartSwitch
//
//  Created by sdzg on 14-8-6.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "SwitchAndSceneViewController.h"
#import "SwitchTableView.h"
#import "SceneTableView.h"
#import "SwitchDataCeneter.h"
#import "SceneDataCenter.h"
#import "AddSenceViewController.h"
#import "SceneActionView.h"

@interface SwitchAndSceneViewController ()<
    UIScrollViewDelegate, UdpRequestDelegate, SwitchTableViewDelegate,
    SceneTableViewDelegate, SceneActionViewDelegate>
@property(strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property(strong, nonatomic) SwitchTableView *tableViewOfSwitch;
@property(strong, nonatomic) SceneTableView *tableViewOfScene;
@property(strong, nonatomic) IBOutlet UIButton *btnSwitch;
@property(strong, nonatomic) IBOutlet UIButton *btnScene;
@property(strong, nonatomic) IBOutlet SceneActionView *viewOfSceneAction;

@property(strong, nonatomic) NSTimer *updateTimer;
@property(strong, nonatomic) UdpRequest *request0BOr0D, *request11Or13;
@property(strong, nonatomic) NSArray *switchs;

- (IBAction)showSwitchView:(id)sender;
- (IBAction)showSceneView:(id)sender;

- (IBAction)showMenu:(id)sender;
- (IBAction)showAddMenu:(id)sender;
@end

@implementation SwitchAndSceneViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)setup {
  self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * 2,
                                           self.scrollView.frame.size.height);
  self.scrollView.delegate = self;
  UITableView *switchTableView =
      ((UITableViewController *)
       [self.storyboard instantiateViewControllerWithIdentifier:
                            @"SwitchListTableViewController"]).tableView;
  self.tableViewOfSwitch = (SwitchTableView *)switchTableView;
  self.tableViewOfSwitch.switchTableViewDelegate = self;
  [self.scrollView addSubview:switchTableView];

  self.switchs = [SwitchDataCeneter sharedInstance].switchs;
  if (self.switchs) {
    [[NSNotificationCenter defaultCenter] postNotificationName:kSwitchUpdate
                                                        object:self
                                                      userInfo:nil];
  }
  //场景执行页面
  self.viewOfSceneAction.delegate = self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setup];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  if (![self.sidePanelController leftPanel]) {
    [self.sidePanelController
        setLeftPanel:kSharedAppliction.leftViewController];
    [self.sidePanelController showLeftPanelAnimated:YES];
  }
  //查询开关状态
  [self updateSwitchStatus];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  self.tableViewOfSwitch.frame = self.scrollView.bounds;
}

- (void)viewWillDisappear:(BOOL)animated {
  [self.updateTimer invalidate];
  [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - 导航栏菜单
- (IBAction)showSwitchView:(id)sender {
  self.btnSwitch.selected = YES;
  self.btnScene.selected = NO;
  self.scrollView.contentOffset = CGPointMake(0, 0);
}

- (IBAction)showSceneView:(id)sender {
  self.btnSwitch.selected = NO;
  self.btnScene.selected = YES;
  if (!self.tableViewOfScene) {
    UITableView *sceneTableView =
        ((UITableViewController *)
         [self.storyboard instantiateViewControllerWithIdentifier:
                              @"SceneListTableViewController"]).tableView;
    sceneTableView.frame = CGRectMake(self.scrollView.frame.size.width, 0,
                                      self.scrollView.frame.size.width,
                                      self.scrollView.frame.size.height);

    self.tableViewOfScene = (SceneTableView *)sceneTableView;
    self.tableViewOfScene.sceneDelegate = self;
    [self.scrollView addSubview:sceneTableView];
  }
  self.scrollView.contentOffset =
      CGPointMake(self.scrollView.frame.size.width, 0);
}

- (IBAction)showMenu:(id)sender {
  if ([self.sidePanelController visiblePanel] ==
      kSharedAppliction.leftViewController) {
    [self.sidePanelController showCenterPanelAnimated:YES];
  } else {
    [self.sidePanelController showLeftPanelAnimated:YES];
  }
}

- (IBAction)showAddMenu:(id)sender {
  //  UIBarButtonItem *item = (UIBarButtonItem *)sender;
  [KxMenu setTintColor:[UIColor blackColor]];
  [KxMenu
      showMenuInView:self.view
            fromRect:CGRectMake(self.view.frame.size.width - 35, -20, 20, 20)
           menuItems:@[
                       [KxMenuItem menuItem:@"添加开关"
                                      image:[UIImage imageNamed:@"tjkg"]
                                     target:self
                                     action:@selector(menuItemSocket:)],
                       [KxMenuItem menuItem:@"添加场景"
                                      image:[UIImage imageNamed:@"tjcj"]
                                     target:self
                                     action:@selector(menuItemSence:)]
                     ]];
}

- (void)menuItemSocket:(id)sender {
  UIViewController *nextVC = [self.storyboard
      instantiateViewControllerWithIdentifier:@"AddSwitchNavController"];
  [self presentViewController:nextVC animated:YES completion:^{}];
}

- (void)menuItemSence:(id)sender {
  UIViewController *nextVC = [self.storyboard
      instantiateViewControllerWithIdentifier:@"AddSenceNavController"];
  [self presentViewController:nextVC animated:YES completion:^{}];
}

#pragma mark - SwitchTableViewDelegate
- (void)showSwitchDetail:(NSIndexPath *)indexPath {
  UIViewController *nextVC = [self.storyboard
      instantiateViewControllerWithIdentifier:@"SwitchDetailViewController"];
  [self.navigationController pushViewController:nextVC animated:YES];
}

- (void)socketAction:(SDZGSwitch *)aSwitch socketId:(int)socketId {
  [self sendMsg11Or13:aSwitch socketId:socketId];
}

#pragma mark - SceneTableViewDelegate
- (void)showSceneDetail:(NSIndexPath *)indexPath {
  AddSenceViewController *nextVC = [self.storyboard
      instantiateViewControllerWithIdentifier:@"AddSenceViewController"];
  nextVC.scene =
      [[[SceneDataCenter sharedInstance] scenes] objectAtIndex:indexPath.row];
  nextVC.type = 3;
  [self.navigationController pushViewController:nextVC animated:YES];
}

- (void)sceneAction:(NSIndexPath *)indexPath {
  debugLog(@"%s", __func__);
  Scene *scene =
      [[[SceneDataCenter sharedInstance] scenes] objectAtIndex:indexPath.row];
  self.viewOfSceneAction.sceneDetails = scene.detailList;
  CGRect rect =
      CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
  [UIView animateWithDuration:0.3f
                   animations:^{ self.viewOfSceneAction.frame = rect; }];
}

#pragma mark - SceneActionViewDelegate
- (void)cancelAction {
  CGRect rect =
      CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width,
                 self.view.frame.size.height);
  [UIView animateWithDuration:0.3f
                   animations:^{ self.viewOfSceneAction.frame = rect; }];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  double i = scrollView.contentOffset.x / (self.view.bounds.size.width);
  if (i == 0) {
    [self showSwitchView:nil];
  } else if (i == 1) {
    [self showSceneView:nil];
  }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate {
  double i = scrollView.contentOffset.x / (self.view.bounds.size.width);
  if (i < 0) {
    [self showMenu:nil];
  }
}

#pragma mark -
//更新设备状态
- (void)updateSwitchStatus {
  if (self.updateTimer) {
    [self.updateTimer invalidate];
    _updateTimer = nil;
  }
  self.updateTimer = [NSTimer timerWithTimeInterval:REFRESH_DEV_TIME
                                             target:self
                                           selector:@selector(sendMsg0BOr0D)
                                           userInfo:nil
                                            repeats:YES];
  [self.updateTimer fire];
  [[NSRunLoop currentRunLoop] addTimer:self.updateTimer
                               forMode:NSRunLoopCommonModes];
}
//扫描设备
- (void)sendMsg0BOr0D {
  //先局域网内扫描，1秒后内网没有响应的请求外网，更新设备状态
  if (!self.request0BOr0D) {
    self.request0BOr0D = [[UdpRequest alloc] init];
    self.request0BOr0D.delegate = self;
  }
  [self.request0BOr0D sendMsg0B:ActiveMode];

  //  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC),
  //                 GLOBAL_QUEUE, ^{
  //      NSArray *macs = [self.switchDict allKeys];
  //      int j = 0;
  //      for (int i = 0; i < macs.count; i++) {
  //        NSString *mac = [[self.switchDict allKeys] objectAtIndex:i];
  //        CC3xSwitch *aSwitch = [self.switchDict objectForKey:mac];
  //        if (aSwitch.status != SWITCH_LOCAL &&
  //            aSwitch.status != SWITCH_LOCAL_LOCK) {
  //          [[MessageUtil shareInstance] sendMsg0D:self.udpSocket
  //                                             mac:mac
  //                                        sendMode:ActiveMode];
  //          double delayInSeconds = 0.5 * j +
  //          kCheckPublicPrivateResponseInterval;
  //          //外网每个延迟0.5秒发送请求
  //          dispatch_time_t delayInNanoSeconds =
  //              dispatch_time(DISPATCH_TIME_NOW, delayInSeconds *
  //              NSEC_PER_SEC);
  //          dispatch_after(delayInNanoSeconds, GLOBAL_QUEUE, ^{
  //              [[MessageUtil shareInstance] sendMsg0D:self.udpSocket
  //                                                 mac:mac
  //                                            sendMode:ActiveMode];
  //          });
  //          j++;
  //        }
  //      }
  //  });
}

- (void)sendMsg11Or13:(SDZGSwitch *)aSwitch socketId:(int)socketId {
  if (!self.request11Or13) {
    self.request11Or13 = [UdpRequest manager];
    self.request11Or13.delegate = self;
  }

  [self.request11Or13 sendMsg11Or13:aSwitch
                           socketId:socketId
                           sendMode:ActiveMode];
}

#pragma mark - UdpRequestDelegate
- (void)responseMsg:(CC3xMessage *)message address:(NSData *)address {
  switch (message.msgId) {
    case 0xc:
    case 0xe:
      [self responseMsgCOrE:message];
      break;
    case 0x12:
    case 0x14:
      [self responseMsg12Or14:message];
      break;
    default:
      break;
  }
}

- (void)responseMsg12Or14:(CC3xMessage *)message {
  if (message.state == 0) {
    NSArray *switchs = [[SwitchDataCeneter sharedInstance] switchs];
    SDZGSwitch *editSwitch;
    for (SDZGSwitch *aSwitch in switchs) {
      if ([message.mac isEqualToString:aSwitch.mac]) {
        editSwitch = aSwitch;
        break;
      }
    }
    SDZGSocket *socket =
        [editSwitch.sockets objectAtIndex:(message.socketId - 1)];
    [[SwitchDataCeneter sharedInstance] updateSocketStaus:!socket.socketStatus
                                                 socketId:socket.socketId
                                                      mac:message.mac];
    [[NSNotificationCenter defaultCenter] postNotificationName:kSwitchUpdate
                                                        object:self
                                                      userInfo:nil];
  }
}

- (void)responseMsgCOrE:(CC3xMessage *)message {
  if (message.version == 2 && message.state == 0) {
    SDZGSwitch *aSwitch = [SDZGSwitch parseMessageCOrEToSwitch:message];
    [[SwitchDataCeneter sharedInstance] updateSwitch:aSwitch];
    [[NSNotificationCenter defaultCenter] postNotificationName:kSwitchUpdate
                                                        object:self
                                                      userInfo:nil];
  }
}
@end
