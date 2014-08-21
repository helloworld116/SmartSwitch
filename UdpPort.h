//
//  UdpPort.h
//  SmartSwitch
//
//  Created by sdzg on 14-8-21.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UdpPort : NSObject
@property(nonatomic, assign) uint16_t port;
@property(nonatomic, assign) BOOL isUsed;
@property(nonatomic, assign) long lastUsedSeconds;
- (id)initPort:(uint16_t)port
             isUsed:(BOOL)isUsed
    lastUsedSeconds:(long)lastUsedSeconds;
@end

@interface UdpPortCenter : NSObject
@property(nonatomic, strong)
    NSMutableDictionary *portDict;  //{"端口号":"UdpPort对象"}

+ (instancetype)sharedInstance;
- (void)usedPort:(uint16_t)port;
- (void)unUsedPort:(uint16_t)port;
- (uint16_t)availablePort;
@end
