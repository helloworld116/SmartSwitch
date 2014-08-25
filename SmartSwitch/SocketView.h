//
//  SocketView.h
//  SmartSwitch
//
//  Created by sdzg on 14-8-11.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimerCountdownView.h"

@protocol SocketViewDelegate<NSObject>
- (void)socketTimer:(int)socketId;
- (void)socketDelay:(int)socketId;
- (void)socketChangeStatus:(int)socketId;
@end

@interface SocketView : UIView
@property(nonatomic, assign) id<SocketViewDelegate> delegate;
/**
 *  初始化socket
 *
 *  @param socketId
 *  @param name         名称
 *  @param status       开关状态
 *  @param timerSeconds 定时（单位秒钟）
 *  @param delaySeconds 延时（单位秒钟）
 */
- (void)socketId:(int)socketId
      socketName:(NSString *)name
          status:(SocketStatus)status
           timer:(int)timerSeconds
           delay:(int)delaySeconds;

/**
 *  延迟倒计时
 *
 *  @param seconds 秒钟
 */
- (void)countDown:(int)seconds;

/**
 *  设置定时时间
 *
 *  @param seconds 秒
 */
- (void)setTimer:(int)seconds;

/**
 *  设置socket的名称
 *
 *  @param socketName socket的名称
 */
- (void)setSocketName:(NSString *)socketName;

/**
 *  设置socket的开关显示
 *
 *  @param status 开关状态
 */
- (void)setSocketStatus:(SocketStatus)status;
@end
