//
//  SwitchInfoViewController.m
//  SmartSwitch
//
//  Created by sdzg on 14-8-15.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "SwitchInfoViewController.h"
@interface SwitchInfoView : UIView

@end

@implementation SwitchInfoView

- (void)drawRect:(CGRect)rect {
  // 创建路径
  CGMutablePathRef path = CGPathCreateMutable();
  // 将长方形的边框，添加到路径
  CGPathAddRect(path, NULL, rect);
  // 得到当前绘画上下文
  CGContextRef currentContext = UIGraphicsGetCurrentContext();
  // 添加路径到绘画上下文
  CGContextAddPath(currentContext, path);
  // 设置绘画颜色
  [[UIColor brownColor] setStroke];
  // 设置绘画宽度
  CGContextSetLineWidth(currentContext, 1.0f);
  // 绘画
  CGContextDrawPath(currentContext, kCGPathStroke);
  // 释放路径
  CGPathRelease(path);
}

@end

@interface SwitchInfoViewController ()<UITextFieldDelegate, UdpRequestDelegate>
@property(strong, nonatomic) IBOutlet UITextField *textFieldSwitchName;
@property(strong, nonatomic) IBOutlet UITextField *textFieldSocket1Name;
@property(strong, nonatomic) IBOutlet UITextField *textFieldSocket2Name;
- (IBAction)touchBackground:(id)sender;

@property(strong, nonatomic) UITextField *activeField;
@property(strong, nonatomic) NSString *switchName;
@property(strong, nonatomic) NSString *socket1Name;
@property(strong, nonatomic) NSString *socket2Name;
@property(strong, nonatomic) UdpRequest *request;
@end

@implementation SwitchInfoViewController

- (id)initWithStyle:(UITableViewStyle)style {
  self = [super initWithStyle:style];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)setup {
  UIView *tableHeaderView = [[UIView alloc]
      initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 20)];
  self.tableView.tableHeaderView = tableHeaderView;
  self.textFieldSwitchName.delegate = self;
  self.textFieldSocket1Name.delegate = self;
  self.textFieldSocket2Name.delegate = self;
  //默认取传递过来的名称，udp请求响应后修改为最新的名称
  self.textFieldSwitchName.text = self.aSwitch.name;
  NSArray *sockets = self.aSwitch.sockets;
  if (sockets.count) {
    self.textFieldSocket1Name.text = [sockets[0] name];
    self.textFieldSocket2Name.text = [sockets[1] name];
  }
  [self sendMsg5DOr5F];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.navigationItem.title = @"开关名称";
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
      initWithImage:[UIImage imageNamed:@"fh"]
              style:UIBarButtonItemStylePlain
             target:self.navigationController
             action:@selector(popViewControllerAnimated:)];
  self.navigationItem.rightBarButtonItem =
      [[UIBarButtonItem alloc] initWithTitle:@"保存"
                                       style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(saveName:)];
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

- (IBAction)touchBackground:(id)sender {
  [self.textFieldSwitchName resignFirstResponder];
  [self.textFieldSocket2Name resignFirstResponder];
  [self.textFieldSocket1Name resignFirstResponder];
}

- (void)saveName:(id)sender {
  if ([self checkInput]) {
    dispatch_queue_t queue =
        dispatch_queue_create("com.dispatch.serial", DISPATCH_QUEUE_SERIAL);
    static NSTimeInterval seconds = 0.5f;
    dispatch_async(queue, ^{
        [self sendMsg3FOr41:0 name:self.switchName];
        [NSThread sleepForTimeInterval:seconds];
    });
    dispatch_async(queue, ^{
        [self sendMsg3FOr41:1 name:self.socket1Name];
        [NSThread sleepForTimeInterval:seconds];
    });
    dispatch_async(queue, ^{
        [self sendMsg3FOr41:2 name:self.socket2Name];
        [NSThread sleepForTimeInterval:seconds];
    });
  }
}

