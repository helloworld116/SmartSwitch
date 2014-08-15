//
//  LoginViewController.m
//  SmartSwitch
//
//  Created by sdzg on 14-8-6.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
@property(strong, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)back:(id)sender;
- (IBAction)toRegisterPage:(id)sender;

@property(strong, nonatomic) IBOutlet UIView *view1;
@property(strong, nonatomic) IBOutlet UIView *view2;
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
  self.scrollView.contentSize = CGSizeMake(
      self.scrollView.frame.size.width, self.scrollView.frame.size.height + 1);
  self.view1.layer.borderColor = [UIColor lightGrayColor].CGColor;
  self.view1.layer.borderWidth = 1.f;
  self.view1.layer.cornerRadius = 1.f;
  self.view2.layer.borderColor = [UIColor lightGrayColor].CGColor;
  self.view2.layer.borderWidth = 1.f;
  self.view2.layer.cornerRadius = 1.f;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - UIStatusBarStyle
- (UIStatusBarStyle)preferredStatusBarStyle {
  return UIStatusBarStyleLightContent;
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
