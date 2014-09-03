//
//  UserInfo.h
//  SmartSwitch
//
//  Created by sdzg on 14-9-3.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject
@property(nonatomic, strong) NSString *username;
@property(nonatomic, strong) NSString *password;

- (id)initWithUsername:(NSString *)username password:(NSString *)password;

- (void)send;
@end
