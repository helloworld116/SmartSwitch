//
//  ElecRealTimeView.h
//  SmartSwitch
//
//  Created by sdzg on 14-8-23.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ElecRealTimeView : UIView
@property(nonatomic, strong) NSMutableArray *powers;
@property(nonatomic, strong) UILabel *lblCurrent;
@end
