//
//  TimerEditViewController.h
//  SmartSwitch
//
//  Created by sdzg on 14-8-14.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimerEditViewController : UIViewController
@property(nonatomic, strong) NSArray *timers;       //所有的定时任务
@property(nonatomic, strong) SDZGTimerTask *timer;  //正在编辑的定时任务
@end
