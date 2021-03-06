//
//  MacroUtils.h
//  SmartSwitch
//
//  Created by sdzg on 14-8-21.
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
#import <AFNetworking.h>
#import <ShareSDK/ShareSDK.h>

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
#import "DB.h"
#import "DESUtil.h"
#endif

#define kSharedAppliction \
  ((AppDelegate *)[UIApplication sharedApplication].delegate)

#define kCheckNetworkWebsite @"www.baidu.com"

//通知消息字段
#define kDelayNotification @"DelayNotification"
// UDP过期时间,单位秒
#define kUDPTimeOut -1
#define kCheckPrivateResponseInterval \
  0  //发送UDP内网请求后，检查是否有响应数据的间隔，单位为秒
#define kCheckPublicResponseInterval \
  0  //发送UDP外网请求后，检查是否有响应数据的间隔，单位为秒
#define kTryCount -1  //请求失败后自动尝试次数

//日志
#ifdef DEBUG
#define debugLog(...) NSLog(__VA_ARGS__)
#define debugMethod() NSLog(@"%s", __func__)
#else
#define debugLog(...)
#define debugMethod()
#endif

#define isEqualOrGreaterToiOS7 \
  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define is4Inch ([[UIScreen mainScreen] bounds].size.height == 568)

#define PATH_OF_APP_HOME NSHomeDirectory()
#define PATH_OF_TEMP NSTemporaryDirectory()
#define PATH_OF_DOCUMENT                                                      \
  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, \
                                       YES) objectAtIndex:0]
//延迟最大时间
#define kDelayMax 1440

#define DEFAULT_SWITCH_NAME NSLocalizedString(@"Smart Switch", nil)
#define DEFAULT_SOCKET1_NAME NSLocalizedString(@"Socket1", nil)
#define DEFAULT_SOCKET2_NAME NSLocalizedString(@"Socket2", nil)

//在家测试
#define isHome 0

//是否当前版本第一次打开
#define kWelcomePageShowed @"WelcomePageShowed"
#define kCurrentVersion @"CurrentVersion"
#define kShake @"Shake"
//通知
#define kSceneDataChanged @"SceneDataChanged"
#define kLoginResponse @"LoginResponse"
#define kRegisterResponse @"RegisterResponse"
#define kLoginSuccess @"LoginSuccess"

//加密
#define __ENCRYPT(str) [DESUtil encryptString:str]
#define __DECRYPT(str) [DESUtil decryptString:str]

// json
#define __JSON(str)                                                   \
  [NSJSONSerialization                                                \
      JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] \
                 options:kNilOptions                                  \
                   error:nil]