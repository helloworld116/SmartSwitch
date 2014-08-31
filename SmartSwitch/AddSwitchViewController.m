//
//  AddSwitchViewController.m
//  SmartSwitch
//
//  Created by sdzg on 14-8-6.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "AddSwitchViewController.h"
#import <GCDAsyncUdpSocket.h>

@interface AddSwitchViewController ()<UITextFieldDelegate, UdpRequestDelegate,
                                      GCDAsyncUdpSocketDelegate>
@property(strong, nonatomic) IBOutlet UIView *contentView;
@property(strong, nonatomic) IBOutlet UITextField *textWIFI;
@property(strong, nonatomic) IBOutlet UITextField *textPassword;
@property(strong, nonatomic) IBOutlet UIButton *btnShowPassword;  //展示选中图片
@property(strong, nonatomic) IBOutlet UIView *viewOfLoading;
@property(strong, nonatomic) IBOutlet UIView *viewOfInput;
@property(nonatomic, strong) IBOutlet UIProgressView *progressView;
@property(nonatomic, strong) IBOutlet UILabel *lblMessage;

@property(assign, nonatomic) BOOL isShowPassword;
@property(strong, nonatomic) FirstTimeConfig *config;
@property(strong, nonatomic) NSString *wifi;
@property(strong, nonatomic) NSString *password;
//为设备设置好wifi后，会多次收到设备wifi配置成功的消息，只在第一次配置成功的时候处理
@property(assign, atomic) int count;
@property(strong, nonatomic) UdpRequest *request;
@property(strong, nonatomic) GCDAsyncUdpSocket *socket;
@property(strong, nonatomic) NSTimer *timer;

- (IBAction)showOrHiddenPassword:(id)sender;
- (IBAction)doConfig:(id)sender;
- (IBAction)back:(id)sender;
- (IBAction)touchBackground:(id)sender;
- (IBAction)stopConfig:(id)sender;
@end

@implementation AddSwitchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)setup {
  [self.sidePanelController setLeftPanel:nil];
  self.textWIFI.delegate = self;
  self.textPassword.delegate = self;
  if (is4Inch) {
    CGRect rect = self.contentView.frame;
    rect.size = CGSizeMake(rect.size.width, rect.size.width + 88.f);
    self.contentView.frame = rect;
  }
  [self.contentView bringSubviewToFront:self.viewOfInput];
  CGRect rect = self.viewOfLoading.frame;
  self.viewOfLoading.frame =
      CGRectMake(rect.origin.x, 0, rect.size.width, rect.size.height);
  [self.contentView bringSubviewToFront:self.viewOfLoading];
  self.progressView.progress = 0.f;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  self.navigationItem.title = @"添加设备";
  [self setup];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
//  [[NSNotificationCenter defaultCenter]
//      addObserver:self
//         selector:@selector(reachabilityChanged:)
//             name:kReachabilityChangedNotification
//           object:nil];

#if defined(TARGET_IPHONE_SIMULATOR) && TARGET_IPHONE_SIMULATOR
#else
  NSString *ssid = [FirstTimeConfig getSSID];
  self.textWIFI.text = ssid;
#endif
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self.socket close];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
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

- (IBAction)showOrHiddenPassword:(id)sender {
  self.textPassword.secureTextEntry = self.isShowPassword;
  self.isShowPassword = !self.isShowPassword;
  if (self.isShowPassword) {
    [self.btnShowPassword setImage:[UIImage imageNamed:@"xsmm"]
                          forState:UIControlStateNormal];
  } else {
    [self.btnShowPassword setImage:[UIImage imageNamed:@"xsmm02"]
                          forState:UIControlStateNormal];
  }
}

- (IBAction)doConfig:(id)sender {
  [self touchBackground:nil];
  NSCharacterSet *charSet = [NSCharacterSet whitespaceCharacterSet];
  self.password =
      [self.textPassword.text stringByTrimmingCharactersInSet:charSet];
  //界面
  CGRect rect = self.viewOfLoading.frame;
  rect = CGRectMake(rect.origin.x, 0, rect.size.width, rect.size.height);
  [UIView animateWithDuration:0.3f
                   animations:^{ self.viewOfLoading.frame = rect; }];
  [self.contentView bringSubviewToFront:self.viewOfLoading];
  self.progressView.progress = 0.f;
  rect = self.lblMessage.frame;
  rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, 20);
  self.lblMessage.frame = rect;
  self.lblMessage.text = @"配置中...";
  self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                target:self
                                              selector:@selector(changeProgress)
                                              userInfo:nil
                                               repeats:YES];
  [self stopAction];
  self.socket = [[GCDAsyncUdpSocket alloc]
      initWithDelegate:self
         delegateQueue:dispatch_get_global_queue(0, 0)];
  [CC3xUtility setupUdpSocket:self.socket port:APP_PORT];
  [self startTransmitting];
}

