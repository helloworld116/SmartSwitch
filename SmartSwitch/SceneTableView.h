//
//  SceneTableView.h
//  SmartSwitch
//
//  Created by sdzg on 14-8-7.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SceneTableViewDelegate<NSObject>
@required
- (void)showSceneDetail:(NSIndexPath *)indexPath;
- (void)sceneAction:(NSIndexPath *)indexPath;
@end

@interface SceneTableView : UITableView
@property(nonatomic, assign) id<SceneTableViewDelegate> sceneDelegate;
@end
