//
//  SwitchTableView.m
//  SmartSwitch
//
//  Created by sdzg on 14-8-7.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "SwitchTableView.h"
#import "SwitchListCell.h"
#import "SwitchExpandCell.h"

@interface SwitchTableView ()<UITableViewDelegate, UITableViewDataSource>
@property(strong, nonatomic) NSMutableArray *switchs;
@end

@implementation SwitchTableView

#pragma mark - view
- (void)awakeFromNib {
  self.dataSource = self;
  self.delegate = self;
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
