//
//  SwitchDetailViewController.m
//  SmartSwitch
//
//  Created by sdzg on 14-8-11.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "SwitchDetailViewController.h"

@interface SwitchDetailViewController ()
@property(strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property(strong, nonatomic) IBOutlet UIView *contentView;

@end

@implementation SwitchDetailViewController

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
  self.navigationItem.title = @"开关名称";
  self.navigationItem.leftBarButtonItem =
      [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fh"]
                                       style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(pop:)];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
      initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                           target:self
                           action:@selector(showAddMenu:)];
  //  self.scrollView.contentSize = CGSizeMake(320, 1000);
  //  self.scrollView.contentOffset = CGPointMake(0, -50);
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
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
#pragma mark - 导航栏事件
- (void)pop:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)showAddMenu:(id)sender {
  //  UIBarButtonItem *item = (UIBarButtonItem *)sender;
  [KxMenu setTintColor:[UIColor blackColor]];
  [KxMenu
      showMenuInView:self.view
            fromRect:CGRectMake(self.view.frame.size.width - 35, -20, 20, 20)
           menuItems:@[
                       [KxMenuItem menuItem:@"延时任务"
                                      image:[UIImage imageNamed:@"tjcj"]
                                     target:self
                                     action:@selector(menuItem1:)],
                       [KxMenuItem menuItem:@"定时任务"
                                      image:[UIImage imageNamed:@"tjcj"]
                                     target:self
                                     action:@selector(menuItem2:)],
                       [KxMenuItem menuItem:@"历史电量"
                                      image:[UIImage imageNamed:@"tjcj"]
                                     target:self
                                     action:@selector(menuItem3:)]
                     ]];
}

- (void)menuItem1:(id)sender {
  //延时
}

- (void)menuItem2:(id)sender {
  //定时
  UIViewController *nextVC = [self.storyboard
      instantiateViewControllerWithIdentifier:@"TimerViewController"];
  [self.navigationController pushViewController:nextVC animated:YES];
}

- (void)menuItem3:(id)sender {
  //历史电量
  UIViewController *nextVC =
      [self.storyboard instantiateViewControllerWithIdentifier:
                           @"HistoryElectricityViewController"];
  [self.navigationController pushViewController:nextVC animated:YES];
}
@end
