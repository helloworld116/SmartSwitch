//
//  AboutViewController.m
//  SmartSwitch
//
//  Created by sdzg on 14-8-6.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()
@property(strong, nonatomic) IBOutlet UILabel *lblInfo;
- (IBAction)back:(id)sender;
- (IBAction)update:(id)sender;
@end

@implementation AboutViewController
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
  self.navigationItem.title = @"关于";
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

- (IBAction)update:(id)sender {
  [self.view
      makeToast:@"已是最新版本"
       duration:1.f
       position:[NSValue
                    valueWithCGPoint:CGPointMake(
                                         self.view.frame.size.width / 2,
                                         self.view.frame.size.height - 40)]];
}
@end
