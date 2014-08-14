//
//  SwitchAndSceneViewController.m
//  SmartSwitch
//
//  Created by sdzg on 14-8-6.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "SwitchAndSceneViewController.h"
#import "SwitchTableView.h"
#import "SceneTableView.h"

@interface SwitchAndSceneViewController ()<SwitchTableViewDelegate,
                                           UIScrollViewDelegate>
@property(strong, nonatomic) IBOutlet UIScrollView *scrollView;
//@property(strong, nonatomic) IBOutlet SwitchTableView *switchTableView;

@property(strong, nonatomic) SwitchTableView *tableViewOfSwitch;
@property(strong, nonatomic) SceneTableView *tableViewOfScene;
//@property(strong, nonatomic) IBOutlet UIView *viewOfContainer;
@property(strong, nonatomic) IBOutlet UIButton *btnSwitch;
@property(strong, nonatomic) IBOutlet UIButton *btnScene;
- (IBAction)showSwitchView:(id)sender;
- (IBAction)showSceneView:(id)sender;

- (IBAction)showMenu:(id)sender;
- (IBAction)showAddMenu:(id)sender;
@end

@implementation SwitchAndSceneViewController

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
  self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * 2,
                                           self.scrollView.frame.size.height);
  self.scrollView.delegate = self;
  UITableView *switchTableView =
      ((UITableViewController *)
       [self.storyboard instantiateViewControllerWithIdentifier:
                            @"SwitchListTableViewController"]).tableView;
  //  switchTableView.frame = self.scrollView.bounds;
  self.tableViewOfSwitch = (SwitchTableView *)switchTableView;
  self.tableViewOfSwitch.switchTableViewDelegate = self;
  [self.scrollView addSubview:switchTableView];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  if (![self.sidePanelController leftPanel]) {
    [self.sidePanelController
        setLeftPanel:kSharedAppliction.leftViewController];
    [self.sidePanelController showLeftPanelAnimated:YES];
  }
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  self.tableViewOfSwitch.frame = self.scrollView.bounds;
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
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
- (IBAction)showSwitchView:(id)sender {
  self.btnSwitch.selected = YES;
  self.btnScene.selected = NO;
  //  [self.viewOfContainer bringSubviewToFront:self.tableViewOfSwitch];
  self.scrollView.contentOffset = CGPointMake(0, 0);
}

- (IBAction)showSceneView:(id)sender {
  self.btnSwitch.selected = NO;
  self.btnScene.selected = YES;
  if (!self.tableViewOfScene) {
    UITableView *sceneTableView =
        ((UITableViewController *)
         [self.storyboard instantiateViewControllerWithIdentifier:
                              @"SceneListTableViewController"]).tableView;
    //    sceneTableView.frame = self.viewOfContainer.bounds;
    sceneTableView.frame = CGRectMake(self.scrollView.frame.size.width, 0,
                                      self.scrollView.frame.size.width,
                                      self.scrollView.frame.size.height);

    self.tableViewOfScene = (SceneTableView *)sceneTableView;
    //    [self.viewOfContainer addSubview:sceneTableView];
    [self.scrollView addSubview:sceneTableView];
  }
  //  [self.viewOfContainer bringSubviewToFront:self.tableViewOfScene];
  self.scrollView.contentOffset =
      CGPointMake(self.scrollView.frame.size.width, 0);
}

- (IBAction)showMenu:(id)sender {
  if ([self.sidePanelController visiblePanel] ==
      kSharedAppliction.leftViewController) {
    [self.sidePanelController showCenterPanelAnimated:YES];
  } else {
    [self.sidePanelController showLeftPanelAnimated:YES];
  }
}

- (IBAction)showAddMenu:(id)sender {
  //  UIBarButtonItem *item = (UIBarButtonItem *)sender;
  [KxMenu setTintColor:[UIColor blackColor]];
  [KxMenu
      showMenuInView:self.view
            fromRect:CGRectMake(self.view.frame.size.width - 35, -20, 20, 20)
           menuItems:@[
                       [KxMenuItem menuItem:@"添加开关"
                                      image:[UIImage imageNamed:@"tjkg"]
                                     target:self
                                     action:@selector(menuItemSocket:)],
                       [KxMenuItem menuItem:@"添加场景"
                                      image:[UIImage imageNamed:@"tjcj"]
                                     target:self
                                     action:@selector(menuItemSence:)]
                     ]];
}

- (void)menuItemSocket:(id)sender {
  UIViewController *nextVC = [self.storyboard
      instantiateViewControllerWithIdentifier:@"AddSwitchNavController"];
  [self presentViewController:nextVC animated:YES completion:^{}];
}

- (void)menuItemSence:(id)sender {
  UIViewController *nextVC = [self.storyboard
      instantiateViewControllerWithIdentifier:@"AddSenceNavController"];
  [self presentViewController:nextVC animated:YES completion:^{}];
}

#pragma mark - SwitchTableViewDelegate
- (void)showSwitchDetail {
  UIViewController *nextVC = [self.storyboard
      instantiateViewControllerWithIdentifier:@"SwitchDetailViewController"];
  [self.navigationController pushViewController:nextVC animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  double i = scrollView.contentOffset.x / (self.view.bounds.size.width);
  if (i == 0) {
    [self showSwitchView:nil];
  } else if (i == 1) {
    [self showSceneView:nil];
  }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate {
  double i = scrollView.contentOffset.x / (self.view.bounds.size.width);
  if (i < 0) {
    [self showMenu:nil];
  }
}
@end
