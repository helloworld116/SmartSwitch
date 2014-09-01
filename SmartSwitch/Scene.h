//
//  Scene.h
//  SmartSwitch
//
//  Created by 文正光 on 14-9-2.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Scene : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger indentifier;
@property (nonatomic, strong) NSArray *detailList;
@end
