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
@property(strong, nonatomic) IBOutlet UIView *viewOfContent;
@property(assign, nonatomic) BOOL isShowPassword;
@property(nonatomic, strong) IBOutlet UIProgressView *progressView;
@property(nonatomic, strong) IBOutlet UILabel *lblMessage;

@property(strong, nonatomic) FirstTimeConfig *config;
@property(strong, nonatomic) NSString *wifi;
@property(strong, nonatomic) NSString *password;
//为设备设置好wifi后，会多次收到设备wifi配置成功的消息，只在第一次配置成功的时候处理
@property(assign, atomic) int count;
@property(strong, nonatomic) UdpRequest *request;
@property(strong, nonatomic) GCDAsyncUdpSocket *socket;

- (IBAction)showOrHiddenPassword:(id)sender;
- (IBAction)doConfig:(id)sender;
- (IBAction)back:(id)sender;
- (IBAction)touchBackground:(id)sender;

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

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  self.navigationItem.title = @"添加设备";
  [self.sidePanelController setLeftPanel:nil];
  self.textWIFI.delegate = self;
  self.textPassword.delegate = self;
  if (is4Inch) {
    CGRect rect = self.contentView.frame;
    rect.size = CGSizeMake(rect.size.width, rect.size.width + 88.f);
    self.contentView.frame = rect;
  }
  [self.contentView bringSubviewToFront:self.viewOfInput];
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
  self.textPassword.text = @"sdzg2014";
  self.password = @"sdzg2014";
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
  //  self.socket = [[GCDAsyncUdpSocket alloc]
  //      initWithDelegate:self
  //         delegateQueue:dispatch_get_global_queue(0, 0)];
  //  [CC3xUtility setupUdpSocket:self.socket port:APP_PORT];
  //  [self startTransmitting];

  [UIView animateWithDuration:0.3f
                   animations:^{ self.viewOfLoading.hidden = NO; }];
}

- (void)stopConfig:(id)sender {
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
    [NSThread detachNewThreadSelector:@selector(waitForAckThread:)
                             toTarget:self
                           withObject:nil];
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

- (void)waitForAckThread:(id)sender {
  @try {
    LogInfo(@"%s begin", __PRETTY_FUNCTION__);
    Boolean val = [self.config waitForAck];
    LogInfo(@"Bool value == %d", val);
    if (val) {
      [self stopAction];
    }
  }
  @catch (NSException *exception) {
    LogInfo(@"%s exception == %@", __FUNCTION__, [exception description]);
  }
  @finally {
  }

  if ([NSThread isMainThread] == NO) {
    NSLog(@"this is not main thread");
    [NSThread exit];
  } else {
    NSLog(@"this is main thread");
  }
  LogInfo(@"%s end", __PRETTY_FUNCTION__);
}

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