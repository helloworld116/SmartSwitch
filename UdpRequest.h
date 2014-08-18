//
//  UdpRequest.h
//  SmartSwitch
//
//  Created by 文正光 on 14-8-17.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^successBlock)(CC3xMessage *message);
typedef void (^noResponseBlock)(int count);
typedef void (^noResponseWithMacBlock)(int count, NSString *mac);
typedef void (^noRequestBlock)(long tag);

@interface UdpRequest : NSObject
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
          success:(successBlock)success
           failre:(noResponseBlock)failure;

/**
 *  手机向内网查询设备的开关状态
 *
 *  @param udpSocket
 *  @param mode
 */
- (void)sendMsg0BMode:(SENDMODE)mode
              success:(successBlock)success
           noResponse:(noResponseBlock)noResponse
               noSend:(noRequestBlock)noSend;
/**
 *  手机控制开关“开或关”
 *
 *  @param udpSocket
 *  @param aSwitch
 *  @param isSwitchOn 开关当前状态，即发送指令前的状态
 *  @param mode
 */
- (void)sendMsg11Or13:(CC3xSwitch *)aSwitch
             socketId:(int)socketId
             sendMode:(SENDMODE)mode
         successBlock:(successBlock)successBlock
      noResponseBlock:(noResponseBlock)noResponseBlock
       noRequestBlock:(noRequestBlock)noRequestBlock;
/**
 *  手机获取设备定时列表
 *
 *  @param udpSocket
 *  @param aSwitch
 *  @param mode
 */
- (void)sendMsg17Or19:(CC3xSwitch *)aSwitch
             socketId:(int)socketId
             sendMode:(SENDMODE)mode
         successBlock:(successBlock)successBlock
      noResponseBlock:(noResponseBlock)noResponseBlock
       noRequestBlock:(noRequestBlock)noRequestBlock;
/**
 *  手机设置设备定时列表
 *
 *  @param udpSocket
 *  @param aSwitch
 *  @param timeList  定时列表集合
 *  @param mode
 */
- (void)sendMsg1DOr1F:(CC3xSwitch *)aSwitch
             socketId:(int)socketId
             timeList:(NSArray *)timeList
             sendMode:(SENDMODE)mode
         successBlock:(successBlock)successBlock
      noResponseBlock:(noResponseBlock)noResponseBlock
       noRequestBlock:(noRequestBlock)noRequestBlock;
/**
 *  手机获取设备控制权限
 *
 *  @param udpSocket
 *  @param aSwitch
 *  @param mode
 */
- (void)sendMsg25Or27:(GCDAsyncUdpSocket *)udpSocket
              aSwitch:(CC3xSwitch *)aSwitch
             sendMode:(SENDMODE)mode;

- (void)sendMsg33Or35:(CC3xSwitch *)aSwitch
             sendMode:(SENDMODE)mode
         successBlock:(successBlock)successBlock
      noResponseBlock:(noResponseBlock)noResponseBlock
       noRequestBlock:(noRequestBlock)noRequestBlock;

/**
 *  设备定位，即使设备灯闪烁
 *
 *  @param udpSocket
 *  @param aSwitch
 *  @param on        定位标识，目前只有1，表示定位
 *  @param mode
 */
- (void)sendMsg39Or3B:(CC3xSwitch *)aSwitch
                   on:(BOOL)on
             sendMode:(SENDMODE)mode
         successBlock:(successBlock)successBlock
      noResponseBlock:(noResponseBlock)noResponseBlock
       noRequestBlock:(noRequestBlock)noRequestBlock;
/**
 *  设置设备名称
 *
 *  @param udpSocket
 *  @param aSwitch
 *  @param name      设备名称
 *  @param mode
 */
- (void)sendMsg3FOr41:(CC3xSwitch *)aSwitch
                 type:(int)type
                 name:(NSString *)name
             sendMode:(SENDMODE)mode
         successBlock:(successBlock)successBlock
      noResponseBlock:(noResponseBlock)noResponseBlock
       noRequestBlock:(noRequestBlock)noRequestBlock;
/**
 *  设备加锁
 *
 *  @param udpSocket
 *  @param aSwitch
 *  @param isLock    设备当前的锁定状态，即发送指令前的状态
 *  @param mode
 */
- (void)sendMsg47Or49:(CC3xSwitch *)aSwitch
             sendMode:(SENDMODE)mode
         successBlock:(successBlock)successBlock
      noResponseBlock:(noResponseBlock)noResponseBlock
       noRequestBlock:(noRequestBlock)noRequestBlock;
/**
 *  设置设备延时任务
 *
 *  @param udpSocket
 *  @param aSwitch
 *  @param delayTime 延时时间，单位分钟
 *  @param on        0x1表示开，0x0表示关
 *  @param mode
 */
- (void)sendMsg4DOr4F:(CC3xSwitch *)aSwitch
             socketId:(int)socketId
            delayTime:(NSInteger)delayTime
             switchOn:(BOOL)on
             sendMode:(SENDMODE)mode
         successBlock:(successBlock)successBlock
      noResponseBlock:(noResponseBlock)noResponseBlock
       noRequestBlock:(noRequestBlock)noRequestBlock;
/**
 *  查询设备延时任务
 *
 *  @param udpSocket
 *  @param aSwitch
 *  @param mode
 */
- (void)sendMsg53Or55:(CC3xSwitch *)aSwitch
             socketId:(int)socketId
             sendMode:(SENDMODE)mode
         successBlock:(successBlock)successBlock
      noResponseBlock:(noResponseBlock)noResponseBlock
       noRequestBlock:(noRequestBlock)noRequestBlock;

- (void)sendMsg5DOr5F:(CC3xSwitch *)aSwitch
             sendMode:(SENDMODE)mode
         successBlock:(successBlock)successBlock
      noResponseBlock:(noResponseBlock)noResponseBlock
       noRequestBlock:(noRequestBlock)noRequestBlock;

@end
