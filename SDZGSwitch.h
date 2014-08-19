//
//  SDZGSwitch.h
//  SmartSwitch
//
//  Created by sdzg on 14-8-19.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import <Foundation/Foundation.h>
//#define on YES
//#define off NO
// typedef BOOL delayAction;
// typedef BOOL socketStatus;
// typedef BOOL actionType;
typedef NS_OPTIONS(NSUInteger, SwitchStatus) {
    SWITCH_UNKNOWN, SWITCH_LOCAL,       SWITCH_LOCAL_LOCK, SWITCH_OFFLINE,
    SWITCH_REMOTE,  SWITCH_REMOTE_LOCK, SWITCH_NEW,
};

typedef NS_OPTIONS(NSUInteger, DelayAction) {
    DelayActionOff = 0, DelayActionOn,
};
typedef NS_OPTIONS(NSUInteger, SocketStatus) {
    SocketStatusOff = 0, SocketStatusOn,
};
typedef NS_OPTIONS(NSUInteger, TimerActionType) {
    TimerActionTypeOff = 0, TimerActionTypeOn,
};
typedef NS_OPTIONS(NSUInteger, LockStatus) {
    LockStatusOff = 0, LockStatusOn,
};

@interface SDZGSwitch : NSObject
@property(nonatomic, strong) NSString *name;
@property(nonatomic, assign) SwitchStatus switchStatus;
@property(nonatomic, strong) NSString *mac;
@property(nonatomic, strong) NSString *ip;
@property(nonatomic, assign) unsigned short port;
@property(nonatomic, assign) LockStatus lockStatus;
@property(nonatomic, strong) NSMutableArray *sockets;  //插孔
@property(nonatomic, assign) char version;
@property(nonatomic, assign) long tag;  //记录udp请求发送时的tag
@property(nonatomic, strong) NSString *imageName;
@end

@interface SDZGSocket : NSObject
@property(nonatomic, assign) int socketId;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSMutableArray *timerList;
@property(nonatomic, assign) short delayTime;  //延迟剩余时间，单位分钟
@property(nonatomic, assign)
    DelayAction delayAction;  //延迟操作 on为开操作，off为关操作
@property(nonatomic, assign)
    SocketStatus socketStatus;  //开关状态，on为开，off为关
@property(nonatomic, strong) NSString *imageName;
@end

@interface SDZGTimerTask : NSObject
@property(nonatomic, assign) unsigned char week;
@property(nonatomic, assign) unsigned int actionTime;  //动作时间
@property(nonatomic, assign) BOOL isEffective;         //是否生效
@property(nonatomic, assign)
    TimerActionType timerActionType;  //动作类型，on表示开，off表示关
@end