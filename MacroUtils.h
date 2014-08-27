//
//  MacroUtils.h
//  SmartSwitch
//
//  Created by 文正光 on 14-8-21.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#ifdef __OBJC__
#import <Reachability.h>
#import <GCDAsyncUdpSocket.h>
#import <MBProgressHUD.h>
#import <JASidePanelController.h>
#import <UIViewController+JASidePanel.h>
#import <KxMenu.h>
#import <EGORefreshTableHeaderView.h>
#import <HexColor.h>
#import <UIView+Toast.h>

#import "AppDelegate.h"
#import "CC3xUtility.h"
#import "CC3xMessage.h"
#import "SDZGSwitch.h"
#import "MessageUtil.h"
#import "NetUtil.h"
#import "UdpSocketUtil.h"
#import "SendResponseHandler.h"
#import "UdpRequest.h"
#import "XMLUtil.h"
#import "PassValueDelegate.h"
#import "ViewUtil.h"
#import "FirstTimeConfig.h"
#endif

#define kSharedAppliction                                                      \
  ((AppDelegate *)[UIApplication sharedApplication].delegate)

#define kCheckNetworkWebsite @"www.baidu.com"

//通知消息字段
#define kDelayNotification @"DelayNotification"
// UDP过期时间,单位秒
#define kUDPTimeOut -1
#define kCheckPrivateResponseInterval                                          \
  100 //发送UDP内网请求后，检查是否有响应数据的间隔，单位为秒
#define kCheckPublicResponseInterval                                           \
  100 //发送UDP外网请求后，检查是否有响应数据的间隔，单位为秒
#define kTryCount -1 //请求失败后自动尝试次数

//日志
#ifdef DEBUG
#define debugLog(...) NSLog(__VA_ARGS__)
#define debugMethod() NSLog(@"%s", __func__)
#else
#define debugLog(...)
#define debugMethod()
#endif

#define isEqualOrGreaterToiOS7                                                 \
  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define is4Inch ([[UIScreen mainScreen] bounds].size.height == 568)

#define PATH_OF_APP_HOME NSHomeDirectory()
#define PATH_OF_TEMP NSTemporaryDirectory()
#define PATH_OF_DOCUMENT                                                       \
  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,  \
                                       YES) objectAtIndex:0]
//延迟最大时间
#define kDelayMax 1440

//在家测试
#define isHome 1
