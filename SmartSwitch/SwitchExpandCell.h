//
//  SwitchExpandCell.h
//  SmartSwitch
//
//  Created by sdzg on 14-8-7.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwitchListCell.h"

@protocol SwitchExpandCellDelegate<NSObject>
- (void)socketAction:(UIButton *)btnSocket;
@end

@interface SwitchExpandCell : SwitchListCell
@property(strong, nonatomic) IBOutlet UIButton *btnSocket1;
@property(strong, nonatomic) IBOutlet UIButton *btnSocket2;
- (IBAction)socketTouched:(id)sender;
@property(nonatomic, assign) id<SwitchExpandCellDelegate> expandCellDelegate;
@end
