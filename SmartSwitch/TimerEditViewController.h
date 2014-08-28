//
//  TimerEditViewController.h
//  SmartSwitch
//
//  Created by sdzg on 14-8-14.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kAddOrEditTimerNotification @"AddOrEditTimerNotification"
@interface TimerEditViewController : UIViewController

/**
 *  初始化参数设置
 *
 *  @param timers 定时列表集合
 *  @param timer  正在编辑的定时列表,nil表示执行添加操作
 *  @param index  正在编辑的定时列表在集合的索引，-1则表示执行添加操作
 */
- (void)setParamSwitch:(SDZGSwitch *)aSwtich
              socketId:(int)socketId
                timers:(NSMutableArray *)timers
                 timer:(SDZGTimerTask *)timer
                 index:(int)index;
@end
