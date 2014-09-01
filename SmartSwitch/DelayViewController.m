//
//  DelayViewController.m
//  SmartSwitch
//
//  Created by sdzg on 14-8-14.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "DelayViewController.h"
#import "DelayTimeCountDownView.h"
#import "SwitchDataCeneter.h"

@interface DelayTextField : UITextField

@end

@implementation DelayTextField
//控制文本所在的的位置，左右缩 10
- (CGRect)textRectForBounds:(CGRect)bounds {
  return CGRectInset(bounds, 10, 0);
}

//控制编辑文本时所在的位置，左右缩 10
- (CGRect)editingRectForBounds:(CGRect)bounds {
  return CGRectInset(bounds, 10, 0);
}

@end

@interface DelayViewController ()<UITextFieldDelegate, UdpRequestDelegate>
@property(strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property(strong, nonatomic) IBOutlet DelayTimeCountDownView *viewOfCountDown;
@property(strong, nonatomic) IBOutlet DelayTextField *textField;
@property(strong, nonatomic) IBOutlet UIButton *btnInput;
@property(strong, nonatomic) IBOutlet UIButton *btnMinitues5;
@property(strong, nonatomic) IBOutlet UIButton *btnMinitues30;
@property(strong, nonatomic) IBOutlet UIButton *btnMinitues60;
@property(strong, nonatomic) IBOutlet UIButton *btnMinitues90;
@property(strong, nonatomic) IBOutlet UIButton *btnMinitues120;
@property(strong, nonatomic) IBOutlet UIButton *btnMinitues300;
- (IBAction)choiceAction:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)touchBackground:(id)sender;
- (IBAction)switchChange:(id)sender;

@property(nonatomic, strong) UITextField *activeField;
@property(nonatomic, assign) BOOL actionState;     //开关状态
@property(nonatomic, assign) int actionMinitues;   //延迟时间
@property(nonatomic, strong) UIButton *btnOfLast;  //最后操作的按钮
@property(nonatomic, strong) UdpRequest *request;
@end

@implementation DelayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)setup {
  self.textField.delegate = self;
  self.actionState = YES;
  //默认选中5分钟的按钮
  self.actionMinitues = 5;
  self.btnOfLast = self.btnMinitues5;

  //查询延时
  if (!self.request) {
    self.request = [UdpRequest manager];
    self.request.delegate = self;
  }
  [self.request sendMsg53Or55:self.aSwitch
                     socketId:self.socketId
                     sendMode:ActiveMode];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  self.navigationItem.title = @"延迟任务";
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
      initWithImage:[UIImage imageNamed:@"fh"]
              style:UIBarButtonItemStylePlain
             target:self.navigationController
             action:@selector(popViewControllerAnimated:)];
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

- (IBAction)choiceAction:(id)sender {
  UIButton *btn = (UIButton *)sender;
  int minitues;
  UIButton *btnOfCurrentSelected;
  switch (btn.tag) {
    case 301:
      // 5分钟
      minitues = 5;
      btnOfCurrentSelected = self.btnMinitues5;
      [self.textField resignFirstResponder];
      break;
    case 302:
      // 30分钟
      minitues = 30;
      btnOfCurrentSelected = self.btnMinitues30;
      [self.textField resignFirstResponder];
      break;
    case 303:
      // 60分钟
      minitues = 60;
      btnOfCurrentSelected = self.btnMinitues60;
      [self.textField resignFirstResponder];
      break;
    case 304:
      // 90分钟
      minitues = 90;
      btnOfCurrentSelected = self.btnMinitues90;
      [self.textField resignFirstResponder];
      break;
    case 305:
      // 120分钟
      minitues = 120;
      btnOfCurrentSelected = self.btnMinitues120;
      [self.textField resignFirstResponder];
      break;
    case 306:
      // 300分钟
      minitues = 300;
      btnOfCurrentSelected = self.btnMinitues300;
      [self.textField resignFirstResponder];
      break;
    case 307:
      // 自定义分钟
      minitues = 0;
      btnOfCurrentSelected = self.btnInput;
      [self.textField becomeFirstResponder];
      break;
    default:
      break;
  }
  self.actionMinitues = minitues;
  [UIView animateWithDuration:0.3
                   animations:^{
                       self.btnOfLast.selected = NO;
                       btnOfCurrentSelected.selected = YES;
                       self.btnOfLast = btnOfCurrentSelected;
                   }];
}

