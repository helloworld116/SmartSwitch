//
//  SocketAndSceneViewController.m
//  SmartSwitch
//
//  Created by sdzg on 14-8-6.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "SocketAndSceneViewController.h"

@interface SocketAndSceneViewController ()
- (IBAction)showMenu:(id)sender;
- (IBAction)showAddMenu:(id)sender;
@end

@implementation SocketAndSceneViewController

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
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  if (![self.sidePanelController leftPanel]) {
    [self.sidePanelController
        setLeftPanel:kSharedAppliction.leftViewController];
    [self.sidePanelController showLeftPanelAnimated:YES];
  }
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

#pragma mark - 导航栏菜单
- (IBAction)showMenu:(id)sender {
  [self.sidePanelController showLeftPanelAnimated:YES];
}

- (IBAction)showAddMenu:(id)sender {
  //  UIBarButtonItem *item = (UIBarButtonItem *)sender;
  [KxMenu showMenuInView:self.view
                fromRect:CGRectMake(self.view.frame.size.width - 35, 44, 20, 20)
               menuItems:@[
                           [KxMenuItem menuItem:@"添加开关"
                                          image:[UIImage imageNamed:@"image"]
                                         target:self
                                         action:@selector(menuItemSocket:)],
                           [KxMenuItem menuItem:@"添加场景"
                                          image:[UIImage imageNamed:@"image"]
                                         target:self
                                         action:@selector(menuItemSence:)]
                         ]];
}

- (void)menuItemSocket:(id)sender {
}

- (void)menuItemSence:(id)sender {
  UIViewController *nextVC = [self.storyboard
      instantiateViewControllerWithIdentifier:@"AddSenceViewController"];
  //    nextVC.modalPresentationStyle = UIMo
  [self presentViewController:nextVC animated:YES completion:^{}];
}
@end
