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
#import "SwitchDataCeneter.h"

@interface SwitchTableView ()<UITableViewDelegate, UITableViewDataSource,
                              SwitchListCellDelegate, SwitchExpandCellDelegate,
                              EGORefreshTableHeaderDelegate>
@property(strong, nonatomic) NSArray *switchs;
@property(assign, nonatomic) BOOL isOpen;  //是否展开
@property(strong, nonatomic)
    NSIndexPath *selectedIndexPath;  //展开的cell所在的indexPath

@property(strong, nonatomic) EGORefreshTableHeaderView *refreshHeaderView;
@property(assign, nonatomic) BOOL reloading;
@end

@implementation SwitchTableView

#pragma mark - view
- (void)awakeFromNib {
  self.dataSource = self;
  self.delegate = self;
  self.refreshHeaderView = [[EGORefreshTableHeaderView alloc]
      initWithFrame:CGRectMake(0.0f, 0.0f - self.bounds.size.height,
                               self.frame.size.width, self.bounds.size.height)];
  self.refreshHeaderView.delegate = self;
  [self addSubview:self.refreshHeaderView];
  [self.refreshHeaderView refreshLastUpdatedDate];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(switchUpdate:)
                                               name:kSwitchUpdate
                                             object:nil];
  UIView *view =
      [[UIView alloc] initWithFrame:CGRectMake(0, 1, self.frame.size.width, 1)];
  view.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
  self.tableFooterView = view;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:kSwitchUpdate
                                                object:nil];
}

#pragma mark - NotificationCenter
- (void)switchUpdate:(NSNotification *)notification {
  if (notification.object == [SwitchDataCeneter sharedInstance]) {
    self.switchs = [SwitchDataCeneter sharedInstance].switchs;
    // TODO:后期在处理
    dispatch_async(dispatch_get_main_queue(), ^{ [self reloadData]; });
    //      NSDictionary *userInfo = [notification userInfo];
    //      NSString *mac = userInfo[@"mac"];
    //    int type = [userInfo[@"type"] intValue];
    //    if (type == 1) {
    //      //新增
    //      dispatch_async(dispatch_get_main_queue(), ^{ [self reloadData]; });
    //    } else {
    //      for (SwitchListCell *visibleCell in self.visibleCells) {
    //        int row = [self indexPathForCell:visibleCell].row;
    //        SDZGSwitch *aSwitch = [self.switchs objectAtIndex:row];
    //        if ([aSwitch.mac isEqualToString:mac]) {
    //          NSIndexPath *indexPath = [self indexPathForCell:visibleCell];
    //          debugLog(@"indexPath row is %d", indexPath.row);
    //          if (indexPath) {
    //            dispatch_async(dispatch_get_main_queue(), ^{
    //                [self beginUpdates];
    //                [self reloadRowsAtIndexPaths:@[ indexPath ]
    //                            withRowAnimation:UITableViewRowAnimationNone];
    //                [self endUpdates];
    //            });
    //          }
    //        }
    //        break;
    //      }
    //    }
  }
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.selectedIndexPath && indexPath.row == self.selectedIndexPath.row &&
      self.isOpen) {
    return 180;
  } else {
    return 100;
  }
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  return [self.switchs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellId = @"SwitchListCell";
  static NSString *cellForExpandId = @"SwitchExpandCell";
  SwitchListCell *cell;
  SDZGSwitch *aSwitch = [self.switchs objectAtIndex:indexPath.row];
  if (self.selectedIndexPath && indexPath.row == self.selectedIndexPath.row &&
      self.isOpen) {
    SwitchExpandCell *expandCell = (SwitchExpandCell *)
        [tableView dequeueReusableCellWithIdentifier:cellForExpandId];
    expandCell.expandCellDelegate = self;
    expandCell.cellDelegate = self;
    expandCell.isExpand = YES;
    expandCell.btnExpand.transform =
        CGAffineTransformMakeRotation(-90 * (M_PI / 180.0f));
    cell = expandCell;
  } else {
    cell =
        (SwitchListCell *)[tableView dequeueReusableCellWithIdentifier:CellId];
    cell.cellDelegate = self;
    cell.isExpand = NO;
    cell.btnExpand.transform = CGAffineTransformMakeRotation(0);
  }
  [cell setCellInfo:aSwitch];
  return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [SwitchDataCeneter sharedInstance].selectedIndexPath = indexPath;
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  if ([self.switchTableViewDelegate
          respondsToSelector:@selector(showSwitchDetail:)]) {
    [self.switchTableViewDelegate showSwitchDetail:indexPath];
  }
}

#pragma mark - SwitchListCellDelegate
- (void)cellDoExpand:(SwitchListCell *)cell {
  CGFloat angle;
  NSMutableArray *indexPaths = [@[] mutableCopy];
  NSIndexPath *indexPath = [self indexPathForCell:cell];
  if (cell.isExpand && self.selectedIndexPath.row == indexPath.row) {
    //关闭
    angle = 0 * (M_PI / 180.0f);
    self.isOpen = NO;
    if (self.selectedIndexPath) {
      self.selectedIndexPath = nil;
    } else {
      self.selectedIndexPath = indexPath;
    }
    [indexPaths addObject:indexPath];
  } else {
    //展开
    angle = -90 * (M_PI / 180.0f);
    if (self.selectedIndexPath && self.selectedIndexPath.row != indexPath.row) {
      [indexPaths addObject:self.selectedIndexPath];
      SwitchListCell *oldExpandCell =
          (SwitchListCell *)[self cellForRowAtIndexPath:self.selectedIndexPath];
      oldExpandCell.isExpand = NO;
      [UIView animateWithDuration:0.3
                       animations:^{
                           oldExpandCell.btnExpand.transform =
                               CGAffineTransformMakeRotation(0);
                       }];
    }
    self.isOpen = YES;
    self.selectedIndexPath = indexPath;
    [indexPaths addObject:indexPath];
  }
  [UIView animateWithDuration:0.3
                   animations:^{
                       cell.btnExpand.transform =
                           CGAffineTransformMakeRotation(angle);
                   }];
  [self reloadRowsAtIndexPaths:indexPaths
              withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - SwitchExpandCellDelegate
- (void)socketAction:(UITableViewCell *)cell socketId:(int)socketId {
  if ([self.switchTableViewDelegate
          respondsToSelector:@selector(socketAction:socketId:)]) {
    NSIndexPath *indexPath = [self indexPathForCell:cell];
    if (indexPath) {
      SDZGSwitch *aSwitch = [self.switchs objectAtIndex:indexPath.row];
      [self.switchTableViewDelegate socketAction:aSwitch socketId:socketId];
    }
  }
}

#pragma mark - Data Source Loading / Reloading Methods
- (void)reloadTableViewDataSource {
  //  should be calling your tableviews data source model to reload
  //  put here just for demo
  _reloading = YES;
}

- (void)doneLoadingTableViewData {
  //  model should call this when its done loading
  _reloading = NO;
  [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate {
  [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:
            (EGORefreshTableHeaderView *)view {
  [self reloadTableViewDataSource];
  [self performSelector:@selector(doneLoadingTableViewData)
             withObject:nil
             afterDelay:3.0];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:
            (EGORefreshTableHeaderView *)view {
  return _reloading;  // should return if data source model is reloading
}

- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:
                (EGORefreshTableHeaderView *)view {
  return [NSDate date];  // should return date data source was last changed
}

@end
