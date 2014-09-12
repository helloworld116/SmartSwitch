//
//  SwitchDataCeneter.h
//  SmartSwitch
//
//  Created by sdzg on 14-8-19.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kSwitchUpdate @"SwitchUpdateNotification"

@interface SwitchDataCeneter : NSObject
@property(strong, nonatomic) NSArray *switchs;
@property(strong, nonatomic) NSIndexPath *selectedIndexPath;
+ (instancetype)sharedInstance;

/**
 *  socket开关状态更改
 *
 *  @param socketStaus <#socketStaus description#>
 *  @param socketId    <#socketId description#>
 *  @param mac         <#mac description#>
 *
 *  @return <#return value description#>
 */
- (NSArray *)updateSocketStaus:(SocketStatus)socketStaus
                      socketId:(int)socketId
                           mac:(NSString *)mac;
/**
 *  加解锁后执行
 *
 *  @param lockStatus <#lockStatus description#>
 *  @param mac        <#mac description#>
 *
 *  @return <#return value description#>
 */
- (NSArray *)updateSwitchLockStaus:(LockStatus)lockStatus mac:(NSString *)mac;
/**
 *  查询到设备状态后执行
 *
 *  @param aSwitch <#aSwitch description#>
 *
 *  @return <#return value description#>
 */
- (NSArray *)updateSwitch:(SDZGSwitch *)aSwitch;
/**
 *  定时任务修改后执行
 *
 *  @param timerList <#timerList description#>
 *  @param mac       <#mac description#>
 *  @param socketId  <#socketId description#>
 *
 *  @return <#return value description#>
 */
- (NSArray *)updateTimerList:(NSArray *)timerList
                         mac:(NSString *)mac
                    socketId:(int)socketId;
/**
 *  延迟时间更改后执行
 *
 *  @param delayTime   <#delayTime description#>
 *  @param delayAction <#delayAction description#>
 *  @param mac         <#mac description#>
 *  @param socketId    <#socketId description#>
 *
 *  @return <#return value description#>
 */
- (NSArray *)updateDelayTime:(int)delayTime
                 delayAction:(DelayAction)delayAction
                         mac:(NSString *)mac
                    socketId:(int)socketId;
/**
 *  设备名字更改后执行
 *
 *  @param switchName  <#switchName description#>
 *  @param socketNames <#socketNames description#>
 *  @param mac         <#mac description#>
 *
 *  @return <#return value description#>
 */
- (NSArray *)updateSwitchName:(NSString *)switchName
                  socketNames:(NSArray *)socketNames
                          mac:(NSString *)mac;

/**
 *  退出前保存到数据库
 */
- (void)saveSwitchsToDB;

/**
 *  删除
 *
 *  @param aSwtich <#aSwtich description#>
 *
 *  @return <#return value description#>
 */
- (BOOL)removeSwitch:(SDZGSwitch *)aSwtich;
@end
