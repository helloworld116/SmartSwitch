//
//  LoginResponse.h
//  SmartSwitch
//
//  Created by sdzg on 14-9-4.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginResponse : NSObject
@property(nonatomic, assign) int status;
@property(nonatomic, strong) NSString *errorMsg;
@property(nonatomic, strong) NSDictionary *data;

- (id)initWithResponseString:(NSString *)response;
@end
