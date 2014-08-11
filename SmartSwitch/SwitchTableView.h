//
//  SwitchTableView.h
//  SmartSwitch
//
//  Created by sdzg on 14-8-7.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SwitchTableViewDelegate<NSObject>
- (void)showSwitchDetail;
@end

@interface SwitchTableView : UITableView
@property(nonatomic, assign)
    id<SwitchTableViewDelegate> switchTableViewDelegate;
@end
