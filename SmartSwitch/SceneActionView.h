//
//  SceneActionView.h
//  SmartSwitch
//
//  Created by sdzg on 14-9-5.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface SceneActionCell : UITableViewCell
@property(nonatomic, strong) IBOutlet UILabel *lblInfo;
@property(nonatomic, strong) IBOutlet UILabel *lblStatus;
@end

@protocol SceneActionViewDelegate<NSObject>
- (void)cancelAction;
@end

@interface SceneActionView : UIView
@property(nonatomic, strong) NSArray *sceneDetails;
@property(nonatomic, assign) id<SceneActionViewDelegate> delegate;
@property(nonatomic, strong) IBOutlet UIView *viewBackground;
@property(nonatomic, strong) IBOutlet UILabel *lblTitle;
@property(nonatomic, strong) IBOutlet UITableView *tableView;
- (IBAction)cancel:(id)sender;
@end
