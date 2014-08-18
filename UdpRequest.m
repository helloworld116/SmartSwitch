//
//  UdpRequest.m
//  SmartSwitch
//
//  Created by 文正光 on 14-8-17.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "UdpRequest.h"

@interface UdpRequest ()<GCDAsyncUdpSocketDelegate>
#pragma mark -
#pragma mark 发送请求计数变量
@property(atomic, assign) int msg5SendCount;
@property(atomic, assign) int msg9SendCount;
@property(atomic, assign) int msgBSendCount;
@property(atomic, strong)
    NSMutableDictionary *msgDSendCountDict;  //{"mac":"cout"}
@property(atomic, assign) int msg11SendCount;
@property(atomic, assign) int msg13SendCount;
@property(atomic, assign) int msg17SendCount;
@property(atomic, assign) int msg19SendCount;
@property(atomic, assign) int msg1DSendCount;
@property(atomic, assign) int msg1FSendCount;
@property(atomic, assign) int msg25SendCount;
@property(atomic, assign) int msg27SendCount;
@property(atomic, assign) int msg33SendCount;
@property(atomic, assign) int msg35SendCount;
@property(atomic, assign) int msg39SendCount;
@property(atomic, assign) int msg3BSendCount;
@property(atomic, assign) int msg3FSendCount;
@property(atomic, assign) int msg41SendCount;
@property(atomic, assign) int msg47SendCount;
@property(atomic, assign) int msg49SendCount;
@property(atomic, assign) int msg4DSendCount;
@property(atomic, assign) int msg4FSendCount;
@property(atomic, assign) int msg53SendCount;
@property(atomic, assign) int msg55SendCount;
@property(atomic, assign) int msg59SendCount;
@property(atomic, assign) int msg5DSendCount;
@property(atomic, assign) int msg5FSendCount;
@property(atomic, assign) int msg63SendCount;
@property(atomic, assign) int msg65SendCount;
@property(atomic, assign) int msg67SendCount;
@property(atomic, assign) int msg69SendCount;

#pragma mark -
#pragma mark 请求响应数据
@property(atomic, strong) NSData *responseData6;
@property(atomic, strong) NSData *responseDataA;
@property(atomic, strong) NSData *responseDataC;
@property(atomic, strong) NSMutableDictionary *responseDictE;  //{@"mac":"data"}
@property(atomic, strong) NSData *responseData12;
@property(atomic, strong) NSData *responseData14;
@property(atomic, strong) NSData *responseData18;
@property(atomic, strong) NSData *responseData1A;
@property(atomic, strong) NSData *responseData1E;
@property(atomic, strong) NSData *responseData20;
@property(atomic, strong) NSData *responseData26;
@property(atomic, strong) NSData *responseData28;
@property(atomic, strong) NSData *responseData34;
@property(atomic, strong) NSData *responseData36;
@property(atomic, strong) NSData *responseData3A;
@property(atomic, strong) NSData *responseData3C;
@property(atomic, strong) NSData *responseData40;
@property(atomic, strong) NSData *responseData42;
@property(atomic, strong) NSData *responseData48;
@property(atomic, strong) NSData *responseData4A;
@property(atomic, strong) NSData *responseData4E;
@property(atomic, strong) NSData *responseData50;
@property(atomic, strong) NSData *responseData54;
@property(atomic, strong) NSData *responseData56;
@property(atomic, strong) NSData *responseData5A;
@property(atomic, strong) NSData *responseData5E;
@property(atomic, strong) NSData *responseData60;
@property(atomic, strong) NSData *responseData64;
@property(atomic, strong) NSData *responseData66;
@property(atomic, strong) NSData *responseData68;
@property(atomic, strong) NSData *responseData6A;

#pragma mark -
@property(nonatomic, strong) GCDAsyncUdpSocket *udpSocket;
@property(atomic, strong) successBlock successBlock;
// block的参数列表为空的话，相当于可变参数（不是void）
@property(atomic, strong) void (^noResposneBlock)();
@property(atomic, strong) noRequestBlock noRequestBlock;
@property(atomic, strong) NSData *msg;
@property(atomic, strong) NSString *host;
@property(atomic, strong) NSData *address;
@property(atomic, assign) uint16_t port;
@property(atomic, assign) long tag;
@end

@implementation UdpRequest
- (id)init {
  self = [super init];
  if (self) {
    self.udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self
                                                   delegateQueue:GLOBAL_QUEUE];
    [CC3xUtility setupUdpSocket:self.udpSocket port:APP_PORT];
  }
  return self;
}

+ (instancetype)sharedInstance {
  static UdpRequest *request;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{ request = [[self alloc] init]; });
  return request;
}

#pragma mark - UDP发送请求
- (void)sendDataToHost {
  if (self.udpSocket.isClosed) {
    [CC3xUtility setupUdpSocket:self.udpSocket port:APP_PORT];
  }
  [self.udpSocket sendData:self.msg
                    toHost:self.host
                      port:self.port
               withTimeout:kUDPTimeOut
                       tag:self.tag];
}

- (void)sendDataToAddress {
  if (self.udpSocket.isClosed) {
    [CC3xUtility setupUdpSocket:self.udpSocket port:APP_PORT];
  }
  [self.udpSocket sendData:self.msg
                 toAddress:self.address
               withTimeout:kUDPTimeOut
                       tag:self.tag];
}

- (void)sendMsg0BMode:(SENDMODE)mode
         successBlock:(successBlock)successBlock
      noResponseBlock:(noResponseBlock)noResponseBlock
       noRequestBlock:(noRequestBlock)noRequestBlock {
  dispatch_async(GLOBAL_QUEUE, ^{
      if (kSharedAppliction.networkStatus == ReachableViaWiFi) {
        if (mode == ActiveMode) {
          self.msgBSendCount = 0;
        } else if (mode == PassiveMode) {
          self.msgBSendCount++;
        }
        self.msg = [CC3xMessageUtil getP2dMsg0B];
        self.host = BROADCAST_ADDRESS;
        self.port = DEVICE_PORT;
        self.tag = P2D_STATE_INQUIRY_0B;
        self.successBlock = successBlock;
        self.noResposneBlock = noResponseBlock;
        self.noRequestBlock = noRequestBlock;
        [self sendDataToHost];
      } else {
        //不在内网的情况下的处理
      }
  });
}

- (void)sendMsg11WithSwitch:(CC3xSwitch *)aSwitch
                   socketId:(int)socketId
                   sendMode:(SENDMODE)mode
               successBlock:(successBlock)successBlock
            noResponseBlock:(noResponseBlock)noResponseBlock
             noRequestBlock:(noRequestBlock)noRequestBlock {
  if (mode == ActiveMode) {
    self.msg11SendCount = 0;
  } else if (mode == PassiveMode) {
    self.msg11SendCount++;
  }
  self.msg = [CC3xMessageUtil getP2dMsg11:!aSwitch.isOn socketId:socketId];
  self.host = aSwitch.ip;
  self.port = aSwitch.port;
  self.tag = P2D_CONTROL_REQ_11;
  self.successBlock = successBlock;
  self.noResposneBlock = noResponseBlock;
  self.noRequestBlock = noRequestBlock;
  [self sendDataToHost];
}

- (void)sendMsg13WithSwitch:(CC3xSwitch *)aSwitch
                   socketId:(int)socketId
                   sendMode:(SENDMODE)mode
               successBlock:(successBlock)successBlock
            noResponseBlock:(noResponseBlock)noResponseBlock
             noRequestBlock:(noRequestBlock)noRequestBlock {
  if (mode == ActiveMode) {
    self.msg13SendCount = 0;
  } else if (mode == PassiveMode) {
    self.msg13SendCount++;
  }
  self.msg = [CC3xMessageUtil getP2sMsg13:aSwitch.macAddress
                                  aSwitch:!aSwitch.isOn
                                 socketId:socketId];
  self.host = SERVER_IP;
  self.port = SERVER_PORT;
  self.tag = P2S_CONTROL_REQ_13;
  self.successBlock = successBlock;
  self.noResposneBlock = noResponseBlock;
  self.noRequestBlock = noRequestBlock;
  [self sendDataToHost];
}

- (void)sendMsg17WithSwitch:(CC3xSwitch *)aSwitch
                   socketId:(int)socketId
                   sendMode:(SENDMODE)mode
               successBlock:(successBlock)successBlock
            noResponseBlock:(noResponseBlock)noResponseBlock
             noRequestBlock:(noRequestBlock)noRequestBlock {
  if (mode == ActiveMode) {
    self.msg17SendCount = 0;
  } else if (mode == PassiveMode) {
    self.msg17SendCount++;
  }
  self.msg = [CC3xMessageUtil getP2dMsg17:socketId];
  self.host = aSwitch.ip;
  self.port = aSwitch.port;
  self.tag = P2D_GET_TIMER_REQ_17;
  self.successBlock = successBlock;
  self.noResposneBlock = noResponseBlock;
  self.noRequestBlock = noRequestBlock;
  [self sendDataToHost];
}

