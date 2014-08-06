//
//  AppDelegate.h
//  SmartSwitch
//
//  Created by sdzg on 14-8-5.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder<UIApplicationDelegate>

@property(strong, nonatomic) UIWindow *window;
@property(nonatomic, assign) NetworkStatus networkStatus;
@property(nonatomic, strong) UIViewController *centerViewController;
@property(nonatomic, strong) UIViewController *leftViewController;
@end
