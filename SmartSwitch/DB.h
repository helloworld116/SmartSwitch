//
//  DB.h
//  SmartSwitch
//
//  Created by sdzg on 14-8-25.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBUtil : NSObject
+ (instancetype)sharedInstance;

- (void)saveSwitchs:(NSArray *)switchs;

- (NSArray *)getSwitchs;

- (void)deleteSwitch:(NSString *)mac;

- (NSArray *)getScenes;

- (BOOL)saveScene:(id)scene;

- (BOOL)deleteScene:(id)object;
@end
