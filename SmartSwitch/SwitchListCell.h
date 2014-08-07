//
//  SwitchListCell.h
//  SmartSwitch
//
//  Created by sdzg on 14-8-7.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwitchListCell : UITableViewCell
@property(strong, nonatomic) IBOutlet UIImageView *imgViewOfSwitch;
@property(strong, nonatomic) IBOutlet UIImageView *imgViewOfState;
@property(strong, nonatomic) IBOutlet UILabel *lblName;
@property(strong, nonatomic) IBOutlet UIButton *btnExpand;
- (IBAction)doExpand:(id)sender;

@end
