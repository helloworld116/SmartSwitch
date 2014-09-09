//
//  SceneTableView.m
//  SmartSwitch
//
//  Created by sdzg on 14-8-7.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "SceneTableView.h"
#import "SceneListCell.h"
#import "SceneDataCenter.h"

@interface SceneTableView ()<UITableViewDataSource, UITableViewDelegate,
                             UIActionSheetDelegate, SceneCellDelegate>

@property(strong, nonatomic) NSArray *scenes;
@property(strong, nonatomic) NSIndexPath *longPressIndexPath;
@end

@implementation SceneTableView

- (void)awakeFromNib {
  self.dataSource = self;
  self.delegate = self;
  self.scenes = [[SceneDataCenter sharedInstance] scenes];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(sceneUpdate:)
                                               name:kSceneDataChanged
                                             object:nil];
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:kSceneDataChanged
                                                object:nil];
}

- (void)sceneUpdate:(NSNotification *)notification {
  self.scenes = [[SceneDataCenter sharedInstance] scenes];
  dispatch_async(dispatch_get_main_queue(), ^{ [self reloadData]; });
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
  return self.scenes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellId = @"SceneListCell";
  SceneListCell *listCell =
      (SceneListCell *)[tableView dequeueReusableCellWithIdentifier:CellId];
  listCell.delegate = self;
  Scene *scene = [self.scenes objectAtIndex:indexPath.row];
  [listCell setScene:scene];
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
  if ([self.sceneDelegate respondsToSelector:@selector(showSceneDetail:)]) {
    [self.sceneDelegate showSceneDetail:indexPath];
  }
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - SceneCellDelegate
- (void)sceneAction:(SceneListCell *)cell {
  NSIndexPath *indexPath = [self indexPathForCell:cell];
  if ([self.sceneDelegate respondsToSelector:@selector(sceneAction:)]) {
    [self.sceneDelegate sceneAction:indexPath];
  }
}

#pragma mark - SceneListCellHandler
- (void)handlerLongPress:(UILongPressGestureRecognizer *)gestureRecognizer {
  CGPoint p = [gestureRecognizer locationInView:self];
  NSIndexPath *indexPath = [self indexPathForRowAtPoint:p];
  if (indexPath && gestureRecognizer.state == UIGestureRecognizerStateBegan) {
    self.longPressIndexPath = indexPath;
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                 initWithTitle:@"请选择如何操作该条指令"
                      delegate:self
             cancelButtonTitle:@"取消"
        destructiveButtonTitle:nil
             otherButtonTitles:@"删除", nil];
    [actionSheet showInView:self];
  }
}

- (void)actionSheet:(UIActionSheet *)actionSheet
    clickedButtonAtIndex:(NSInteger)buttonIndex {
  NSLog(@"index is %d", buttonIndex);
  switch (buttonIndex) {
    case 0:
      //插入
      break;
    case 1:
      //重设
      break;
    case 2: {
      Scene *scene = [self.scenes objectAtIndex:self.longPressIndexPath.row];
      BOOL result = [[DBUtil sharedInstance] deleteScene:scene];
      if (result) {
        [[NSNotificationCenter defaultCenter]
            postNotificationName:kSceneDataChanged
                          object:nil];
        [self makeToast:@"删除成功"
               duration:1.f
               position:[NSValue
                            valueWithCGPoint:CGPointMake(
                                                 self.frame.size.width / 2,
                                                 self.frame.size.height - 40)]];
      }
      break;
    }
    default:
      break;
  }
}
@end