- (void)sendMsg19WithSwitch:(CC3xSwitch *)aSwitch
                   socketId:(int)socketId
                   sendMode:(SENDMODE)mode
               successBlock:(successBlock)successBlock
            noResponseBlock:(noResponseBlock)noResponseBlock
             noRequestBlock:(noRequestBlock)noRequestBlock {
  if (mode == ActiveMode) {
    self.msg19SendCount = 0;
  } else if (mode == PassiveMode) {
    self.msg19SendCount++;
  }
  self.msg = [CC3xMessageUtil getP2SMsg19:aSwitch.macAddress socketId:socketId];
  self.host = SERVER_IP;
  self.port = SERVER_PORT;
  self.tag = P2S_GET_TIMER_REQ_19;
  self.successBlock = successBlock;
  self.noResposneBlock = noResponseBlock;
  self.noRequestBlock = noRequestBlock;
  [self sendDataToHost];
}

- (void)sendMsg1DWithSwitch:(CC3xSwitch *)aSwitch
                   socketId:(int)socketId
                   timeList:(NSArray *)timeList
                   sendMode:(SENDMODE)mode
               successBlock:(successBlock)successBlock
            noResponseBlock:(noResponseBlock)noResponseBlock
             noRequestBlock:(noRequestBlock)noRequestBlock {
  if (mode == ActiveMode) {
    self.msg1DSendCount = 0;
  } else if (mode == PassiveMode) {
    self.msg1DSendCount++;
  }
  //获取公历日期,相对的当前时间
  NSCalendar *gregorian =
      [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
  NSDateComponents *comps =
      [gregorian components:NSWeekdayCalendarUnit | NSHourCalendarUnit |
                            NSMinuteCalendarUnit
                   fromDate:[NSDate date]];
  int weekday = ([comps weekday] + 5) % 7;
  int hour = (int)[comps hour];
  int min = (int)[comps minute];
  //获取当前时间离本周一0点开始的秒数
  NSInteger currentTime = weekday * 24 * 3600 + hour * 3600 + min * 60;
  self.msg = [CC3xMessageUtil getP2dMsg1D:currentTime
                                 socketId:socketId
                                timerList:timeList];
  self.host = aSwitch.ip;
  self.port = aSwitch.port;
  self.tag = P2D_SET_TIMER_REQ_1D;
  self.successBlock = successBlock;
  self.noResposneBlock = noResponseBlock;
  self.noRequestBlock = noRequestBlock;
  [self sendDataToHost];
}

- (void)sendMsg1FWithSwitch:(CC3xSwitch *)aSwitch
                   socketId:(int)socketId
                   timeList:(NSArray *)timeList
                   sendMode:(SENDMODE)mode
               successBlock:(successBlock)successBlock
            noResponseBlock:(noResponseBlock)noResponseBlock
             noRequestBlock:(noRequestBlock)noRequestBlock {
  if (mode == ActiveMode) {
    self.msg1FSendCount = 0;
  } else if (mode == PassiveMode) {
    self.msg1FSendCount++;
  }
  //获取公历日期,相对的当前时间
  NSCalendar *gregorian =
      [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
  NSDateComponents *comps =
      [gregorian components:NSWeekdayCalendarUnit | NSHourCalendarUnit |
                            NSMinuteCalendarUnit
                   fromDate:[NSDate date]];
  int weekday = ([comps weekday] + 5) % 7;
  int hour = (int)[comps hour];
  int min = (int)[comps minute];
  //获取当前时间离本周一0点开始的秒数
  NSInteger currentTime = weekday * 24 * 3600 + hour * 3600 + min * 60;
  self.msg = [CC3xMessageUtil getP2SMsg1F:currentTime
                                 socketId:socketId
                                timerList:timeList
                                      mac:aSwitch.macAddress];
  self.host = SERVER_IP;
  self.port = SERVER_PORT;
  self.tag = P2S_SET_TIMER_REQ_1F;
  self.successBlock = successBlock;
  self.noResposneBlock = noResponseBlock;
  self.noRequestBlock = noRequestBlock;
  [self sendDataToHost];
}

//- (void)sendMsg25:(GCDAsyncUdpSocket *)udpSocket
//          aSwitch:(CC3xSwitch *)aSwitch
//         sendMode:(SENDMODE)mode {
//  if (mode == ActiveMode) {
//    self.msg25Or27SendCount = 0;
//  } else if (mode == PassiveMode) {
//    self.msg25Or27SendCount++;
//  }
//  self.udpSocket = udpSocket;
//  self.msg = [CC3xMessageUtil getP2dMsg25];
//  self.host = aSwitch.ip;
//  self.port = aSwitch.port;
//  self.tag = P2D_GET_PROPERTY_REQ_25;
//  [self sendDataToHost];
//}
//
//- (void)sendMsg27:(GCDAsyncUdpSocket *)udpSocket
//          aSwitch:(CC3xSwitch *)aSwitch
//         sendMode:(SENDMODE)mode {
//  if (mode == ActiveMode) {
//    self.msg25Or27SendCount = 0;
//  } else if (mode == PassiveMode) {
//    self.msg25Or27SendCount++;
//  }
//  self.udpSocket = udpSocket;
//  self.msg = [CC3xMessageUtil getP2SMsg27:aSwitch.macAddress];
//  self.host = SERVER_IP;
//  self.port = SERVER_PORT;
//  self.tag = P2S_GET_PROPERTY_REQ_27;
//  [self sendDataToHost];
//}

- (void)sendMsg33WithSendMode:(SENDMODE)mode
                 successBlock:(successBlock)successBlock
              noResponseBlock:(noResponseBlock)noResponseBlock
               noRequestBlock:(noRequestBlock)noRequestBlock {
  if (mode == ActiveMode) {
    self.msg33SendCount = 0;
  } else if (mode == PassiveMode) {
    self.msg33SendCount++;
  }
  self.msg = [CC3xMessageUtil getP2DMsg33];
  self.host = BROADCAST_ADDRESS;
  self.port = DEVICE_PORT;
  self.tag = P2D_GET_POWER_INFO_REQ_33;
  self.successBlock = successBlock;
  self.noResposneBlock = noResponseBlock;
  self.noRequestBlock = noRequestBlock;
  [self sendDataToHost];
}

- (void)sendMsg35WithSwitch:(CC3xSwitch *)aSwitch
                   sendMode:(SENDMODE)mode
               successBlock:(successBlock)successBlock
            noResponseBlock:(noResponseBlock)noResponseBlock
             noRequestBlock:(noRequestBlock)noRequestBlock {
  if (mode == ActiveMode) {
    self.msg35SendCount = 0;
  } else if (mode == PassiveMode) {
    self.msg35SendCount++;
  }
  self.msg = [CC3xMessageUtil getP2SMsg35:aSwitch.macAddress];
  self.host = SERVER_IP;
  self.port = SERVER_PORT;
  self.tag = P2S_GET_POWER_INFO_REQ_35;
  self.successBlock = successBlock;
  self.noResposneBlock = noResponseBlock;
  self.noRequestBlock = noRequestBlock;
  [self sendDataToHost];
}

- (void)sendMsg39WithSwitch:(CC3xSwitch *)aSwitch
                         on:(BOOL)on
                   sendMode:(SENDMODE)mode
               successBlock:(successBlock)successBlock
            noResponseBlock:(noResponseBlock)noResponseBlock
             noRequestBlock:(noRequestBlock)noRequestBlock {
  if (mode == ActiveMode) {
    self.msg39SendCount = 0;
  } else if (mode == PassiveMode) {
    self.msg39SendCount++;
  }
  self.msg = [CC3xMessageUtil getP2dMsg39:on];
  self.host = aSwitch.ip;
  self.port = aSwitch.port;
  self.tag = P2D_LOCATE_REQ_39;
  self.successBlock = successBlock;
  self.noResposneBlock = noResponseBlock;
  self.noRequestBlock = noRequestBlock;
  [self sendDataToHost];
}

- (void)sendMsg3BWithSwitch:(CC3xSwitch *)aSwitch
                         on:(BOOL)on
                   sendMode:(SENDMODE)mode
               successBlock:(successBlock)successBlock
            noResponseBlock:(noResponseBlock)noResponseBlock
             noRequestBlock:(noRequestBlock)noRequestBlock {
  if (mode == ActiveMode) {
    self.msg3BSendCount = 0;
  } else if (mode == PassiveMode) {
    self.msg3BSendCount++;
  }
  self.msg = [CC3xMessageUtil getP2SMsg3B:aSwitch.macAddress on:on];
  self.host = SERVER_IP;
  self.port = SERVER_PORT;
  self.tag = P2S_LOCATE_REQ_3B;
  self.successBlock = successBlock;
  self.noResposneBlock = noResponseBlock;
  self.noRequestBlock = noRequestBlock;
  [self sendDataToHost];
}

- (void)sendMsg3FWithSwitch:(CC3xSwitch *)aSwitch
                       type:(int)type
                       name:(NSString *)name
                   sendMode:(SENDMODE)mode
               successBlock:(successBlock)successBlock
            noResponseBlock:(noResponseBlock)noResponseBlock
             noRequestBlock:(noRequestBlock)noRequestBlock {
  if (mode == ActiveMode) {
    self.msg3FSendCount = 0;
  } else if (mode == PassiveMode) {
    self.msg3FSendCount++;
  }
  self.msg = [CC3xMessageUtil getP2dMsg3F:name type:type];
  self.host = aSwitch.ip;
  self.port = aSwitch.port;
  self.tag = P2D_SET_NAME_REQ_3F;
  self.successBlock = successBlock;
  self.noResposneBlock = noResponseBlock;
  self.noRequestBlock = noRequestBlock;
  [self sendDataToHost];
}

- (void)sendMsg41WithSwitch:(CC3xSwitch *)aSwitch
                       type:(int)type
                       name:(NSString *)name
                   sendMode:(SENDMODE)mode
               successBlock:(successBlock)successBlock
            noResponseBlock:(noResponseBlock)noResponseBlock
             noRequestBlock:(noRequestBlock)noRequestBlock {
  if (mode == ActiveMode) {
    self.msg41SendCount = 0;
  } else if (mode == PassiveMode) {
    self.msg41SendCount++;
  }
  self.msg =
      [CC3xMessageUtil getP2sMsg41:aSwitch.macAddress name:name type:type];
  self.host = SERVER_IP;
  self.port = SERVER_PORT;
  self.tag = P2S_SET_NAME_REQ_41;
  self.successBlock = successBlock;
  self.noResposneBlock = noResponseBlock;
  self.noRequestBlock = noRequestBlock;
  [self sendDataToHost];
}

- (void)sendMsg47WithSwitch:(CC3xSwitch *)aSwitch
                   sendMode:(SENDMODE)mode
               successBlock:(successBlock)successBlock
            noResponseBlock:(noResponseBlock)noResponseBlock
             noRequestBlock:(noRequestBlock)noRequestBlock {
  if (mode == ActiveMode) {
    self.msg47SendCount = 0;
  } else if (mode == PassiveMode) {
    self.msg47SendCount++;
  }
  self.msg = [CC3xMessageUtil getP2dMsg47:!aSwitch.isLocked];
  self.host = aSwitch.ip;
  self.port = aSwitch.port;
  self.tag = P2D_DEV_LOCK_REQ_47;
  self.successBlock = successBlock;
  self.noResposneBlock = noResponseBlock;
  self.noRequestBlock = noRequestBlock;
  [self sendDataToHost];
}

- (void)sendMsg49WithSwitch:(CC3xSwitch *)aSwitch
                   sendMode:(SENDMODE)mode
               successBlock:(successBlock)successBlock
            noResponseBlock:(noResponseBlock)noResponseBlock
             noRequestBlock:(noRequestBlock)noRequestBlock {
  if (mode == ActiveMode) {
    self.msg49SendCount = 0;
  } else if (mode == PassiveMode) {
    self.msg49SendCount++;
  }
  self.msg =
      [CC3xMessageUtil getP2sMsg49:aSwitch.macAddress lock:!aSwitch.isLocked];
  self.host = SERVER_IP;
  self.port = SERVER_PORT;
  self.tag = P2S_DEV_LOCK_REQ_49;
  self.successBlock = successBlock;
  self.noResposneBlock = noResponseBlock;
  self.noRequestBlock = noRequestBlock;
  [self sendDataToHost];
}

- (void)sendMsg4DWithSwitch:(CC3xSwitch *)aSwitch
                   socketId:(int)socketId
                  delayTime:(NSInteger)delayTime
                   switchOn:(BOOL)on
                   sendMode:(SENDMODE)mode
               successBlock:(successBlock)successBlock
            noResponseBlock:(noResponseBlock)noResponseBlock
             noRequestBlock:(noRequestBlock)noRequestBlock {
  if (mode == ActiveMode) {
    self.msg4DSendCount = 0;
  } else if (mode == PassiveMode) {
    self.msg4DSendCount++;
  }
  self.msg = [CC3xMessageUtil getP2dMsg4D:delayTime on:on socketId:socketId];
  self.host = aSwitch.ip;
  self.port = aSwitch.port;
  self.tag = P2D_SET_DELAY_REQ_4D;
  self.successBlock = successBlock;
  self.noResposneBlock = noResponseBlock;
  self.noRequestBlock = noRequestBlock;
  [self sendDataToHost];
}

- (void)sendMsg4FWithSwitch:(CC3xSwitch *)aSwitch
                   socketId:(int)socketId
                  delayTime:(NSInteger)delayTime
                   switchOn:(BOOL)on
                   sendMode:(SENDMODE)mode
               successBlock:(successBlock)successBlock
            noResponseBlock:(noResponseBlock)noResponseBlock
             noRequestBlock:(noRequestBlock)noRequestBlock {
  if (mode == ActiveMode) {
    self.msg4FSendCount = 0;
  } else if (mode == PassiveMode) {
    self.msg4FSendCount++;
  }
  self.msg = [CC3xMessageUtil getP2SMsg4F:aSwitch.macAddress
                                    delay:delayTime
                                       on:on
                                 socketId:socketId];
  self.host = SERVER_IP;
  self.port = SERVER_PORT;
  self.tag = P2S_SET_DELAY_REQ_4F;
  self.successBlock = successBlock;
  self.noResposneBlock = noResponseBlock;
  self.noRequestBlock = noRequestBlock;
  [self sendDataToHost];
}

- (void)sendMsg53WithSwitch:(CC3xSwitch *)aSwitch
                   socketId:(int)socketId
                   sendMode:(SENDMODE)mode
               successBlock:(successBlock)successBlock
            noResponseBlock:(noResponseBlock)noResponseBlock
             noRequestBlock:(noRequestBlock)noRequestBlock {
  if (mode == ActiveMode) {
    self.msg53SendCount = 0;
  } else if (mode == PassiveMode) {
    self.msg53SendCount++;
  }
  self.msg = [CC3xMessageUtil getP2dMsg53:socketId];
  self.host = aSwitch.ip;
  self.port = aSwitch.port;
  self.tag = P2D_GET_DELAY_REQ_53;
  self.successBlock = successBlock;
  self.noResposneBlock = noResponseBlock;
  self.noRequestBlock = noRequestBlock;
  [self sendDataToHost];
}

- (void)sendMsg55WithSwitch:(CC3xSwitch *)aSwitch
                   socketId:(int)socketId
                   sendMode:(SENDMODE)mode
               successBlock:(successBlock)successBlock
            noResponseBlock:(noResponseBlock)noResponseBlock
             noRequestBlock:(noRequestBlock)noRequestBlock {
  if (mode == ActiveMode) {
    self.msg55SendCount = 0;
  } else if (mode == PassiveMode) {
    self.msg55SendCount++;
  }
  self.msg = [CC3xMessageUtil getP2SMsg55:aSwitch.macAddress socketId:socketId];
  self.host = SERVER_IP;
  self.port = SERVER_PORT;
  self.tag = P2S_GET_DELAY_REQ_55;
  self.successBlock = successBlock;
  self.noResposneBlock = noResponseBlock;
  self.noRequestBlock = noRequestBlock;
  [self sendDataToHost];
}

- (void)sendMsg59:(CC3xSwitch *)aSwitch
           sendMode:(SENDMODE)mode
       successBlock:(successBlock)successBlock
    noResponseBlock:(noResponseBlock)noResponseBlock
     noRequestBlock:(noRequestBlock)noRequestBlock {
  dispatch_async(GLOBAL_QUEUE, ^{
      if (mode == ActiveMode) {
        self.msg59SendCount = 0;
      } else if (mode == PassiveMode) {
        self.msg59SendCount++;
      }
      self.msg = [CC3xMessageUtil getP2SMsg59:aSwitch.macAddress];
      self.host = SERVER_IP;
      self.port = SERVER_PORT;
      self.tag = P2S_PHONE_INIT_REQ_59;
      self.successBlock = successBlock;
      self.noResposneBlock = noResponseBlock;
      self.noRequestBlock = noRequestBlock;
      [self sendDataToHost];
  });
}

- (void)sendMsg5DWithSendMode:(SENDMODE)mode
                 successBlock:(successBlock)successBlock
              noResponseBlock:(noResponseBlock)noResponseBlock
               noRequestBlock:(noRequestBlock)noRequestBlock {
  if (mode == ActiveMode) {
    self.msg5DSendCount = 0;
  } else if (mode == PassiveMode) {
    self.msg5DSendCount++;
  }
  self.msg = [CC3xMessageUtil getP2DMsg5D];
  self.host = BROADCAST_ADDRESS;
  self.port = DEVICE_PORT;
  self.tag = P2D_GET_NAME_REQ_5D;
  self.successBlock = successBlock;
  self.noResposneBlock = noResponseBlock;
  self.noRequestBlock = noRequestBlock;
  [self sendDataToHost];
}

- (void)sendMsg5FWithSwitch:(CC3xSwitch *)aSwitch
                   sendMode:(SENDMODE)mode
               successBlock:(successBlock)successBlock
            noResponseBlock:(noResponseBlock)noResponseBlock
             noRequestBlock:(noRequestBlock)noRequestBlock {
  if (mode == ActiveMode) {
    self.msg5FSendCount = 0;
  } else if (mode == PassiveMode) {
    self.msg5FSendCount++;
  }
  self.msg = [CC3xMessageUtil getP2SMsg5F:aSwitch.macAddress];
  self.host = SERVER_IP;
  self.port = SERVER_PORT;
  self.tag = P2S_GET_NAME_REQ_5F;
  self.successBlock = successBlock;
  self.noResposneBlock = noResponseBlock;
  self.noRequestBlock = noRequestBlock;
  [self sendDataToHost];
}

- (void)sendMsg63:(CC3xSwitch *)aSwitch
          beginTime:(int)beginTime
            endTime:(int)endTime
           interval:(int)interval
           sendMode:(SENDMODE)mode
       successBlock:(successBlock)successBlock
    noResponseBlock:(noResponseBlock)noResponseBlock
     noRequestBlock:(noRequestBlock)noRequestBlock {
  dispatch_async(GLOBAL_QUEUE, ^{
      if (mode == ActiveMode) {
        self.msg63SendCount = 0;
      } else if (mode == PassiveMode) {
        self.msg63SendCount++;
      }
      self.msg = [CC3xMessageUtil getP2SMsg63:aSwitch.macAddress
                                    beginTime:beginTime
                                      endTime:endTime
                                     interval:interval];
      self.host = SERVER_IP;
      self.port = SERVER_PORT;
      self.tag = P2S_GET_POWER_LOG_REQ_63;
      self.successBlock = successBlock;
      self.noResposneBlock = noResponseBlock;
      self.noRequestBlock = noRequestBlock;
      [self sendDataToHost];
  });
}

- (void)sendMsg65:(NSString *)mac
               type:(int)type
           sendMode:(SENDMODE)mode
       successBlock:(successBlock)successBlock
    noResponseBlock:(noResponseBlock)noResponseBlock
     noRequestBlock:(noRequestBlock)noRequestBlock {
  dispatch_async(GLOBAL_QUEUE, ^{
      if (mode == ActiveMode) {
        self.msg65SendCount = 0;
      } else if (mode == PassiveMode) {
        self.msg65SendCount++;
      }
      self.msg = [CC3xMessageUtil getP2SMsg65:mac type:type];
      self.host = SERVER_IP;
      self.port = SERVER_PORT;
      self.tag = P2S_GET_CITY_REQ_65;
      self.successBlock = successBlock;
      self.noResposneBlock = noResponseBlock;
      self.noRequestBlock = noRequestBlock;
      [self sendDataToHost];
  });
}

- (void)sendMsg67:(NSString *)mac
               type:(int)type
           cityName:(NSString *)cityName
           sendMode:(SENDMODE)mode
       successBlock:(successBlock)successBlock
    noResponseBlock:(noResponseBlock)noResponseBlock
     noRequestBlock:(noRequestBlock)noRequestBlock {
  dispatch_async(GLOBAL_QUEUE, ^{
      if (mode == ActiveMode) {
        self.msg67SendCount = 0;
      } else if (mode == PassiveMode) {
        self.msg67SendCount++;
      }
      self.msg = [CC3xMessageUtil getP2SMsg67:mac type:type cityName:cityName];
      self.host = SERVER_IP;
      self.port = SERVER_PORT;
      self.tag = P2S_GET_CITY_WEATHER_REQ_67;
      self.successBlock = successBlock;
      self.noResposneBlock = noResponseBlock;
      self.noRequestBlock = noRequestBlock;
      [self sendDataToHost];
  });
}

- (void)sendMsg69:(NSString *)oldPassword
        newPassword:(NSString *)newPassword
           sendMode:(SENDMODE)mode
       successBlock:(successBlock)successBlock
    noResponseBlock:(noResponseBlock)noResponseBlock
     noRequestBlock:(noRequestBlock)noRequestBlock {
  dispatch_async(GLOBAL_QUEUE, ^{
      if (mode == ActiveMode) {
        self.msg69SendCount = 0;
      } else if (mode == PassiveMode) {
        self.msg69SendCount++;
      }
      self.msg =
          [CC3xMessageUtil getP2DMsg69:oldPassword newPassword:newPassword];
      self.host = BROADCAST_ADDRESS;
      self.port = DEVICE_PORT;
      self.tag = P2D_SET_PASSWD_REQ_69;
      self.successBlock = successBlock;
      self.noResposneBlock = noResponseBlock;
      self.noRequestBlock = noRequestBlock;
      [self sendDataToHost];
  });
}

#pragma mark - 处理内外网请求
//- (void)sendMsg0BOr0D:(GCDAsyncUdpSocket *)udpSocket
//              aSwitch:(CC3xSwitch *)aSwitch
//             sendMode:(SENDMODE)mode {
//  dispatch_async(GLOBAL_QUEUE, ^{
//      if (kSharedAppliction.networkStatus == ReachableViaWiFi) {
//        //根据不同的网络环境，发送 本地/远程 消息
//        if (aSwitch.status == SWITCH_LOCAL ||
//            aSwitch.status == SWITCH_LOCAL_LOCK) {
//          [self sendMsg0B:udpSocket aSwitch:aSwitch sendMode:mode];
//        } else if (aSwitch.status == SWITCH_REMOTE ||
//                   aSwitch.status == SWITCH_REMOTE_LOCK) {
//          [self sendMsg0D:udpSocket aSwitch:aSwitch sendMode:mode];
//        }
//      } else if (kSharedAppliction.networkStatus == ReachableViaWWAN) {
//        [self sendMsg0D:udpSocket aSwitch:aSwitch sendMode:mode];
//      } else if (kSharedAppliction.networkStatus == NotReachable) {
//        [[NSNotificationCenter defaultCenter]
//            postNotificationName:kNotReachableNotification
//                          object:self
//                        userInfo:@{
//                          @"NetworkStatus" : @(NotReachable)
//                        }];
//      }
//  });
//}

- (void)sendMsg11Or13:(CC3xSwitch *)aSwitch
             socketId:(int)socketId
             sendMode:(SENDMODE)mode
         successBlock:(successBlock)successBlock
      noResponseBlock:(noResponseBlock)noResponseBlock
       noRequestBlock:(noRequestBlock)noRequestBlock {
  dispatch_async(GLOBAL_QUEUE, ^{
      if (kSharedAppliction.networkStatus == ReachableViaWiFi) {
        //根据不同的网络环境，发送 本地/远程 消息
        if (aSwitch.status == SWITCH_LOCAL ||
            aSwitch.status == SWITCH_LOCAL_LOCK) {
          [self sendMsg11WithSwitch:aSwitch
                           socketId:socketId
                           sendMode:mode
                       successBlock:successBlock
                    noResponseBlock:noResponseBlock
                     noRequestBlock:noRequestBlock];
        } else if (aSwitch.status == SWITCH_REMOTE ||
                   aSwitch.status == SWITCH_REMOTE_LOCK) {
          [self sendMsg13WithSwitch:aSwitch
                           socketId:socketId
                           sendMode:mode
                       successBlock:successBlock
                    noResponseBlock:noResponseBlock
                     noRequestBlock:noRequestBlock];
        }
      } else if (kSharedAppliction.networkStatus == ReachableViaWWAN) {
        [self sendMsg13WithSwitch:aSwitch
                         socketId:socketId
                         sendMode:mode
                     successBlock:successBlock
                  noResponseBlock:noResponseBlock
                   noRequestBlock:noRequestBlock];
      } else if (kSharedAppliction.networkStatus == NotReachable) {
        [[NSNotificationCenter defaultCenter]
            postNotificationName:kNotReachableNotification
                          object:self
                        userInfo:@{
                          @"NetworkStatus" : @(NotReachable)
                        }];
      }
  });
}

- (void)sendMsg17Or19:(CC3xSwitch *)aSwitch
             socketId:(int)socketId
             sendMode:(SENDMODE)mode
         successBlock:(successBlock)successBlock
      noResponseBlock:(noResponseBlock)noResponseBlock
       noRequestBlock:(noRequestBlock)noRequestBlock {
  dispatch_async(GLOBAL_QUEUE, ^{
      if (kSharedAppliction.networkStatus == ReachableViaWiFi) {
        //根据不同的网络环境，发送 本地/远程 消息
        if (aSwitch.status == SWITCH_LOCAL ||
            aSwitch.status == SWITCH_LOCAL_LOCK) {
          [self sendMsg17WithSwitch:aSwitch
                           socketId:socketId
                           sendMode:mode
                       successBlock:successBlock
                    noResponseBlock:noResponseBlock
                     noRequestBlock:noRequestBlock];
        } else if (aSwitch.status == SWITCH_REMOTE ||
                   aSwitch.status == SWITCH_REMOTE_LOCK) {
          [self sendMsg19WithSwitch:aSwitch
                           socketId:socketId
                           sendMode:mode
                       successBlock:successBlock
                    noResponseBlock:noResponseBlock
                     noRequestBlock:noRequestBlock];
        }
      } else if (kSharedAppliction.networkStatus == ReachableViaWWAN) {
        [self sendMsg19WithSwitch:aSwitch
                         socketId:socketId
                         sendMode:mode
                     successBlock:successBlock
                  noResponseBlock:noResponseBlock
                   noRequestBlock:noRequestBlock];
      } else if (kSharedAppliction.networkStatus == NotReachable) {
        [[NSNotificationCenter defaultCenter]
            postNotificationName:kNotReachableNotification
                          object:self
                        userInfo:@{
                          @"NetworkStatus" : @(NotReachable)
                        }];
      }
  });
}

- (void)sendMsg1DOr1F:(CC3xSwitch *)aSwitch
             socketId:(int)socketId
             timeList:(NSArray *)timeList
             sendMode:(SENDMODE)mode
         successBlock:(successBlock)successBlock
      noResponseBlock:(noResponseBlock)noResponseBlock
       noRequestBlock:(noRequestBlock)noRequestBlock {
  dispatch_async(GLOBAL_QUEUE, ^{
      if (kSharedAppliction.networkStatus == ReachableViaWiFi) {
        //根据不同的网络环境，发送 本地/远程 消息
        if (aSwitch.status == SWITCH_LOCAL ||
            aSwitch.status == SWITCH_LOCAL_LOCK) {
          [self sendMsg1DWithSwitch:aSwitch
                           socketId:socketId
                           timeList:timeList
                           sendMode:mode
                       successBlock:successBlock
                    noResponseBlock:noResponseBlock
                     noRequestBlock:noRequestBlock];
        } else if (aSwitch.status == SWITCH_REMOTE ||
                   aSwitch.status == SWITCH_REMOTE_LOCK) {
          [self sendMsg1FWithSwitch:aSwitch
                           socketId:socketId
                           timeList:timeList
                           sendMode:mode
                       successBlock:successBlock
                    noResponseBlock:noResponseBlock
                     noRequestBlock:noRequestBlock];
        }
      } else if (kSharedAppliction.networkStatus == ReachableViaWWAN) {
        [self sendMsg1FWithSwitch:aSwitch
                         socketId:socketId
                         timeList:timeList
                         sendMode:mode
                     successBlock:successBlock
                  noResponseBlock:noResponseBlock
                   noRequestBlock:noRequestBlock];
      } else if (kSharedAppliction.networkStatus == NotReachable) {
        [[NSNotificationCenter defaultCenter]
            postNotificationName:kNotReachableNotification
                          object:self
                        userInfo:@{
                          @"NetworkStatus" : @(NotReachable)
                        }];
      }
  });
}

//- (void)sendMsg25Or27:(GCDAsyncUdpSocket *)udpSocket
//              aSwitch:(CC3xSwitch *)aSwitch
//             sendMode:(SENDMODE)mode {
//  dispatch_async(GLOBAL_QUEUE, ^{
//      if (kSharedAppliction.networkStatus == ReachableViaWiFi) {
//        //根据不同的网络环境，发送 本地/远程 消息
//        if (aSwitch.status == SWITCH_LOCAL ||
//            aSwitch.status == SWITCH_LOCAL_LOCK) {
//          [self sendMsg25:udpSocket aSwitch:aSwitch sendMode:mode];
//        } else if (aSwitch.status == SWITCH_REMOTE ||
//                   aSwitch.status == SWITCH_REMOTE_LOCK) {
//          [self sendMsg27:udpSocket aSwitch:aSwitch sendMode:mode];
//        }
//      } else if (kSharedAppliction.networkStatus == ReachableViaWWAN) {
//        [self sendMsg27:udpSocket aSwitch:aSwitch sendMode:mode];
//      } else if (kSharedAppliction.networkStatus == NotReachable) {
//        [[NSNotificationCenter defaultCenter]
//            postNotificationName:kNotReachableNotification
//                          object:self
//                        userInfo:@{
//                          @"NetworkStatus" : @(NotReachable)
//                        }];
//      }
//  });
//}

- (void)sendMsg33Or35:(CC3xSwitch *)aSwitch
             sendMode:(SENDMODE)mode
         successBlock:(successBlock)successBlock
      noResponseBlock:(noResponseBlock)noResponseBlock
       noRequestBlock:(noRequestBlock)noRequestBlock {
  dispatch_async(GLOBAL_QUEUE, ^{
      if (kSharedAppliction.networkStatus == ReachableViaWiFi) {
        //根据不同的网络环境，发送 本地/远程 消息
        if (aSwitch.status == SWITCH_LOCAL ||
            aSwitch.status == SWITCH_LOCAL_LOCK) {
          [self sendMsg33WithSendMode:mode
                         successBlock:successBlock
                      noResponseBlock:noResponseBlock
                       noRequestBlock:noRequestBlock];
        } else if (aSwitch.status == SWITCH_REMOTE ||
                   aSwitch.status == SWITCH_REMOTE_LOCK) {
          [self sendMsg35WithSwitch:aSwitch
                           sendMode:mode
                       successBlock:successBlock
                    noResponseBlock:noResponseBlock
                     noRequestBlock:noRequestBlock];
        }
      } else if (kSharedAppliction.networkStatus == ReachableViaWWAN) {
        [self sendMsg35WithSwitch:aSwitch
                         sendMode:mode
                     successBlock:successBlock
                  noResponseBlock:noResponseBlock
                   noRequestBlock:noRequestBlock];
      } else if (kSharedAppliction.networkStatus == NotReachable) {
        [[NSNotificationCenter defaultCenter]
            postNotificationName:kNotReachableNotification
                          object:self
                        userInfo:@{
                          @"NetworkStatus" : @(NotReachable)
                        }];
      }
  });
}

- (void)sendMsg39Or3B:(CC3xSwitch *)aSwitch
                   on:(BOOL)on
             sendMode:(SENDMODE)mode
         successBlock:(successBlock)successBlock
      noResponseBlock:(noResponseBlock)noResponseBlock
       noRequestBlock:(noRequestBlock)noRequestBlock {
  dispatch_async(GLOBAL_QUEUE, ^{
      if (kSharedAppliction.networkStatus == ReachableViaWiFi) {
        //根据不同的网络环境，发送 本地/远程 消息
        if (aSwitch.status == SWITCH_LOCAL ||
            aSwitch.status == SWITCH_LOCAL_LOCK) {
          [self sendMsg39WithSwitch:aSwitch
                                 on:on
                           sendMode:mode
                       successBlock:successBlock
                    noResponseBlock:noResponseBlock
                     noRequestBlock:noRequestBlock];
        } else if (aSwitch.status == SWITCH_REMOTE ||
                   aSwitch.status == SWITCH_REMOTE_LOCK) {
          [self sendMsg3BWithSwitch:aSwitch
                                 on:on
                           sendMode:mode
                       successBlock:successBlock
                    noResponseBlock:noResponseBlock
                     noRequestBlock:noRequestBlock];
        }
      } else if (kSharedAppliction.networkStatus == ReachableViaWWAN) {
        [self sendMsg3BWithSwitch:aSwitch
                               on:on
                         sendMode:mode
                     successBlock:successBlock
                  noResponseBlock:noResponseBlock
                   noRequestBlock:noRequestBlock];
      } else if (kSharedAppliction.networkStatus == NotReachable) {
        [[NSNotificationCenter defaultCenter]
            postNotificationName:kNotReachableNotification
                          object:self
                        userInfo:@{
                          @"NetworkStatus" : @(NotReachable)
                        }];
      }
  });
}

- (void)sendMsg3FOr41:(CC3xSwitch *)aSwitch
                 type:(int)type
                 name:(NSString *)name
             sendMode:(SENDMODE)mode
         successBlock:(successBlock)successBlock
      noResponseBlock:(noResponseBlock)noResponseBlock
       noRequestBlock:(noRequestBlock)noRequestBlock {
  dispatch_async(GLOBAL_QUEUE, ^{
      if (kSharedAppliction.networkStatus == ReachableViaWiFi) {
        //根据不同的网络环境，发送 本地/远程 消息
        if (aSwitch.status == SWITCH_LOCAL ||
            aSwitch.status == SWITCH_LOCAL_LOCK) {
          [self sendMsg3FWithSwitch:aSwitch
                               type:type
                               name:name
                           sendMode:mode
                       successBlock:successBlock
                    noResponseBlock:noResponseBlock
                     noRequestBlock:noRequestBlock];
        } else if (aSwitch.status == SWITCH_REMOTE ||
                   aSwitch.status == SWITCH_REMOTE_LOCK) {
          [self sendMsg41WithSwitch:aSwitch
                               type:type
                               name:name
                           sendMode:mode
                       successBlock:successBlock
                    noResponseBlock:noResponseBlock
                     noRequestBlock:noRequestBlock];
        }
      } else if (kSharedAppliction.networkStatus == ReachableViaWWAN) {
        [self sendMsg41WithSwitch:aSwitch
                             type:type
                             name:name
                         sendMode:mode
                     successBlock:successBlock
                  noResponseBlock:noResponseBlock
                   noRequestBlock:noRequestBlock];
      } else if (kSharedAppliction.networkStatus == NotReachable) {
        [[NSNotificationCenter defaultCenter]
            postNotificationName:kNotReachableNotification
                          object:self
                        userInfo:@{
                          @"NetworkStatus" : @(NotReachable)
                        }];
      }
  });
}

- (void)sendMsg47Or49:(CC3xSwitch *)aSwitch
             sendMode:(SENDMODE)mode
         successBlock:(successBlock)successBlock
      noResponseBlock:(noResponseBlock)noResponseBlock
       noRequestBlock:(noRequestBlock)noRequestBlock {
  dispatch_async(GLOBAL_QUEUE, ^{
      if (kSharedAppliction.networkStatus == ReachableViaWiFi) {
        //根据不同的网络环境，发送 本地/远程 消息
        if (aSwitch.status == SWITCH_LOCAL ||
            aSwitch.status == SWITCH_LOCAL_LOCK) {
          [self sendMsg47WithSwitch:aSwitch
                           sendMode:mode
                       successBlock:successBlock
                    noResponseBlock:noResponseBlock
                     noRequestBlock:noRequestBlock];
        } else if (aSwitch.status == SWITCH_REMOTE ||
                   aSwitch.status == SWITCH_REMOTE_LOCK) {
          [self sendMsg49WithSwitch:aSwitch
                           sendMode:mode
                       successBlock:successBlock
                    noResponseBlock:noResponseBlock
                     noRequestBlock:noRequestBlock];
        }
      } else if (kSharedAppliction.networkStatus == ReachableViaWWAN) {
        [self sendMsg49WithSwitch:aSwitch
                         sendMode:mode
                     successBlock:successBlock
                  noResponseBlock:noResponseBlock
                   noRequestBlock:noRequestBlock];
      } else if (kSharedAppliction.networkStatus == NotReachable) {
        [[NSNotificationCenter defaultCenter]
            postNotificationName:kNotReachableNotification
                          object:self
                        userInfo:@{
                          @"NetworkStatus" : @(NotReachable)
                        }];
      }
  });
}

- (void)sendMsg4DOr4F:(CC3xSwitch *)aSwitch
             socketId:(int)socketId
            delayTime:(NSInteger)delayTime
             switchOn:(BOOL)on
             sendMode:(SENDMODE)mode
         successBlock:(successBlock)successBlock
      noResponseBlock:(noResponseBlock)noResponseBlock
       noRequestBlock:(noRequestBlock)noRequestBlock {
  dispatch_async(GLOBAL_QUEUE, ^{
      if (kSharedAppliction.networkStatus == ReachableViaWiFi) {
        //根据不同的网络环境，发送 本地/远程 消息
        if (aSwitch.status == SWITCH_LOCAL ||
            aSwitch.status == SWITCH_LOCAL_LOCK) {
          [self sendMsg4DWithSwitch:aSwitch
                           socketId:socketId
                          delayTime:delayTime
                           switchOn:on
                           sendMode:mode
                       successBlock:successBlock
                    noResponseBlock:noResponseBlock
                     noRequestBlock:noRequestBlock];
        } else if (aSwitch.status == SWITCH_REMOTE ||
                   aSwitch.status == SWITCH_REMOTE_LOCK) {
          [self sendMsg4FWithSwitch:aSwitch
                           socketId:socketId
                          delayTime:delayTime
                           switchOn:on
                           sendMode:mode
                       successBlock:successBlock
                    noResponseBlock:noResponseBlock
                     noRequestBlock:noRequestBlock];
        }
      } else if (kSharedAppliction.networkStatus == ReachableViaWWAN) {
        [self sendMsg4FWithSwitch:aSwitch
                         socketId:socketId
                        delayTime:delayTime
                         switchOn:on
                         sendMode:mode
                     successBlock:successBlock
                  noResponseBlock:noResponseBlock
                   noRequestBlock:noRequestBlock];
      } else if (kSharedAppliction.networkStatus == NotReachable) {
        [[NSNotificationCenter defaultCenter]
            postNotificationName:kNotReachableNotification
                          object:self
                        userInfo:@{
                          @"NetworkStatus" : @(NotReachable)
                        }];
      }
  });
}

- (void)sendMsg53Or55:(CC3xSwitch *)aSwitch
             socketId:(int)socketId
             sendMode:(SENDMODE)mode
         successBlock:(successBlock)successBlock
      noResponseBlock:(noResponseBlock)noResponseBlock
       noRequestBlock:(noRequestBlock)noRequestBlock {
  dispatch_async(GLOBAL_QUEUE, ^{
      if (kSharedAppliction.networkStatus == ReachableViaWiFi) {
        //根据不同的网络环境，发送 本地/远程 消息
        if (aSwitch.status == SWITCH_LOCAL ||
            aSwitch.status == SWITCH_LOCAL_LOCK) {
          [self sendMsg53WithSwitch:aSwitch
                           socketId:socketId
                           sendMode:mode
                       successBlock:successBlock
                    noResponseBlock:noResponseBlock
                     noRequestBlock:noRequestBlock];
        } else if (aSwitch.status == SWITCH_REMOTE ||
                   aSwitch.status == SWITCH_REMOTE_LOCK) {
          [self sendMsg55WithSwitch:aSwitch
                           socketId:socketId
                           sendMode:mode
                       successBlock:successBlock
                    noResponseBlock:noResponseBlock
                     noRequestBlock:noRequestBlock];
        }
      } else if (kSharedAppliction.networkStatus == ReachableViaWWAN) {
        [self sendMsg55WithSwitch:aSwitch
                         socketId:socketId
                         sendMode:mode
                     successBlock:successBlock
                  noResponseBlock:noResponseBlock
                   noRequestBlock:noRequestBlock];
      } else if (kSharedAppliction.networkStatus == NotReachable) {
        [[NSNotificationCenter defaultCenter]
            postNotificationName:kNotReachableNotification
                          object:self
                        userInfo:@{
                          @"NetworkStatus" : @(NotReachable)
                        }];
      }
  });
}

- (void)sendMsg5DOr5F:(CC3xSwitch *)aSwitch
             sendMode:(SENDMODE)mode
         successBlock:(successBlock)successBlock
      noResponseBlock:(noResponseBlock)noResponseBlock
       noRequestBlock:(noRequestBlock)noRequestBlock {
  dispatch_async(GLOBAL_QUEUE, ^{
      if (kSharedAppliction.networkStatus == ReachableViaWiFi) {
        //根据不同的网络环境，发送 本地/远程 消息
        if (aSwitch.status == SWITCH_LOCAL ||
            aSwitch.status == SWITCH_LOCAL_LOCK) {
          [self sendMsg5DWithSendMode:mode
                         successBlock:successBlock
                      noResponseBlock:noResponseBlock
                       noRequestBlock:noRequestBlock];
        } else if (aSwitch.status == SWITCH_REMOTE ||
                   aSwitch.status == SWITCH_REMOTE_LOCK) {
          [self sendMsg5FWithSwitch:aSwitch
                           sendMode:mode
                       successBlock:successBlock
                    noResponseBlock:noResponseBlock
                     noRequestBlock:noRequestBlock];
        }
      } else if (kSharedAppliction.networkStatus == ReachableViaWWAN) {
        [self sendMsg5FWithSwitch:aSwitch
                         sendMode:mode
                     successBlock:successBlock
                  noResponseBlock:noResponseBlock
                   noRequestBlock:noRequestBlock];
      } else if (kSharedAppliction.networkStatus == NotReachable) {
        [[NSNotificationCenter defaultCenter]
            postNotificationName:kNotReachableNotification
                          object:self
                        userInfo:@{
                          @"NetworkStatus" : @(NotReachable)
                        }];
      }
  });
}

#pragma mark - 线程检查器，检查指定时间内是否有数据返回
- (void)checkResponseDataAfterSettingIntervalWithTag:(long)tag {
  float delay;
  switch (tag) {
    case P2D_SERVER_INFO_05:
    case P2D_SCAN_DEV_09:
    case P2D_STATE_INQUIRY_0B:
    case P2D_CONTROL_REQ_11:
    case P2D_GET_TIMER_REQ_17:
    case P2D_SET_TIMER_REQ_1D:
    case P2D_GET_PROPERTY_REQ_25:
    case P2D_GET_POWER_INFO_REQ_33:
    case P2D_LOCATE_REQ_39:
    case P2D_SET_NAME_REQ_3F:
    case P2D_DEV_LOCK_REQ_47:
    case P2D_SET_DELAY_REQ_4D:
    case P2D_GET_DELAY_REQ_53:
    case P2D_GET_NAME_REQ_5D:
    case P2D_SET_PASSWD_REQ_69:
      delay = kCheckPrivateResponseInterval;
      break;
    case P2S_STATE_INQUIRY_0D:
    case P2S_CONTROL_REQ_13:
    case P2S_GET_TIMER_REQ_19:
    case P2S_SET_TIMER_REQ_1F:
    case P2S_GET_PROPERTY_REQ_27:
    case P2S_GET_POWER_INFO_REQ_35:
    case P2S_LOCATE_REQ_3B:
    case P2S_SET_NAME_REQ_41:
    case P2S_DEV_LOCK_REQ_49:
    case P2S_SET_DELAY_REQ_4F:
    case P2S_GET_DELAY_REQ_55:
    case P2S_PHONE_INIT_REQ_59:
    case P2S_GET_NAME_REQ_5F:
    case P2S_GET_POWER_LOG_REQ_63:
    case P2S_GET_CITY_REQ_65:
    case P2S_GET_CITY_WEATHER_REQ_67:
      delay = kCheckPublicResponseInterval;
      break;
    default:
      delay = kCheckPublicResponseInterval;
      break;
  }
  dispatch_time_t delayInNanoSeconds =
      dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC);
  dispatch_after(delayInNanoSeconds, GLOBAL_QUEUE,
                 ^{ [self checkWithTag:tag]; });
}

- (void)checkWithTag:(long)tag {
  if (kSharedAppliction.networkStatus != NotReachable) {
    switch (tag) {
      case P2D_SERVER_INFO_05:
        if (!self.responseData6) {
          if (kSharedAppliction.networkStatus == ReachableViaWiFi &&
              self.msg5SendCount < kTryCount) {
            NSLog(@"tag %ld 重新发送%d次", tag, self.msg5SendCount + 1);
            self.noResposneBlock(self.msg5SendCount + 1);
          }
        }
        break;
      case P2D_SCAN_DEV_09:
        if (!self.responseDataA) {
          if (self.msg9SendCount < kTryCount) {
            NSLog(@"tag %ld 重新发送%d次", tag, self.msg9SendCount + 1);
            self.noResposneBlock(self.msg5SendCount + 1);
          }
        }
        break;
      case P2D_STATE_INQUIRY_0B:
        if (!self.responseDataC) {
          if (kSharedAppliction.networkStatus == ReachableViaWiFi &&
              self.msgBSendCount < kTryCount) {
            NSLog(@"tag %ld 重新发送%d次", tag, self.msgBSendCount + 1);
            self.noResposneBlock(self.msgBSendCount + 1);
          }
        }
        break;
      case P2S_STATE_INQUIRY_0D:
        break;
      case P2D_CONTROL_REQ_11:
        if (!self.responseData12) {
          if (self.msg11SendCount < kTryCount) {
            NSLog(@"tag %ld 重新发送%d次", tag, self.msg11SendCount + 1);
            self.noResposneBlock(self.msg11SendCount + 1);
          }
        }
        break;
      case P2S_CONTROL_REQ_13:
        if (!self.responseData14) {
          if (self.msg13SendCount < kTryCount) {
            NSLog(@"tag %ld 重新发送%d次", tag, self.msg13SendCount + 1);
            self.noResposneBlock(self.msg13SendCount + 1);
          }
        }
        break;
      case P2D_GET_TIMER_REQ_17:
        if (!self.responseData18) {
          if (self.msg17SendCount < kTryCount) {
            NSLog(@"tag %ld 重新发送%d次", tag, self.msg17SendCount + 1);
            self.noResposneBlock(self.msg17SendCount + 1);
          }
        }
        break;
      case P2S_GET_TIMER_REQ_19:
        if (!self.responseData1A) {
          if (self.msg19SendCount < kTryCount) {
            NSLog(@"tag %ld 重新发送%d次", tag, self.msg19SendCount + 1);
            self.noResposneBlock(self.msg19SendCount + 1);
          }
        }
        break;
      case P2D_SET_TIMER_REQ_1D:
        if (!self.responseData1E) {
          if (self.msg1DSendCount < kTryCount) {
            NSLog(@"tag %ld 重新发送%d次", tag, self.msg1DSendCount + 1);
            self.noResposneBlock(self.msg1DSendCount + 1);
          }
        }
        break;
      case P2S_SET_TIMER_REQ_1F:
        if (!self.responseData20) {
          if (self.msg1FSendCount < kTryCount) {
            NSLog(@"tag %ld 重新发送%d次", tag, self.msg1FSendCount + 1);
            self.noResposneBlock(self.msg1FSendCount + 1);
          }
        }
        break;
      case P2D_GET_PROPERTY_REQ_25:
        if (!self.responseData26) {
          if (self.msg25SendCount < kTryCount) {
            NSLog(@"tag %ld 重新发送%d次", tag, self.msg25SendCount + 1);
            self.noResposneBlock(self.msg25SendCount + 1);
          }
        }
        break;
      case P2S_GET_PROPERTY_REQ_27:
        if (!self.responseData28) {
          if (self.msg27SendCount < kTryCount) {
            NSLog(@"tag %ld 重新发送%d次", tag, self.msg27SendCount + 1);
            self.noResposneBlock(self.msg27SendCount + 1);
          }
        }
        break;
      case P2D_GET_POWER_INFO_REQ_33:
        if (!self.responseData34) {
          if (self.msg33SendCount < kTryCount) {
            NSLog(@"tag %ld 重新发送%d次", tag, self.msg33SendCount + 1);
            self.noResposneBlock(self.msg33SendCount + 1);
          }
        }
        break;
      case P2S_GET_POWER_INFO_REQ_35:
        if (!self.responseData36) {
          if (self.msg35SendCount < kTryCount) {
            NSLog(@"tag %ld 重新发送%d次", tag, self.msg35SendCount + 1);
            self.noResposneBlock(self.msg35SendCount + 1);
          }
        }
        break;
      case P2D_LOCATE_REQ_39:
        if (!self.responseData3A) {
          if (self.msg39SendCount < kTryCount) {
            NSLog(@"tag %ld 重新发送%d次", tag, self.msg39SendCount + 1);
            self.noResposneBlock(self.msg39SendCount + 1);
          }
        }
        break;
      case P2S_LOCATE_REQ_3B:
        if (!self.responseData3C) {
          if (self.msg3BSendCount < kTryCount) {
            NSLog(@"tag %ld 重新发送%d次", tag, self.msg3BSendCount + 1);
            self.noResposneBlock(self.msg3BSendCount + 1);
          }
        }
        break;
      case P2D_SET_NAME_REQ_3F:
        if (!self.responseData40) {
          if (self.msg3FSendCount < kTryCount) {
            NSLog(@"tag %ld 重新发送%d次", tag, self.msg3FSendCount + 1);
            self.noResposneBlock(self.msg3FSendCount + 1);
          }
        }
        break;
      case P2S_SET_NAME_REQ_41:
        if (!self.responseData42) {
          if (self.msg41SendCount < kTryCount) {
            NSLog(@"tag %ld 重新发送%d次", tag, self.msg41SendCount + 1);
            self.noResposneBlock(self.msg41SendCount + 1);
          }
        }
        break;
      case P2D_DEV_LOCK_REQ_47:
        if (!self.responseData48) {
          if (self.msg47SendCount < kTryCount) {
            NSLog(@"tag %ld 重新发送%d次", tag, self.msg47SendCount + 1);
            self.noResposneBlock(self.msg47SendCount + 1);
          }
        }
        break;
      case P2S_DEV_LOCK_REQ_49:
        if (!self.responseData5A) {
          if (self.msg49SendCount < kTryCount) {
            NSLog(@"tag %ld 重新发送%d次", tag, self.msg49SendCount + 1);
            self.noResposneBlock(self.msg49SendCount + 1);
          }
        }
        break;
      case P2D_SET_DELAY_REQ_4D:
        if (!self.responseData4E) {
          if (self.msg4DSendCount < kTryCount) {
            NSLog(@"tag %ld 重新发送%d次", tag, self.msg4DSendCount + 1);
            self.noResposneBlock(self.msg4DSendCount + 1);
          }
        }
        break;
      case P2S_SET_DELAY_REQ_4F:
        if (!self.responseData50) {
          if (self.msg4FSendCount < kTryCount) {
            NSLog(@"tag %ld 重新发送%d次", tag, self.msg4FSendCount + 1);
            self.noResposneBlock(self.msg4FSendCount + 1);
          }
        }
        break;
      case P2D_GET_DELAY_REQ_53:
        if (!self.responseData54) {
          if (self.msg53SendCount < kTryCount) {
            NSLog(@"tag %ld 重新发送%d次", tag, self.msg53SendCount + 1);
            self.noResposneBlock(self.msg53SendCount + 1);
          }
        }
        break;
      case P2S_GET_DELAY_REQ_55:
        if (!self.responseData56) {
          if (self.msg55SendCount < kTryCount) {
            NSLog(@"tag %ld 重新发送%d次", tag, self.msg55SendCount + 1);
            self.noResposneBlock(self.msg55SendCount + 1);
          }
        }
        break;
      case P2S_PHONE_INIT_REQ_59:
        if (!self.responseData5A) {
          if (self.msg59SendCount < kTryCount) {
            NSLog(@"tag %ld 重新发送%d次", tag, self.msg59SendCount + 1);
            self.noResposneBlock(self.msg59SendCount + 1);
          }
        }
        break;
      case P2D_GET_NAME_REQ_5D:
        if (!self.responseData5E) {
          if (self.msg5DSendCount < kTryCount) {
            NSLog(@"tag %ld 重新发送%d次", tag, self.msg5DSendCount + 1);
            self.noResposneBlock(self.msg5DSendCount + 1);
          }
        }
        break;
      case P2S_GET_NAME_REQ_5F:
        if (!self.responseData60) {
          if (self.msg5FSendCount < kTryCount) {
            NSLog(@"tag %ld 重新发送%d次", tag, self.msg5FSendCount + 1);
            self.noResposneBlock(self.msg5FSendCount + 1);
          }
        }
        break;
      case P2S_GET_POWER_LOG_REQ_63:
        if (!self.responseData64) {
          if (self.msg63SendCount < kTryCount) {
            NSLog(@"tag %ld 重新发送%d次", tag, self.msg63SendCount + 1);
            self.noResposneBlock(self.msg63SendCount + 1);
          }
        }
        break;
      case P2S_GET_CITY_REQ_65:
        if (!self.responseData66) {
          if (self.msg65SendCount < kTryCount) {
            NSLog(@"tag %ld 重新发送%d次", tag, self.msg65SendCount + 1);
            self.noResposneBlock(self.msg65SendCount + 1);
          }
        }
        break;
      case P2S_GET_CITY_WEATHER_REQ_67:
        if (!self.responseData68) {
          if (self.msg67SendCount < kTryCount) {
            NSLog(@"tag %ld 重新发送%d次", tag, self.msg67SendCount + 1);
            self.noResposneBlock(self.msg67SendCount + 1);
          }
        }
        break;
      case P2D_SET_PASSWD_REQ_69:
        if (!self.responseData6A) {
          if (self.msg69SendCount < kTryCount) {
            NSLog(@"tag %ld 重新发送%d次", tag, self.msg69SendCount + 1);
            self.noResposneBlock(self.msg69SendCount + 1);
          }
        }
        break;

      default: {
        // TODO:设备在保存到数据库等本地文件时，设置一个tag标志，通过tag标识可以找到mac，然后设置数据为空
        NSString *mac;
        if ([self.responseDictE objectForKey:mac] == [NSNull null]) {
          int msgDSendCount =
              [[self.msgDSendCountDict objectForKey:mac] intValue];
          if (msgDSendCount < kTryCount) {
            NSLog(@"tag %ld 重新发送%d次", tag, msgDSendCount + 1);
            self.noResposneBlock(msgDSendCount + 1, mac);
          }
        }
        break;
      }
    }
  }
}

#pragma mark - GCDAsyncUdpSocket Delegate
/**
 * By design, UDP is a connectionless protocol, and connecting is not needed.
 * However, you may optionally choose to connect to a particular host for
 *reasons
 * outlined in the documentation for the various connect methods listed above.
 *
 * This method is called if one of the connect methods are invoked, and the
 *connection is successful.
 **/
- (void)udpSocket:(GCDAsyncUdpSocket *)sock
    didConnectToAddress:(NSData *)address {
  NSLog(@"didConnectToAddress");
}

/**
 * By design, UDP is a connectionless protocol, and connecting is not needed.
 * However, you may optionally choose to connect to a particular host for
 *reasons
 * outlined in the documentation for the various connect methods listed above.
 *
 * This method is called if one of the connect methods are invoked, and the
 *connection fails.
 * This may happen, for example, if a domain name is given for the host and the
 *domain name is unable to be resolved.
 **/
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotConnect:(NSError *)error {
  NSLog(@"didNotConnect");
}

/**
 * Called when the datagram with the given tag has been sent.
 **/
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag {
  //  NSLog(@"didSendDataWithTag :%ld", tag);
  //需要执行的操作：
  // 1、清空响应数据
  // 2、指定时间后检查数据是否为空，为空说明未响应，触发请求重发
  switch (tag) {
    case P2D_SERVER_INFO_05:
      self.responseData6 = nil;
      break;
    case P2D_SCAN_DEV_09:
      self.responseDataA = nil;
      break;
    case P2D_STATE_INQUIRY_0B:
      self.responseDataC = nil;
      break;
    case P2S_STATE_INQUIRY_0D:
      break;
    case P2D_CONTROL_REQ_11:
      self.responseData12 = nil;
      break;
    case P2S_CONTROL_REQ_13:
      self.responseData14 = nil;
      break;
    case P2D_GET_TIMER_REQ_17:
      self.responseData18 = nil;
      break;
    case P2S_GET_TIMER_REQ_19:
      self.responseData1A = nil;
      break;
    case P2D_SET_TIMER_REQ_1D:
      self.responseData1E = nil;
      break;
    case P2S_SET_TIMER_REQ_1F:
      self.responseData20 = nil;
      break;
    case P2D_GET_PROPERTY_REQ_25:
      self.responseData26 = nil;
      break;
    case P2S_GET_PROPERTY_REQ_27:
      self.responseData28 = nil;
      break;
    case P2D_GET_POWER_INFO_REQ_33:
      self.responseData34 = nil;
      break;
    case P2S_GET_POWER_INFO_REQ_35:
      self.responseData36 = nil;
      break;
    case P2D_LOCATE_REQ_39:
      self.responseData3A = nil;
      break;
    case P2S_LOCATE_REQ_3B:
      self.responseData3C = nil;
      break;
    case P2D_SET_NAME_REQ_3F:
      self.responseData40 = nil;
      break;
    case P2S_SET_NAME_REQ_41:
      self.responseData42 = nil;
      break;
    case P2D_DEV_LOCK_REQ_47:
      self.responseData48 = nil;
      break;
    case P2S_DEV_LOCK_REQ_49:
      self.responseData4A = nil;
      break;
    case P2D_SET_DELAY_REQ_4D:
      self.responseData4E = nil;
      break;
    case P2S_SET_DELAY_REQ_4F:
      self.responseData50 = nil;
      break;
    case P2D_GET_DELAY_REQ_53:
      self.responseData54 = nil;
      break;
    case P2S_GET_DELAY_REQ_55:
      self.responseData56 = nil;
      break;
    case P2S_PHONE_INIT_REQ_59:
      self.responseData5A = nil;
      break;
    case P2D_GET_NAME_REQ_5D:
      self.responseData5E = nil;
      break;
    case P2S_GET_NAME_REQ_5F:
      self.responseData60 = nil;
      break;
    case P2S_GET_POWER_LOG_REQ_63:
      self.responseData64 = nil;
      break;
    case P2S_GET_CITY_REQ_65:
      self.responseData66 = nil;
      break;
    case P2S_GET_CITY_WEATHER_REQ_67:
      self.responseData68 = nil;
      break;
    case P2D_SET_PASSWD_REQ_69:
      self.responseData6A = nil;
      break;
    default: {
      // TODO:设备在保存到数据库等本地文件时，设置一个tag标志，通过tag标识可以找到mac，然后设置数据为空
      NSString *mac;
      [self.responseDictE setObject:[NSNull null] forKey:mac];
      break;
    }
  }
  [self checkResponseDataAfterSettingIntervalWithTag:tag];
}

/**
 * Called if an error occurs while trying to send a datagram.
 * This could be due to a timeout, or something more serious such as the data
 *being too large to fit in a sigle packet.
 **/
- (void)udpSocket:(GCDAsyncUdpSocket *)sock
    didNotSendDataWithTag:(long)tag
               dueToError:(NSError *)error {
  self.noRequestBlock(tag);
}

/**
 * Called when the socket has received the requested datagram.
 **/
- (void)udpSocket:(GCDAsyncUdpSocket *)sock
       didReceiveData:(NSData *)data
          fromAddress:(NSData *)address
    withFilterContext:(id)filterContext {
  NSLog(@"receiveData is %@", [CC3xMessageUtil hexString:data]);
  if (data) {
    CC3xMessage *msg = (CC3xMessage *)filterContext;
    self.successBlock(msg);
    switch (msg.msgId) {
      case 0x2:
        break;
      case 0x6:
        self.responseData6 = data;
        break;
      case 0xa:
        self.responseDataA = data;
        break;
      case 0xc:
        self.responseDataC = data;
        break;
      case 0xe:
        [self.responseDictE setObject:data forKey:msg.mac];
        break;
      case 0x12:
        self.responseData12 = data;
        break;
      case 0x14:
        self.responseData14 = data;
        break;
      case 0x18:
        self.responseData18 = data;
        break;
      case 0x1a:
        self.responseData1A = data;
        break;
      case 0x1e:
        self.responseData1E = data;
        break;
      case 0x20:
        self.responseData20 = data;
        break;
      case 0x26:
        self.responseData26 = data;
        break;
      case 0x28:
        self.responseData28 = data;
        break;
      case 0x34:
        self.responseData34 = data;
        break;
      case 0x36:
        self.responseData36 = data;
        break;
      case 0x3A:
        self.responseData3A = data;
        break;
      case 0x3C:
        self.responseData3C = data;
        break;
      case 0x40:
        self.responseData40 = data;
        break;
      case 0x42:
        self.responseData42 = data;
        break;
      case 0x48:
        self.responseData48 = data;
        break;
      case 0x4a:
        self.responseData4A = data;
        break;
      case 0x4e:
        self.responseData4E = data;
        break;
      case 0x50:
        self.responseData50 = data;
        break;
      case 0x54:
        self.responseData54 = data;
        break;
      case 0x56:
        self.responseData56 = data;
        break;
      case 0x5a:
        self.responseData5A = data;
        break;
      case 0x5e:
        self.responseData5E = data;
        break;
      case 0x60:
        self.responseData60 = data;
        break;
      case 0x64:
        self.responseData64 = data;
        break;
      case 0x66:
        self.responseData66 = data;
        break;
      case 0x68:
        self.responseData68 = data;
        break;
      case 0x6a:
        self.responseData6A = data;
        break;
      default:
        break;
    }
  }
}
/**
 * Called when the socket is closed.
 **/
- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error {
  NSLog(@"UdpSocketUtil udpSocketDidClose");
}
@end