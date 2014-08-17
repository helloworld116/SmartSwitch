//
//  UdpRequest.h
//  SmartSwitch
//
//  Created by 文正光 on 14-8-17.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^sucessResponse)(id);
typedef void (^failureResponse)(int);

@interface UdpRequest : NSObject
@property (atomic, assign) int msg5SendCount;
@property (atomic, strong) NSData *responseData6;

+ (instancetype)sharedInstance;
/**
 *  P2D_SERVER_INFO
 *
 *  @param udpSocket
 *  @param address   发往的地址
 *  @param mode
 */
- (void)sendMsg05:(GCDAsyncUdpSocket *)udpSocket
          address:(NSData *)address
         sendMode:(SENDMODE)mode
          success:(sucessResponse)sucess
           failre:(failureResponse)failure;
@end
