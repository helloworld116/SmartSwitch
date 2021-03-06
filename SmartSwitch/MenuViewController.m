//
//  MenuViewController.m
//  SmartSwitch
//
//  Created by sdzg on 14-8-6.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuCell : UITableViewCell
@property(strong, nonatomic) IBOutlet UIImageView *imgMenu;
@property(strong, nonatomic) IBOutlet UILabel *lblMenuName;
@end

@implementation MenuCell
- (void)awakeFromNib {
  self.backgroundColor = [UIColor clearColor];
}
@end

@interface MenuViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(strong, nonatomic) NSArray *menuNames;
@property(strong, nonatomic) NSArray *imageNames;
@property(strong, nonatomic) IBOutlet UIButton *btnLoginLeft;
@property(strong, nonatomic) IBOutlet UIButton *btnLoginRight;
@property(strong, nonatomic) IBOutlet UILabel *lblUsername;
@property(strong, nonatomic) IBOutlet UIView *topView;
@property(strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)toLoginPage:(id)sender;
@end

@implementation MenuViewController

#pragma mark - UIViewController
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
  self.menuNames = @[
    @"添加开关",
    @"添加场景",
    @"晟大分享",
    @"购买设备",
    @"晟大帮助",
    @"晟大设置",
    @"关于晟大"
  ];
  self.imageNames =
      @[ @"tb01", @"tb02", @"tb03", @"tb04", @"tb05", @"tb06", @"tb07" ];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
  self.tableView.separatorColor = [UIColor colorWithHexString:@"#1e353d"];
  UIView *view = [[UIView alloc]
      initWithFrame:CGRectMake(0, 1, self.view.frame.size.width, 1)];
  view.backgroundColor = [UIColor colorWithHexString:@"#1e353d"];
  self.tableView.tableFooterView = view;

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(loginSuccess:)
                                               name:kLoginSuccess
                                             object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:kLoginSuccess
                                                object:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  return [self.menuNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellId = @"MenuCell";
  MenuCell *menuCell = [tableView dequeueReusableCellWithIdentifier:CellId];
  NSString *menuName = self.menuNames[indexPath.row];
  NSString *imgName = self.imageNames[indexPath.row];
  menuCell.imgMenu.image = [UIImage imageNamed:imgName];
  menuCell.lblMenuName.text = menuName;

  UIView *backgroundView = [[UIView alloc] initWithFrame:menuCell.bounds];
  backgroundView.backgroundColor = [UIColor colorWithHexString:@"#0099ff"];
  menuCell.selectedBackgroundView = backgroundView;

  return menuCell;
}

- (UIView *)tableView:(UITableView *)tableView
    viewForFooterInSection:(NSInteger)section {
  UIView *view = [[UIView alloc]
      initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
  view.backgroundColor = [UIColor clearColor];
  return view;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  UIViewController *nextVC;
  switch (indexPath.row) {
    case 0:
      nextVC = [self.storyboard
          instantiateViewControllerWithIdentifier:@"AddSwitchNavController"];
      break;
    case 1:
      nextVC = [self.storyboard
          instantiateViewControllerWithIdentifier:@"AddSenceNavController"];
      break;
    case 2:
      nextVC = [self.storyboard
          instantiateViewControllerWithIdentifier:@"ShareNavController"];
      break;
    case 3:
      //      nextVC = [self.storyboard
      //          instantiateViewControllerWithIdentifier:@"BuyNavController"];
      [[UIApplication sharedApplication]
          openURL:[NSURL URLWithString:@"http://shop111398559.taobao.com/"]];
      break;
    case 4:
      nextVC = [self.storyboard
          instantiateViewControllerWithIdentifier:@"HelpNavController"];
      break;
    case 5:
      nextVC = [self.storyboard
          instantiateViewControllerWithIdentifier:@"SettingNavController"];
      break;
    case 6:
      nextVC = [self.storyboard
          instantiateViewControllerWithIdentifier:@"AboutNavController"];
      break;
    default:
      nextVC = [self.storyboard
          instantiateViewControllerWithIdentifier:@"AddSwitchNavController"];
      break;
  }
  if (indexPath.row != 3) {
    kSharedAppliction.centerViewController =
        [self.sidePanelController centerPanel];
    [self.sidePanelController setCenterPanel:nextVC];
    [self.sidePanelController showCenterPanelAnimated:YES];
  }
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (IBAction)toLoginPage:(id)sender {
  UIViewController *nextVC = [self.storyboard
      instantiateViewControllerWithIdentifier:@"LoginNavController"];
  [self presentViewController:nextVC animated:YES completion:^{}];
}

#pragma mark - 登陆成功后的通知
- (void)loginSuccess:(NSNotification *)notification {
  NSDictionary *userInfo = [notification userInfo];
  NSString *username = [userInfo objectForKey:@"username"];
  self.lblUsername.text = username;
  self.lblUsername.hidden = NO;
  self.btnLoginLeft.enabled = NO;
  self.btnLoginRight.hidden = YES;
}
@end