- (IBAction)save:(id)sender {
  //选中自定义时间
  if (self.btnOfLast == self.btnInput) {
    NSString *minituesStr =
        [self.textField.text stringByTrimmingCharactersInSet:
                                 [NSCharacterSet whitespaceCharacterSet]];
    int minitues = [minituesStr intValue];
    if (minitues) {
      if (minitues > kDelayMax) {
        [self.view
            makeToast:[NSString stringWithFormat:@"最多只能设置%d分钟",
                                                 kDelayMax]
             duration:1.f
             position:[NSValue
                          valueWithCGPoint:CGPointMake(
                                               self.view.frame.size.width / 2,
                                               self.view.frame.size.height -
                                                   40)]];
        return;
      } else {
        self.actionMinitues = minitues;
      }
    } else {
      [self.view makeToast:@"请填写正确的时间"
                  duration:1.f
                  position:[NSValue valueWithCGPoint:
                                        CGPointMake(
                                            self.view.frame.size.width / 2,
                                            self.view.frame.size.height - 40)]];
      return;
    }
  }
  if (!self.request) {
    self.request = [UdpRequest manager];
    self.request.delegate = self;
  }
  [self.request sendMsg4DOr4F:self.aSwitch
                     socketId:self.socketId
                    delayTime:self.actionMinitues
                     switchOn:self.actionState
                     sendMode:ActiveMode];
}

- (IBAction)touchBackground:(id)sender {
  [self.textField resignFirstResponder];
}

- (IBAction)switchChange:(id)sender {
  UISwitch *switchState = (UISwitch *)sender;
  self.actionState = switchState.isOn;
}

#pragma mark - UITextField
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
  self.activeField = textField;
  self.btnOfLast.selected = NO;
  self.btnInput.selected = YES;
  self.btnOfLast = self.btnInput;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
  self.activeField = nil;
  self.actionMinitues = [self.textField.text intValue];
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
  [UIView animateWithDuration:0.3f
                   animations:^{
                       self.scrollView.contentInset = contentInsets;
                       self.scrollView.scrollIndicatorInsets = contentInsets;
                   }];
}

#pragma mark - UdpRequest代理
- (void)responseMsg:(CC3xMessage *)message address:(NSData *)address {
  switch (message.msgId) {
    //设置延时
    case 0x4e:
    case 0x50:
      [self responseMsg4EOr50:message];
      break;
    //查询延时
    case 0x54:
    case 0x56:
      [self responseMsg54Or56:message];
      break;

    default:
      break;
  }
}

- (void)responseMsg4EOr50:(CC3xMessage *)message {
  if (message.state == 0) {
    [self.viewOfCountDown countDown:self.actionMinitues * 60];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view
            makeToast:@"设置延时成功"
             duration:1.f
             position:[NSValue
                          valueWithCGPoint:CGPointMake(
                                               self.view.frame.size.width / 2,
                                               self.view.frame.size.height -
                                                   40)]];
    });
    [[SwitchDataCeneter sharedInstance] updateDelayTime:self.actionMinitues
                                            delayAction:self.actionState
                                                    mac:self.aSwitch.mac
                                               socketId:self.socketId];
  }
}

- (void)responseMsg54Or56:(CC3xMessage *)message {
  if (message.delay > 0) {
    [self.viewOfCountDown countDown:message.delay * 60];
  }
  [[SwitchDataCeneter sharedInstance] updateDelayTime:message.delay
                                          delayAction:message.onStatus
                                                  mac:self.aSwitch.mac
                                             socketId:self.socketId];
}
@end
