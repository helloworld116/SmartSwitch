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
#import "SwitchDetailViewController.h"

@interface SwitchTableView ()<UITableViewDelegate, UITableViewDataSource,
                              SwitchListCellDelegate>
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
  return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellId = @"SwitchListCell";
  SwitchListCell *listCell =
      (SwitchListCell *)[tableView dequeueReusableCellWithIdentifier:CellId];
  listCell.cellDelegate = self;
  return listCell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  if ([self.switchTableViewDelegate
          respondsToSelector:@selector(showSwitchDetail)]) {
    [self.switchTableViewDelegate showSwitchDetail];
  }
}

#pragma mark - SwitchListCellDelegate
- (void)cellDoExpand:(SwitchListCell *)cell {
  CGFloat angle;
  if (cell.isExpand) {
    angle = 0 * (M_PI / 180.0f);
  } else {
    angle = -90 * (M_PI / 180.0f);
  }
  [UIView animateWithDuration:0.3
                   animations:^{
                       cell.btnExpand.transform =
                           CGAffineTransformMakeRotation(angle);
                   }];
}
@end
