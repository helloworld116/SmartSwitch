//
//  UdpViewController.m
//  SmartSwitch
//
//  Created by sdzg on 14-8-22.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "UdpViewController.h"

@interface UdpViewController ()<UdpRequestDelegate>
@property(nonatomic, strong) UdpRequest *request;
@end

@implementation UdpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  //  dispatch_sync(dispatch_get_main_queue(),
  //                ^{ [NSThread sleepForTimeInterval:2]; });
  dispatch_queue_t queue =
      dispatch_queue_create("com.itouchco.www", DISPATCH_QUEUE_CONCURRENT);
  static NSTimeInterval seconds = 5;

  [self setup];
  //  [self sendMsg05];

  //  [self sendMsg09];
  //  [self sendMsg0B];

  // 0表示内网，1表示外网
  //  [self sendMsg0BOr0D:0];
  //  [self sendMsg0BOr0D:1];
  //  [self sendMsg11Or13:0];
  //  [self sendMsg11Or13:1];
  //  [self sendMsg17Or19:0];
  //  [self sendMsg17Or19:1];

  //  [self sendMsg1DOr1F:0];//失败，结构体相关处理
  //  [self sendMsg1DOr1F:1];//失败，结构体相关处理

  //  [self sendMsg33Or35:0];
  //  [self sendMsg33Or35:1];
  //  [self sendMsg39Or3B:0];
  //  [self sendMsg39Or3B:1];
  //  [self sendMsg3FOr41:0];
  //  [self sendMsg3FOr41:1];//设置名称好像有问题

  //  [self sendMsg47Or49:0];
  //  [self sendMsg47Or49:1];
  //  [self sendMsg4DOr4F:0];
  //  [self sendMsg4DOr4F:1];
  //  [self sendMsg53Or55:0];
  //  [self sendMsg53Or55:1];
  //  [self sendMsg5DOr5F:0];
  //  [self sendMsg5DOr5F:1];

  //  [self sendMsg63];
  //  [self sendMsg65];

  dispatch_barrier_async(queue, ^{
      [self setup];
      [self sendMsg11Or13:0];
      [NSThread sleepForTimeInterval:seconds];
  });

  dispatch_barrier_async(queue, ^{
      [self sendMsg17Or19:0];
      [NSThread sleepForTimeInterval:seconds];
  });

  dispatch_barrier_async(queue, ^{
      [self sendMsg33Or35:0];
      [NSThread sleepForTimeInterval:seconds];
  });

  dispatch_barrier_async(queue, ^{
      [self sendMsg39Or3B:0];
      [NSThread sleepForTimeInterval:seconds];
  });

  dispatch_barrier_async(queue, ^{
      [self sendMsg3FOr41:0];
      [NSThread sleepForTimeInterval:seconds];
  });

  dispatch_barrier_async(queue, ^{
      [self sendMsg47Or49:0];
      [NSThread sleepForTimeInterval:seconds];
  });

  dispatch_barrier_async(queue, ^{
      [self sendMsg4DOr4F:0];
      [NSThread sleepForTimeInterval:seconds];
  });

  dispatch_barrier_async(queue, ^{
      [self sendMsg53Or55:0];
      [NSThread sleepForTimeInterval:seconds];
  });

  dispatch_barrier_async(queue, ^{
      [self sendMsg5DOr5F:0];
      [NSThread sleepForTimeInterval:seconds];
  });
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)setup {
  self.request = [UdpRequest manager];
  self.request.delegate = self;
}

- (void)sendMsg05 {
  [self.request sendMsg05:@"192.168.0.120" port:56797 mode:ActiveMode];
}

- (void)sendMsg09 {
  [self.request sendMsg09:ActiveMode];
}

/**
 *  手机向内网查询所有设备的开关状态
 *
 *  @param udpSocket
 *  @param mode
 */
- (void)sendMsg0B {
  [self.request sendMsg0B:ActiveMode];
}

/**
 *  手机向外网查询所有设备的开关状态
 *
 *  @param udpSocket
 *  @param mode
 */
- (void)sendMsg0D:(NSString *)mac sendMode:(SENDMODE)mode tag:(long)tag {
}

/**
 *  手机向查询指定设备的开关状态
 *
 *  @param udpSocket
 *  @param mode
 */
- (void)sendMsg0BOr0D:(int)type {
  if (type == 1) {
    kSharedAppliction.networkStatus = ReachableViaWWAN;
  }
  SDZGSwitch *aSwitch = [self getSocket];
  [self.request sendMsg0BOr0D:aSwitch sendMode:ActiveMode];
}

/**
 *  手机控制开关“开或关”
 *
 *  @param udpSocket
 *  @param aSwitch
 *  @param isSwitchOn 开关当前状态，即发送指令前的状态
 *  @param mode
 */
