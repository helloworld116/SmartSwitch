//
//  SceneAddView.h
//  SmartSwitch
//
//  Created by sdzg on 14-8-31.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SceneAddView : UIView
@property(nonatomic, strong) IBOutlet UISwitch *switchOfAction;
@property(nonatomic, strong) IBOutlet UITableView *tableViewOfSwitch;
@property(nonatomic, strong) IBOutlet UITableView *tableViewOfSocket;
- (IBAction)save:(id)sender;
- (IBAction)close:(id)sender;
- (IBAction)touchBackground:(id)sender;
@end
