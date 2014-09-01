//
//  SceneAddView.h
//  SmartSwitch
//
//  Created by sdzg on 14-8-31.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SceneAddViewDelegate<NSObject>
- (void)selectedSwitch:(SDZGSwitch *)aSwitch
                socket:(SDZGSocket *)socket
               onOrOff:(BOOL)onOrOff
             editIndex:(NSInteger)editIndex;
@end

@interface SceneAddView : UIView
@property(nonatomic, assign) id<SceneAddViewDelegate> delegate;
@property(nonatomic, strong) IBOutlet UISwitch *switchOfAction;
@property(nonatomic, strong) IBOutlet UITableView *tableViewOfSwitch;
@property(nonatomic, strong) IBOutlet UITableView *tableViewOfSocket;
- (IBAction)save:(id)sender;
- (IBAction)close:(id)sender;
- (IBAction)touchBackground:(id)sender;

- (void)selectTableViewWithMac:(NSString *)mac
                      socketId:(int)socketId
                       onOrOff:(BOOL)onOrOff
                     editIndex:(NSInteger)index;
@end
