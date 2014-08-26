//
//  RegisterViewController.m
//  SmartSwitch
//
//  Created by sdzg on 14-8-6.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *textUsername;
@property (strong, nonatomic) IBOutlet UITextField *textFieldPassword;
@property (strong, nonatomic) IBOutlet UITextField *textFieldPassword2;
@property (strong, nonatomic) IBOutlet UITextField *textFieldNickName;
@property (strong, nonatomic) IBOutlet UIView *view1;
@property (strong, nonatomic) IBOutlet UIView *view2;
@property (strong, nonatomic) IBOutlet UIView *view3;
@property (strong, nonatomic) IBOutlet UIView *view4;
- (IBAction)back:(id)sender;
- (IBAction)toUserProtocolPage:(id)sender;
- (IBAction)agreenProtocol:(id)sender;
- (IBAction) register:(id)sender;

- (IBAction)touchBackground:(id)sender;
@property (assign, nonatomic) BOOL isAgreenProtocol;
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

- (void)setup {
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

  self.textUsername.delegate = self;
  self.textFieldPassword.delegate = self;
  self.textFieldPassword2.delegate = self;
  self.textFieldNickName.delegate = self;

  self.isAgreenProtocol = YES;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  self.navigationItem.title = @"用户注册";
  [self setup];
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
- (IBAction)agreenProtocol:(id)sender {
  UIButton *btn = (UIButton *)sender;
  btn.selected = !btn.selected;
  self.isAgreenProtocol = btn.selected;
}

- (IBAction) register:(id)sender {
}

- (IBAction)touchBackground:(id)sender {
  [self.textUsername resignFirstResponder];
  [self.textFieldPassword resignFirstResponder];
  [self.textFieldPassword2 resignFirstResponder];
  [self.textFieldNickName resignFirstResponder];
}

#pragma mark - UITextField协议
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  if (textField == self.textUsername) {
    [self.textFieldPassword becomeFirstResponder];
    return NO;
  } else if (textField == self.textFieldPassword) {
    [self.textFieldPassword2 becomeFirstResponder];
    return NO;
  } else if (textField == self.textFieldPassword2) {
    [self.textFieldNickName becomeFirstResponder];
    return NO;
  } else if (textField == self.textFieldNickName) {
    [self.textFieldNickName resignFirstResponder];
    return YES;
  }
  return YES;
}

@end
