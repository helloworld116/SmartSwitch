//
//  SceneListCell.h
//  SmartSwitch
//
//  Created by sdzg on 14-8-7.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Scene.h"
@class SceneListCell;
@protocol SceneCellDelegate<NSObject>
- (void)sceneAction:(SceneListCell *)cell;
@end

@interface SceneListCell : UITableViewCell
@property(nonatomic, assign) id<SceneCellDelegate> delegate;
@property(nonatomic, strong) IBOutlet UIImageView *imgViewScene;
@property(nonatomic, strong) IBOutlet UILabel *lblName;
- (IBAction)doScene:(id)sender;

- (void)setScene:(Scene *)scene;
@end
