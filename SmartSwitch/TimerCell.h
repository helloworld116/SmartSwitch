//
//  TimerCell.h
//  SmartSwitch
//
//  Created by sdzg on 14-8-13.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimerCell : UITableViewCell
@property(strong, nonatomic) IBOutlet UIView *viewContent;
@property(strong, nonatomic) IBOutlet UIView *lblTimeInfo;
@property(strong, nonatomic) IBOutlet UILabel *lblAction;
@property(strong, nonatomic) IBOutlet UILabel *lblRepeate;
@property(strong, nonatomic) IBOutlet UILabel *lblExecuteCout;
@property(strong, nonatomic) IBOutlet UISwitch *_switch;

@end
