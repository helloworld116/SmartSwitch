//
//  AddSwitchViewController.m
//  SmartSwitch
//
//  Created by sdzg on 14-8-6.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "AddSwitchViewController.h"

@interface AddSwitchViewController ()<UITextFieldDelegate>
@property(strong, nonatomic) IBOutlet UITextField *textWIFI;
@property(strong, nonatomic) IBOutlet UITextField *textPassword;
@property(strong, nonatomic) IBOutlet UIButton *btnShowPassword;  //展示选中图片

@property(strong, nonatomic) FirstTimeConfig *config;

@property(strong, nonatomic) NSString *wifi;
@property(strong, nonatomic) NSString *password;

- (IBAction)showOrHiddenPassword:(id)sender;
- (IBAction)doConfig:(id)sender;
- (IBAction)back:(id)sender;

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
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(reachabilityChanged:)
             name:kReachabilityChangedNotification
           object:nil];

#if defined(TARGET_IPHONE_SIMULATOR) && TARGET_IPHONE_SIMULATOR
#else
  NSString *ssid = [FirstTimeConfig getSSID];
  self.textWIFI.text = ssid;
#endif
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
}

- (IBAction)doConfig:(id)sender {
}

#pragma mark - 返回
- (IBAction)back:(id)sender {
  [self.sidePanelController
      setCenterPanel:kSharedAppliction.centerViewController];
  [[NSNotificationCenter defaultCenter] postNotificationName:@"back"
                                                      object:self];
}

//网络连接完好，进行udp传输
- (void)startTransmitting {
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

// button触发配置方法
- (void)touchToAdd:(UIButton *)sender {
  [self stopAction];
  [self startTransmitting];
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
      [self performSelectorOnMainThread:@selector(stopAction)
                             withObject:nil
                          waitUntilDone:YES];
    }
  }
  @catch (NSException *exception) {
    LogInfo(@"%s exception == %@", __FUNCTION__, [exception description]);
    /// stop here
  }
  @finally {
  }

  if ([NSThread isMainThread] == NO) {
    LogInfo(@"这不是主线程");
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
  } else {
    LogInfo(@"这是主线程");
  }
  LogInfo(@"%s end", __PRETTY_FUNCTION__);
}
@end
