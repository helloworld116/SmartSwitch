//
//  SettingViewController.m
//  SmartSwitch
//
//  Created by sdzg on 14-8-6.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "SettingViewController.h"
@interface SettingCell : UITableViewCell
@property(nonatomic, strong) IBOutlet UILabel *lblTitle;
@property(nonatomic, strong) IBOutlet UISwitch *aSwitch;
@end

@implementation SettingCell
- (void)awakeFromNib {
  [self.aSwitch addTarget:self
                   action:@selector(changeSwitch:)
         forControlEvents:UIControlEventValueChanged];
}

- (void)changeSwitch:(id)sender {
  [[NSUserDefaults standardUserDefaults] setBool:[sender isOn] forKey:kShake];
}
@end

@interface SettingViewController ()
- (IBAction)back:(id)sender;
@end

@implementation SettingViewController

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
  self.navigationItem.title = @"设置";
  [self.sidePanelController setLeftPanel:nil];
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
#pragma mark - 返回
- (IBAction)back:(id)sender {
  [self.sidePanelController
      setCenterPanel:kSharedAppliction.centerViewController];
  [[NSNotificationCenter defaultCenter] postNotificationName:@"back"
                                                      object:self];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellId = @"SettingCell";
  SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
  cell.aSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:kShake];
  return cell;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  return 1;
}

- (NSString *)tableView:(UITableView *)tableView
    titleForHeaderInSection:(NSInteger)section {
  NSString *message;
  switch (section) {
    case 0:
      message = @"通用设置";
      break;

    default:
      break;
  }
  return message;
}
@end
