//
//  SwitchDataCeneter.h
//  SmartSwitch
//
//  Created by sdzg on 14-8-19.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kSwitchUpdate @"SwitchUpdateNotification"

@interface SwitchDataCeneter : NSObject
@property(strong, atomic) NSArray *switchs;
@property(strong, nonatomic) NSIndexPath *selectedIndexPath;
+ (instancetype)sharedInstance;

- (void)updateSwitch:(SDZGSwitch *)aSwitch;
@end
