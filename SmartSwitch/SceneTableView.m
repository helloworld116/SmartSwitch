//
//  SceneTableView.m
//  SmartSwitch
//
//  Created by sdzg on 14-8-7.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "SceneTableView.h"
#import "SceneListCell.h"

@interface SceneTableView ()<UITableViewDataSource, UITableViewDelegate,
                             UIActionSheetDelegate>

@property(strong, nonatomic) NSMutableArray *scenes;
@end

@implementation SceneTableView

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
//  return self.rowHeight;
//}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellId = @"SceneListCell";
  SceneListCell *listCell =
      (SceneListCell *)[tableView dequeueReusableCellWithIdentifier:CellId];
  UILongPressGestureRecognizer *longPressGesture =
      [[UILongPressGestureRecognizer alloc]
          initWithTarget:self
                  action:@selector(handlerLongPress:)];
  longPressGesture.minimumPressDuration = 0.5;
  [listCell addGestureRecognizer:longPressGesture];
  return listCell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - SceneListCellHandler
- (void)handlerLongPress:(UILongPressGestureRecognizer *)gestureRecognizer {
  CGPoint p = [gestureRecognizer locationInView:self];
  NSIndexPath *indexPath = [self indexPathForRowAtPoint:p];
  if (indexPath && gestureRecognizer.state == UIGestureRecognizerStateBegan) {
    NSLog(@"indexPath is %d", indexPath.row);
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                 initWithTitle:@"请选择如何操作该条指令"
                      delegate:self
             cancelButtonTitle:@"取消"
        destructiveButtonTitle:nil
             otherButtonTitles:@"插入", @"重设", @"删除", nil];
    //  [actionSheet showFromRect:self.bounds inView:self animated:YES];
    [actionSheet showInView:self];
  }
}

- (void)actionSheet:(UIActionSheet *)actionSheet
    clickedButtonAtIndex:(NSInteger)buttonIndex {
  NSLog(@"index is %d", buttonIndex);
}
@end
