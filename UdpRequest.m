//
//  UdpRequest.m
//  SmartSwitch
//
//  Created by 文正光 on 14-8-17.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "UdpRequest.h"

@interface UdpRequest ()<GCDAsyncUdpSocketDelegate>
@property (nonatomic, strong) GCDAsyncUdpSocket *udpSocket;
@property (atomic, strong) sucessResponse sucessResponse;
@property (atomic, strong) failureResponse failureResponse;
@property (atomic, strong) NSData *msg;
@property (atomic, strong) NSString *host;
@property (atomic, strong) NSData *address;
@property (atomic, assign) uint16_t port;
@property (atomic, assign) long tag;
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
  return nil;
}

- (void)sendMsg05:(GCDAsyncUdpSocket *)udpSocket
          address:(NSData *)address
         sendMode:(SENDMODE)mode
          success:(sucessResponse)sucess
           failre:(failureResponse)failure {
}

#pragma mark - 检查指定时间内是否有数据返回
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
              self.msg5SendCount < kTryCount &&
              [[UdpSocketUtil shareInstance].delegate
                  respondsToSelector:@selector(noResponseMsgId6)]) {
            //            NSLog(@"tag %ld 重新发送%d次", tag,
            //                  [MessageUtil shareInstance].msg5SendCount + 1);
            //            [[UdpSocketUtil shareInstance].delegate
            //            noResponseMsgId6];
            self.failureResponse(self.msg5SendCount);
          }
        }
        break;
    }
  }
}

#pragma mark - UDP Delegate
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
  }
  [[SendResponseHandler shareInstance]
      checkResponseDataAfterSettingIntervalWithTag:tag];
}

/**
 * Called if an error occurs while trying to send a datagram.
 * This could be due to a timeout, or something more serious such as the data
 *being too large to fit in a sigle packet.
 **/
- (void)udpSocket:(GCDAsyncUdpSocket *)sock
    didNotSendDataWithTag:(long)tag
               dueToError:(NSError *)error {
  //  NSLog(@"didNotSendDataWithTag :%ld", tag);
  switch (tag) {
    case P2D_SERVER_INFO_05:
      //      if ([self.delegate respondsToSelector:@selector(noSendMsgId5)]) {
      //        [self.delegate noSendMsgId5];
      //      }
      break;
  }
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
    switch (msg.msgId) {
      case 0x6:
        self.responseData6 = data;
        //        if ([self.delegate
        //        respondsToSelector:@selector(responseMsgId6:)]) {
        //          [self.delegate responseMsgId6:msg];
        //        }
        self.sucessResponse(msg);
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
