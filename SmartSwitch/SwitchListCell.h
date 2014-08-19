//
//  SwitchListCell.h
//  SmartSwitch
//
//  Created by sdzg on 14-8-7.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SwitchListCell;
@protocol SwitchListCellDelegate<NSObject>
- (void)cellDoExpand:(SwitchListCell *)cell;
@end
@interface SwitchListCell : UITableViewCell
@property(strong, nonatomic) IBOutlet UIImageView *imgViewOfSwitch;
@property(strong, nonatomic) IBOutlet UIImageView *imgViewOfState;
@property(strong, nonatomic) IBOutlet UILabel *lblName;
@property(strong, nonatomic) IBOutlet UIButton *btnExpand;
@property(nonatomic, assign) id<SwitchListCellDelegate> cellDelegate;
@property(nonatomic, assign) BOOL isExpand;
- (IBAction)doExpand:(id)sender;
- (void)setCellInfo:(SDZGSwitch *)aSwitch;
@end
