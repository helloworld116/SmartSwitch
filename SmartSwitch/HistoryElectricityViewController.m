//
//  HistoryElectricityViewController.m
//  SmartSwitch
//
//  Created by sdzg on 14-8-12.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "HistoryElectricityViewController.h"
#import "SwitchDataCeneter.h"
#import "HistoryElecView.h"

@interface HistoryElectricityViewController ()
@property (strong, nonatomic) IBOutlet HistoryElecView *viewOfHistoryElec;
//@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewMonth;
//@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewDay;
//@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewBarChart;
//@property (strong, nonatomic) IBOutlet UIView *viewImgContainer;

@property (strong, nonatomic) SDZGSwitch *aSwitch;
@end

@implementation HistoryElectricityViewController

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
  self.aSwitch = [[SwitchDataCeneter sharedInstance].switchs
      objectAtIndex:[SwitchDataCeneter sharedInstance].selectedIndexPath.row];
  self.navigationItem.title = @"历史电量";
  self.navigationItem.leftBarButtonItem =
      [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fh"]
                                       style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(pop:)];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self senMsg63];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
}

- (void)senMsg63 {
  [[UdpRequest manager] sendMsg63:self.aSwitch
                        beginTime:1406822400
                          endTime:1409500799
                         interval:3600 * 24
                         sendMode:ActiveMode];
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

@end
