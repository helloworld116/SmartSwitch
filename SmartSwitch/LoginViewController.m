//
//  LoginViewController.m
//  SmartSwitch
//
//  Created by sdzg on 14-8-6.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "LoginViewController.h"
#import "UserInfo.h"

@interface LoginViewController ()<UITextFieldDelegate>
@property(strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property(strong, nonatomic) IBOutlet UIView *view1;
@property(strong, nonatomic) IBOutlet UIView *view2;
@property(strong, nonatomic) IBOutlet UITextField *textFieldUsername;
@property(strong, nonatomic) IBOutlet UITextField *textFieldPassword;

- (IBAction)back:(id)sender;
- (IBAction)toRegisterPage:(id)sender;
- (IBAction)weiboLogin:(id)sender;
- (IBAction)qqLogin:(id)sender;
- (IBAction)login:(id)sender;
- (IBAction)touchBackground:(id)sender;

@property(strong, nonatomic) UITextField *activeField;
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

- (void)setup {
  self.scrollView.contentSize = CGSizeMake(
      self.scrollView.frame.size.width, self.scrollView.frame.size.height + 1);
  self.view1.layer.borderColor = [UIColor lightGrayColor].CGColor;
  self.view1.layer.borderWidth = 1.f;
  self.view1.layer.cornerRadius = 1.f;
  self.view2.layer.borderColor = [UIColor lightGrayColor].CGColor;
  self.view2.layer.borderWidth = 1.f;
  self.view2.layer.cornerRadius = 1.f;
  self.textFieldUsername.delegate = self;
  self.textFieldPassword.delegate = self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  self.navigationItem.title = @"用户登陆";

  [self setup];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(keyboardDidShow:)
             name:UIKeyboardDidShowNotification
           object:nil];

  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(keyboardWillBeHidden:)
             name:UIKeyboardWillHideNotification
           object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [[NSNotificationCenter defaultCenter]
      removeObserver:self
                name:UIKeyboardDidShowNotification
              object:nil];
  [[NSNotificationCenter defaultCenter]
      removeObserver:self
                name:UIKeyboardWillHideNotification
              object:nil];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - UIStatusBarStyle
- (UIStatusBarStyle)preferredStatusBarStyle {
  return UIStatusBarStyleLightContent;
}

#pragma mark - 导航栏按钮处理
- (IBAction)back:(id)sender {
  [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)toRegisterPage:(id)sender {
  UIViewController *nextVC = [self.storyboard
      instantiateViewControllerWithIdentifier:@"RegisterViewController"];
  [self.navigationController pushViewController:nextVC animated:YES];
}

- (IBAction)weiboLogin:(id)sender {
}

- (IBAction)qqLogin:(id)sender {
}

- (IBAction)login:(id)sender {
  UserInfo *userInfo =
      [[UserInfo alloc] initWithUsername:@"happy" password:@"1234567"];
  [userInfo send];
}

- (IBAction)touchBackground:(id)sender {
  [self.textFieldUsername resignFirstResponder];
  [self.textFieldPassword resignFirstResponder];
}

#pragma mark - UITextField
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  if (textField == self.textFieldUsername) {
    [self.textFieldPassword becomeFirstResponder];
    return NO;
  } else if (textField == self.textFieldPassword) {
    [self.textFieldPassword resignFirstResponder];
    return YES;
  }
  return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
  self.activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
  self.activeField = nil;
}

#pragma mark - 键盘通知
- (void)keyboardDidShow:(NSNotification *)notification {
  NSDictionary *info = [notification userInfo];
  CGRect kbRect =
      [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
  kbRect = [self.view convertRect:kbRect fromView:nil];

  UIEdgeInsets contentInsets =
      UIEdgeInsetsMake(0.0, 0.0, kbRect.size.height, 0.0);
  self.scrollView.contentInset = contentInsets;
  self.scrollView.scrollIndicatorInsets = contentInsets;

  CGRect aRect = self.view.frame;
  aRect.size.height -= kbRect.size.height;
  if (!CGRectContainsPoint(aRect, self.activeField.frame.origin)) {
    [self.scrollView scrollRectToVisible:self.activeField.frame animated:YES];
  }
}

- (void)keyboardWillBeHidden:(NSNotification *)notification {
  UIEdgeInsets contentInsets = UIEdgeInsetsZero;
  self.scrollView.contentInset = contentInsets;
  self.scrollView.scrollIndicatorInsets = contentInsets;
}
@end
