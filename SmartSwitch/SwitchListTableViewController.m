//
//  SwitchListTableViewController.m
//  SmartSwitch
//
//  Created by sdzg on 14-8-7.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "SwitchListTableViewController.h"
#import "SwitchListCell.h"

@interface SwitchListTableViewController ()

@end

@implementation SwitchListTableViewController

- (id)initWithStyle:(UITableViewStyle)style {
  self = [super initWithStyle:style];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  // Uncomment the following line to preserve selection between presentations.
  // self.clearsSelectionOnViewWillAppear = NO;

  // Uncomment the following line to display an Edit button in the navigation
  // bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
  NSLog(@"2");
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
//- (CGFloat)tableView:(UITableView *)tableView
//    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//  return self.tableView.rowHeight;
//}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellId = @"SwitchListCell";
  SwitchListCell *listCell =
      (SwitchListCell *)[tableView dequeueReusableCellWithIdentifier:CellId];
  return listCell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

@end
