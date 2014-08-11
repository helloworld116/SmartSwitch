//
//  RegisterViewController.m
//  SmartSwitch
//
//  Created by sdzg on 14-8-6.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()
@property(strong, nonatomic) IBOutlet UIView *view1;
@property(strong, nonatomic) IBOutlet UIView *view2;
@property(strong, nonatomic) IBOutlet UIView *view3;
@property(strong, nonatomic) IBOutlet UIView *view4;
- (IBAction)back:(id)sender;
- (IBAction)toUserProtocolPage:(id)sender;
@end

@implementation RegisterViewController

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
  self.navigationItem.title = @"用户注册";
  self.view1.layer.borderColor = [UIColor lightGrayColor].CGColor;
  self.view1.layer.borderWidth = 1.f;
  self.view1.layer.cornerRadius = 1.f;
  self.view2.layer.borderColor = [UIColor lightGrayColor].CGColor;
  self.view2.layer.borderWidth = 1.f;
  self.view2.layer.cornerRadius = 1.f;
  self.view3.layer.borderColor = [UIColor lightGrayColor].CGColor;
  self.view3.layer.borderWidth = 1.f;
  self.view3.layer.cornerRadius = 1.f;
  self.view4.layer.borderColor = [UIColor lightGrayColor].CGColor;
  self.view4.layer.borderWidth = 1.f;
  self.view4.layer.cornerRadius = 1.f;
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
  [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)toUserProtocolPage:(id)sender {
  UIViewController *nextVC =
      [self.storyboard instantiateViewControllerWithIdentifier:
                           @"SDZGUserProtocolViewController"];
  [self.navigationController pushViewController:nextVC animated:YES];
}
@end