- (void)sendMsg11Or13:(int)type {
  if (type == 1) {
    kSharedAppliction.networkStatus = ReachableViaWWAN;
  }
  SDZGSwitch *aSwitch = [self getSocket];
  [self.request sendMsg11Or13:aSwitch socketId:1 sendMode:ActiveMode];
}
/**
 *  手机获取设备定时列表
 *
 *  @param udpSocket
 *  @param aSwitch
 *  @param mode
 */
- (void)sendMsg17Or19:(int)type {
  if (type == 1) {
    kSharedAppliction.networkStatus = ReachableViaWWAN;
  }
  SDZGSwitch *aSwitch = [self getSocket];
  [self.request sendMsg17Or19:aSwitch socketId:1 sendMode:ActiveMode];
}
/**
 *  手机设置设备定时列表
 *
 *  @param udpSocket
 *  @param aSwitch
 *  @param timeList  定时列表集合
 *  @param mode
 */
- (void)sendMsg1DOr1F:(int)type {
  if (type == 1) {
    kSharedAppliction.networkStatus = ReachableViaWWAN;
  }
  SDZGTimerTask *timerTask = [[SDZGTimerTask alloc] init];
  timerTask.week = 1;
  timerTask.actionTime = 45678;
  timerTask.isEffective = YES;
  timerTask.timerActionType = TimerActionTypeOn;

  NSArray *timeList = @[ timerTask ];
  SDZGSwitch *aSwitch = [self getSocket];
  [self.request sendMsg1DOr1F:aSwitch
                     socketId:1
                     timeList:timeList
                     sendMode:ActiveMode];
}
/**
 *  手机获取设备控制权限
 *
 *  @param udpSocket
 *  @param aSwitch
 *  @param mode
 */
//- (void)sendMsg25Or27:(GCDAsyncUdpSocket *)udpSocket
//              aSwitch:(SDZGSwitch *)aSwitch
//             sendMode:(SENDMODE)mode;

- (void)sendMsg33Or35:(int)type {
  if (type == 1) {
    kSharedAppliction.networkStatus = ReachableViaWWAN;
  }
  SDZGSwitch *aSwitch = [self getSocket];
  [self.request sendMsg33Or35:aSwitch sendMode:ActiveMode];
}

/**
 *  设备定位，即使设备灯闪烁
 *
 *  @param udpSocket
 *  @param aSwitch
 *  @param on        定位标识，目前只有1，表示定位
 *  @param mode
 */
- (void)sendMsg39Or3B:(int)type {
  if (type == 1) {
    kSharedAppliction.networkStatus = ReachableViaWWAN;
  }
  SDZGSwitch *aSwitch = [self getSocket];
  [self.request sendMsg39Or3B:aSwitch on:YES sendMode:ActiveMode];
}
/**
 *  设置设备名称
 *
 *  @param udpSocket
 *  @param aSwitch
 *  @param name      设备名称
 *  @param mode
 */
- (void)sendMsg3FOr41:(int)type {
  if (type == 1) {
    kSharedAppliction.networkStatus = ReachableViaWWAN;
  }
  SDZGSwitch *aSwitch = [self getSocket];
  [self.request sendMsg3FOr41:aSwitch
                         type:0
                         name:@"测试12"
                     sendMode:ActiveMode];
}
/**
 *  设备加锁
 *
 *  @param udpSocket
 *  @param aSwitch
 *  @param isLock    设备当前的锁定状态，即发送指令前的状态
 *  @param mode
 */
- (void)sendMsg47Or49:(int)type {
  if (type == 1) {
    kSharedAppliction.networkStatus = ReachableViaWWAN;
  }
  SDZGSwitch *aSwitch = [self getSocket];
  [self.request sendMsg47Or49:aSwitch sendMode:ActiveMode];
}
/**
 *  设置设备延时任务
 *
 *  @param udpSocket
 *  @param aSwitch
 *  @param delayTime 延时时间，单位分钟
 *  @param on        0x1表示开，0x0表示关
 *  @param mode
 */
- (void)sendMsg4DOr4F:(int)type {
  if (type == 1) {
    kSharedAppliction.networkStatus = ReachableViaWWAN;
  }
  SDZGSwitch *aSwitch = [self getSocket];
  [self.request sendMsg4DOr4F:aSwitch
                     socketId:1
                    delayTime:150
                     switchOn:YES
                     sendMode:ActiveMode];
}
/**
 *  查询设备延时任务
 *
 *  @param udpSocket
 *  @param aSwitch
 *  @param mode
 */
- (void)sendMsg53Or55:(int)type {
  if (type == 1) {
    kSharedAppliction.networkStatus = ReachableViaWWAN;
  }
  SDZGSwitch *aSwitch = [self getSocket];
  [self.request sendMsg53Or55:aSwitch socketId:1 sendMode:ActiveMode];
}

