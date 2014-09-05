//
//  SceneActionView.h
//  SmartSwitch
//
//  Created by sdzg on 14-9-5.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SceneActionView : UIView
@property(nonatomic, strong) IBOutlet UIView *viewBackground;
@property(nonatomic, strong) IBOutlet UILabel *lblTitle;
@property(nonatomic, strong) IBOutlet UITableView *tableView;
- (IBAction)cancel:(id)sender;
@end
