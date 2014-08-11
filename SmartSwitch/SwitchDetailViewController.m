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
  //    UIBarButtonItem *btnLeft = [UIBarButtonItem alloc]
  //    initWithCustomView:<#(UIView *)#>
  //    self.navigationItem.leftBarButtonItem
  //  self.scrollView.contentSize = CGSizeMake(320, 516);
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

@end
