//
//  NetUtil.h
//  winmin
//
//  Created by sdzg on 14-7-25.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetUtil : NSObject
+ (instancetype)sharedInstance;
- (void)addNetWorkChangeNotification;
@end
