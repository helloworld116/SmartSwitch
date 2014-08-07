//
//  SceneTableView.m
//  SmartSwitch
//
//  Created by sdzg on 14-8-7.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "SceneTableView.h"
#import "SceneListCell.h"

@interface SceneTableView ()

@property(strong, nonatomic) NSMutableArray *scenes;
@end

@implementation SceneTableView

- (void)awakeFromNib {
  //  self.dataSource = self;
  //  self.delegate = self;
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
//
//- (NSInteger)tableView:(UITableView *)tableView
//    numberOfRowsInSection:(NSInteger)section {
//  return 5;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView
//         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//  static NSString *CellId = @"SceneListCell";
//  SceneListCell *listCell =
//      (SceneListCell *)[tableView dequeueReusableCellWithIdentifier:CellId];
//  return listCell;
//}
//
//#pragma mark - UITableViewDelegate
//- (void)tableView:(UITableView *)tableView
//    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//}
@end
