//
//  DESUtil.h
//  SmartSwitch
//
//  Created by sdzg on 14-9-2.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DESUtil : NSObject
+ (NSString *)textFromBase64String:(NSString *)base64;

+ (NSString *)base64StringFromText:(NSString *)text;

+ (NSString *)hexStringFromString:(NSString *)string;
@end
