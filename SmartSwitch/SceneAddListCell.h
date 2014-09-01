//
//  SceneAddListCell.h
//  SmartSwitch
//
//  Created by sdzg on 14-8-31.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SceneAddListCell;
@protocol SceneAddListCellDeleage<NSObject>
- (void)selectedCell:(SceneAddListCell *)cell;
@end

@interface SceneAddListCell : UITableViewCell
@property(nonatomic, assign) id<SceneAddListCellDeleage> delegate;
@property(nonatomic, strong) IBOutlet UILabel *lblAction;

- (IBAction)buttonClick:(id)sender;
@end