/**
 *  查询设备名字
 *
 *  @param udpSocket
 *  @param aSwitch
 *  @param mode
 */
- (void)sendMsg5DOr5F:(int)type {
  if (type == 1) {
    kSharedAppliction.networkStatus = ReachableViaWWAN;
  }
  SDZGSwitch *aSwitch = [self getSocket];
  [self.request sendMsg5DOr5F:aSwitch sendMode:ActiveMode];
}

/**
 *  查询历史电量
 *
 *  @param
 *  @param beginTime 开始时间 （秒）
 *  @param endTime 结束时间 （秒）
 *  @param interval 间隔时间，返回查询数量是(Endtimet-begintimet)/ interval
 */
- (void)sendMsg63 {
  NSLog(@"...is %f", [[NSDate date] timeIntervalSince1970]);
  SDZGSwitch *aSwitch = [self getSocket];
  [self.request sendMsg63:aSwitch
                beginTime:1406822400
                  endTime:1409500799
                 interval:3600 * 24
                 sendMode:ActiveMode];
}

/**
 *  查询终端城市
 *
 *  @param mac 设备/手机MAC地址
 *  @param type 0 为获取设备当地的城市 1为获取换手机当地的城市
 *  @param mode
 */
- (void)sendMsg65 {
  SDZGSwitch *aSwitch = [self getSocket];
  [self.request sendMsg65:aSwitch.mac type:0 sendMode:ActiveMode];
}

/**
 *  查询当地天气
 *
 *  @param mac
 *  @param type 设备/手机MAC地址
 *  @param mode 0 为获取设备当地的天气 1为获取换手机当地的天气
 *3为获取指定城市的天气
 */
- (void)sendMsg67:(NSString *)mac
             type:(int)type
         cityName:(NSString *)cityName
         sendMode:(SENDMODE)mode {
}

/**
 *  设置密码
 *
 *  @param udpSocket
 *  @param aSwitch
 *  @param mode
 */
- (void)sendMsg69:(NSString *)oldPassword
      newPassword:(NSString *)newPassword
         sendMode:(SENDMODE)mode {
}

#pragma mark - UdpRequestDelegate
- (void)responseMsg:(CC3xMessage *)message address:(NSData *)address {
  switch (message.msgId) {
    case 0xc:
    case 0xe:
      if (message.version == 2) {
        debugLog(@"deviceName is %@", message.deviceName);
      }

      break;

    case 0x18:
      debugLog(@"timertask is %@", message.timerTaskList);
    default:
      break;
  }
}

- (SDZGSwitch *)getSocket {
  NSData *data = [NSData
      dataWithContentsOfFile:[PATH_OF_TEMP
                                 stringByAppendingPathComponent:@"switch95"]];
  CC3xMessage *message = [CC3xMessageUtil parseMessage:data];
  SDZGSwitch *aSwitch = [[SDZGSwitch alloc] init];
  aSwitch.mac = message.mac;
  aSwitch.ip = message.ip;
  aSwitch.port = message.port;
  aSwitch.name = message.deviceName;
  aSwitch.version = message.version;
  aSwitch.password = nil;
  if (message.msgId == 0xc && aSwitch.switchStatus != SWITCH_NEW) {
    if (aSwitch.lockStatus == LockStatusOn) {
      aSwitch.switchStatus = SWITCH_LOCAL_LOCK;
    } else {
      aSwitch.switchStatus = SWITCH_LOCAL;
    }
  } else if (message.msgId == 0xe && aSwitch.switchStatus != SWITCH_NEW &&
             (aSwitch.switchStatus == SWITCH_UNKNOWN ||
              aSwitch.switchStatus == SWITCH_OFFLINE)) {
    if (aSwitch.lockStatus == LockStatusOn) {
      aSwitch.switchStatus = SWITCH_REMOTE_LOCK;
    } else {
      aSwitch.switchStatus = SWITCH_REMOTE;
    }
  } else if (aSwitch.switchStatus == SWITCH_UNKNOWN) {
    aSwitch.switchStatus = SWITCH_OFFLINE;
  }
  if (aSwitch.sockets) {
  } else {
    aSwitch.sockets = [@[] mutableCopy];
  }
  aSwitch.lockStatus = LockStatusOn;

  SDZGSocket *socket1 = [[SDZGSocket alloc] init];
  socket1.socketId = 1;
  socket1.socketStatus = SocketStatusOn;
  //      message.onStatus << 0 & 1;
  [aSwitch.sockets addObject:socket1];

  SDZGSocket *socket2 = [[SDZGSocket alloc] init];
  socket2.socketId = 2;
  socket2.socketStatus = message.onStatus << 1 & 1;
  [aSwitch.sockets addObject:socket2];
  return aSwitch;
}
@end
