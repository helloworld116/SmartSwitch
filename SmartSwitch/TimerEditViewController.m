//
//  TimerEditViewController.m
//  SmartSwitch
//
//  Created by sdzg on 14-8-14.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "TimerEditViewController.h"

@interface TimerEditTableView : UITableView
@property(strong, nonatomic) IBOutlet UIView *cellView1;
@property(strong, nonatomic) IBOutlet UIView *cellView2;
@property(strong, nonatomic) IBOutlet UIView *cellView3;
@property(strong, nonatomic) IBOutlet UIView *cellView4;
@end

@implementation TimerEditTableView
- (void)awakeFromNib {
  self.cellView1.layer.borderWidth = 1.0f;
  self.cellView1.layer.borderColor = [UIColor lightGrayColor].CGColor;
  self.cellView1.layer.cornerRadius = 1.5f;
  self.cellView2.layer.borderWidth = 1.0f;
  self.cellView2.layer.borderColor = [UIColor lightGrayColor].CGColor;
  self.cellView2.layer.cornerRadius = 1.5f;
  self.cellView3.layer.borderWidth = 1.0f;
  self.cellView3.layer.borderColor = [UIColor lightGrayColor].CGColor;
  self.cellView3.layer.cornerRadius = 1.5f;
  self.cellView4.layer.borderWidth = 1.0f;
  self.cellView4.layer.borderColor = [UIColor lightGrayColor].CGColor;
  self.cellView4.layer.cornerRadius = 1.5f;
}
@end

@interface TimerEditViewController ()

@end

@implementation TimerEditViewController

- (id)initWithStyle:(UITableViewStyle)style {
  self = [super initWithStyle:style];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.navigationItem.title = @"";
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
      initWithImage:[UIImage imageNamed:@"fh"]
              style:UIBarButtonItemStylePlain
             target:self.navigationController
             action:@selector(popViewControllerAnimated:)];
  self.navigationItem.rightBarButtonItem =
      [[UIBarButtonItem alloc] initWithTitle:@"保存"
                                       style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(save:)];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == 0) {
    UIViewController *nextVC = [self.storyboard
        instantiateViewControllerWithIdentifier:@"CycleViewController"];
    [self.navigationController pushViewController:nextVC animated:YES];
  }
}

#pragma mark - UINavigationBar事件
- (void)save:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}
@end