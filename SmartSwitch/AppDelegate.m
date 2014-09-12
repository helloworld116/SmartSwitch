//
//  AppDelegate.m
//  SmartSwitch
//
//  Created by sdzg on 14-8-5.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "AppDelegate.h"
#import "SwitchDataCeneter.h"
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/TencentOpenSDK.h>
#import "WXApi.h"
#import "WeiboApi.h"
#import "YXApi.h"
@interface AppDelegate ()
@property(nonatomic, strong) NetUtil *netUtil;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // Override point for customization after application launch.
  self.networkStatus = ReachableViaWiFi;  //这里必不可少,必须在view展现前执行
  self.netUtil = [NetUtil sharedInstance];
  [self.netUtil addNetWorkChangeNotification];

  [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
  //  [[UINavigationBar appearance] setBarTintColor:[UIColor blueColor]];
  UIImage *img = [[UIImage imageNamed:@"tbbj"]
      resizableImageWithCapInsets:UIEdgeInsetsMake(22, 20, 22, 20)];
  //  UIImage *img = [UIImage imageNamed:@"tbbj"];
  [[UINavigationBar appearance] setBackgroundImage:img
                                     forBarMetrics:UIBarMetricsDefault];
  [[UINavigationBar appearance]
      setTitleTextAttributes:@{
                               NSFontAttributeName :
                                   [UIFont boldSystemFontOfSize:22],
                               UITextAttributeTextColor : [UIColor whiteColor]
                             }];
  [self registPlatform];

  NSString *appVersion =
      [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
  NSString *currentVersion =
      [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentVersion];
  BOOL showed = [[[NSUserDefaults standardUserDefaults]
      objectForKey:kWelcomePageShowed] boolValue];
  if (showed && [appVersion isEqualToString:currentVersion]) {
    UIViewController *vc = [[self.window.rootViewController storyboard]
        instantiateViewControllerWithIdentifier:@"SDZGSidePanelController"];
    self.window.rootViewController = vc;
  }
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state.
  // This can occur for certain types of temporary interruptions (such as an
  // incoming phone call or SMS message) or when the user quits the application
  // and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down
  // OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate
  // timers, and store enough application state information to restore your
  // application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called
  // instead of applicationWillTerminate: when the user quits.
  [[SwitchDataCeneter sharedInstance] saveSwitchsToDB];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state;
  // here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the
  // application was inactive. If the application was previously in the
  // background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if
  // appropriate. See also applicationDidEnterBackground:.
}

- (void)registPlatform {
  [ShareSDK registerApp:@"2fcb43c41b18"];

  //添加QQ应用  注册网址  http://mobile.qq.com/api/
  [ShareSDK connectQQWithQZoneAppKey:@"1102403177"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];

  //添加QQ空间应用  注册网址  http://connect.qq.com/intro/login/
  [ShareSDK connectQZoneWithAppKey:@"1102403177"
                         appSecret:@"ciTN5giKaXVTUD7s"
                 qqApiInterfaceCls:[QQApiInterface class]
                   tencentOAuthCls:[TencentOAuth class]];

  //添加新浪微博应用 注册网址 http://open.weibo.com
  [ShareSDK
      connectSinaWeiboWithAppKey:@"4142586958"
                       appSecret:@"d097dd64ecf1bcc543c79573a2bbe558"
                     redirectUri:@"https://api.weibo.com/oauth2/default.html"];

  //添加微信应用 注册网址 http://open.weixin.qq.com
  [ShareSDK connectWeChatWithAppId:@"wx4868b35061f87885"
                         wechatCls:[WXApi class]];

  //添加腾讯微博应用 注册网址 http://dev.t.qq.com
  [ShareSDK connectTencentWeiboWithAppKey:@"801307650"
                                appSecret:@"ae36f4ee3946e1cbb98d6965b0b2ff5c"
                              redirectUri:@"http://www.sharesdk.cn"
                                 wbApiCls:[WeiboApi class]];

  [ShareSDK connectYiXinWithAppId:@"yx0d9a9f9088ea44d78680f3274da1765f"
                         yixinCls:[YXApi class]];

  [ShareSDK connectMail];
  [ShareSDK connectSMS];
  [ShareSDK connectCopy];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
  return [ShareSDK handleOpenURL:url wxDelegate:nil];
}

- (BOOL)application:(UIApplication *)application
              openURL:(NSURL *)url
    sourceApplication:(NSString *)sourceApplication
           annotation:(id)annotation {
  return [ShareSDK handleOpenURL:url
               sourceApplication:sourceApplication
                      annotation:annotation
                      wxDelegate:nil];
}
@end
