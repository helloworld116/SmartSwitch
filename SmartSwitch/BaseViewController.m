//
//  BaseViewController.m
//  SmartSwitch
//
//  Created by sdzg on 14-8-5.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

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
  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(notReachableNotification:)
             name:kNotReachableNotification
           object:nil];
}

#pragma mark 网络不可用时，执行udp请求后的提示
- (void)notReachableNotification:(NSNotification *)notification {
  if ([[notification name] isEqualToString:kNotReachableNotification]) {
    NSDictionary *userInfo = [notification userInfo];
    if ([[userInfo objectForKey:@"NetworkStatus"] intValue] == NotReachable) {
      [[ViewUtil sharedInstance]
          showMessageInViewController:self
                              message:@"网络不可用，请稍后再试"];
    }
  }
}
#pragma mark

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:kNotReachableNotification
                                                object:nil];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