- (BOOL)checkInput {
  [self touchBackground:nil];
  BOOL result = NO;
  NSCharacterSet *charSet = [NSCharacterSet whitespaceCharacterSet];
  NSString *switchName =
      [self.textFieldSwitchName.text stringByTrimmingCharactersInSet:charSet];
  NSString *socket1Name =
      [self.textFieldSocket1Name.text stringByTrimmingCharactersInSet:charSet];
  NSString *socket2Name =
      [self.textFieldSocket2Name.text stringByTrimmingCharactersInSet:charSet];
  NSString *message;
  if ([switchName length] && [socket1Name length] && [socket2Name length]) {
    self.switchName = switchName;
    self.socket1Name = socket1Name;
    self.socket2Name = socket2Name;
    result = YES;
  } else {
    result = NO;
    message = @"名称不能为空";
  }
  if (!result) {
    [self.view
        makeToast:message
         duration:1.f
         position:[NSValue
                      valueWithCGPoint:CGPointMake(
                                           self.view.frame.size.width / 2,
                                           self.view.frame.size.height - 40)]];
  }
  return result;
}

#pragma mark - UITextField
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  if (textField == self.textFieldSwitchName) {
    [self.textFieldSocket1Name becomeFirstResponder];
    return NO;
  } else if (textField == self.textFieldSocket1Name) {
    [self.textFieldSocket2Name becomeFirstResponder];
    return NO;
  } else {
    return YES;
  }
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
  self.tableView.contentInset = contentInsets;
  self.tableView.scrollIndicatorInsets = contentInsets;

  CGRect aRect = self.view.frame;
  aRect.size.height -= kbRect.size.height;
  if (!CGRectContainsPoint(aRect, self.activeField.frame.origin)) {
    [self.tableView scrollRectToVisible:self.activeField.frame animated:YES];
  }
}

- (void)keyboardWillBeHidden:(NSNotification *)notification {
  UIEdgeInsets contentInsets = UIEdgeInsetsZero;
  [UIView animateWithDuration:0.3f
                   animations:^{
                       self.tableView.contentInset = contentInsets;
                       self.tableView.scrollIndicatorInsets = contentInsets;
                   }];
}

#pragma mark - UDP请求
//查询设备名称
- (void)sendMsg5DOr5F {
  if (!self.request) {
    self.request = [UdpRequest manager];
    self.request.delegate = self;
  }
  [self.request sendMsg5DOr5F:self.aSwitch sendMode:ActiveMode];
}

- (void)sendMsg3FOr41:(int)type name:(NSString *)name {
  [self.request sendMsg3FOr41:self.aSwitch
                         type:type
                         name:name
                     sendMode:ActiveMode];
}

- (void)responseMsg:(CC3xMessage *)message address:(NSData *)address {
  switch (message.msgId) {
    case 0x5e:
    case 0x60:
      [self responseMsg5EOr60:message];
      break;
    case 0x40:
    case 0x42:
      [self responseMsg40Or42:message];
      break;
    default:
      break;
  }
}

- (void)responseMsg5EOr60:(CC3xMessage *)message {
  NSCharacterSet *charSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
  self.switchName =
      [message.deviceName stringByTrimmingCharactersInSet:charSet];
  self.socket1Name =
      [message.socketNames[0] stringByTrimmingCharactersInSet:charSet];
  self.socket2Name =
      [message.socketNames[1] stringByTrimmingCharactersInSet:charSet];
  dispatch_async(dispatch_get_main_queue(), ^{
      self.textFieldSwitchName.text = self.switchName;
      if (message.socketNames.count == 2) {
        self.textFieldSocket1Name.text = self.socket1Name;
        self.textFieldSocket2Name.text = self.socket2Name;
      }
  });
}

- (void)responseMsg40Or42:(CC3xMessage *)message {
  message.socketId;  // 0代表插座名字，1-n表示插孔n的名字
  message.state;
  debugLog(@"socketId is %d", message.socketId);
}
@end
