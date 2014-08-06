//
//  LoginViewController.m
//  SmartSwitch
//
//  Created by sdzg on 14-8-6.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
- (IBAction)back:(id)sender;
- (IBAction)toRegisterPage:(id)sender;

@end

@implementation LoginViewController

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
  self.navigationItem.title = @"用户登陆";
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

#pragma mark - 导航栏按钮处理
- (IBAction)back:(id)sender {
  [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)toRegisterPage:(id)sender {
  UIViewController *nextVC = [self.storyboard
      instantiateViewControllerWithIdentifier:@"RegisterViewController"];
  [self.navigationController pushViewController:nextVC animated:YES];
}
@end
