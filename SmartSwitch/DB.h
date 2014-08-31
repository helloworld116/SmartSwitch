//
//  DB.h
//  SmartSwitch
//
//  Created by 文正光 on 14-8-25.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBUtil : NSObject
+ (instancetype)sharedInstance;

- (void)saveSwitchs:(NSArray *)switchs;

- (NSArray *)getSwitchs;
@end