- (void)changeProgress {
  self.progressView.progress += 1.f / 60;  //默认1分钟
  if (self.progressView.progress == 1.f) {
    [self.timer invalidate];
    //停止发送
    [self stopAction];
    CGRect rect = self.lblMessage.frame;
    rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, 100);
    self.lblMessage.frame = rect;
    self.lblMessage.text = @"配" @"置"
        @"结束。请检查设备黄灯状态。\n常亮：配置成功，请"
        @"回"
        @"到系统页刷新查看。\n慢闪：设备无法配置到路由，"
        @"请"
        @"检查密码后重启设备并设置。\n快闪：设备未收到配"
        @"置请求，请重启设备并配置。";
  }
}

- (IBAction)stopConfig:(id)sender {
  CGRect rect = self.viewOfLoading.frame;
  rect = CGRectMake(rect.origin.x, rect.size.height, rect.size.width,
                    rect.size.height);
  [UIView animateWithDuration:0.3f
                   animations:^{ self.viewOfLoading.frame = rect; }];
  [self.timer invalidate];
  //停止发送
  [self stopAction];
  [self.socket close];
  self.socket = nil;
}

#pragma mark - 返回
- (IBAction)back:(id)sender {
  [self dismissViewControllerAnimated:YES completion:^{}];
  [self.sidePanelController
      setCenterPanel:kSharedAppliction.centerViewController];
  [[NSNotificationCenter defaultCenter] postNotificationName:@"back"
                                                      object:self];
}

- (IBAction)touchBackground:(id)sender {
  [self.textWIFI resignFirstResponder];
  [self.textPassword resignFirstResponder];
}

#pragma mark - CC3000
//网络连接完好，进行udp传输
- (void)startTransmitting {
  self.count = 0;
#if defined(TARGET_IPHONE_SIMULATOR) && TARGET_IPHONE_SIMULATOR
#else
  @try {
    self.config = nil;
    if ([self.password length]) {
      self.config = [[FirstTimeConfig alloc] initWithKey:self.password];
    } else {
      self.config = [[FirstTimeConfig alloc] init];
    }
    [self sendAction];
    //    [NSThread detachNewThreadSelector:@selector(waitForAckThread:)
    //                             toTarget:self
    //                           withObject:nil];
  }
  @catch (NSException *exception) {
    LogInfo(@"%s exception == %@", __FUNCTION__, [exception description]);
  }
  @finally {
  }
#endif
}

- (void)sendAction {
  @try {
    LogInfo(@"begin");
    [self.config transmitSettings];
    LogInfo(@"end");
  }
  @catch (NSException *exception) {
    LogInfo(@"exception === %@", [exception description]);
  }
  @finally {
  }
}

- (void)stopAction {
  LogInfo(@"%s begin", __PRETTY_FUNCTION__);
  @try {
    [self.config stopTransmitting];
  }
  @catch (NSException *exception) {
    LogInfo(@"%s exception == %@", __FUNCTION__, [exception description]);
  }
  @finally {
  }
  LogInfo(@"%s end", __PRETTY_FUNCTION__);
}

//- (void)waitForAckThread:(id)sender {
//  @try {
//    LogInfo(@"%s begin", __PRETTY_FUNCTION__);
//    Boolean val = [self.config waitForAck];
//    LogInfo(@"Bool value == %d", val);
//    if (val) {
//      [self stopAction];
//    }
//  }
//  @catch (NSException *exception) {
//    LogInfo(@"%s exception == %@", __FUNCTION__, [exception description]);
//  }
//  @finally {
//  }
//  LogInfo(@"%s end", __PRETTY_FUNCTION__);
//}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  if (textField == self.textWIFI) {
    [textField resignFirstResponder];
    [self.textPassword becomeFirstResponder];
    return NO;
  } else {
    [textField resignFirstResponder];
    return YES;
  }
}

#pragma mark - UdpRequestDelegate
- (void)responseMsg:(CC3xMessage *)message address:(NSData *)address {
  switch (message.msgId) {
    case 0x6:
      if (message.state == 0) {
        // TODO:配置成功
        dispatch_async(dispatch_get_main_queue(), ^{
            [self stopConfig:nil];
            [self.view
                makeToast:@"添加成功"
                 duration:1.f
                 position:[NSValue valueWithCGPoint:
                                       CGPointMake(
                                           self.view.frame.size.width / 2,
                                           self.view.frame.size.height - 40)]];
            [self performSelector:@selector(back:) withObject:nil afterDelay:1];
        });
      }
      debugLog(@"mac is %@ state is %d", message.mac, message.state);
      break;
    default:
      break;
  }
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock
       didReceiveData:(NSData *)data
          fromAddress:(NSData *)address
    withFilterContext:(id)filterContext {
  CC3xMessage *message = (CC3xMessage *)filterContext;
  switch (message.msgId) {
    case 0x2:
      self.count++;
      debugLog(@"count is %d mac is %@ ip is %@ and port is %d", self.count,
               message.mac, message.ip, message.port);
      if (!self.request) {
        self.request = [UdpRequest manager];
        self.request.delegate = self;
      }
      [self.request sendMsg05:message.ip port:message.port mode:ActiveMode];
      break;

    default:
      break;
  }
}

@end