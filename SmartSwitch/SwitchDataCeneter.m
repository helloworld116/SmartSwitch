//
//  SwitchDataCeneter.m
//  SmartSwitch
//
//  Created by sdzg on 14-8-19.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "SwitchDataCeneter.h"
@interface SwitchDataCeneter ()
@property(strong, atomic) NSMutableDictionary *switchsDict;
@end

@implementation SwitchDataCeneter
- (id)init {
  self = [super init];
  if (self) {
    // TODO: 从本地文件加载

    self.switchs = [[DBUtil sharedInstance] getSwitchs];
    self.switchsDict = [[NSMutableDictionary alloc] init];
    for (SDZGSwitch *aSwitch in self.switchs) {
      if (aSwitch.mac) {
        [self.switchsDict setObject:aSwitch forKey:aSwitch.mac];
      }
    }
  }
  return self;
}

+ (instancetype)sharedInstance {
  static SwitchDataCeneter *instance;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{ instance = [[self alloc] init]; });
  return instance;
}

- (void)updateSwitch:(SDZGSwitch *)aSwitch {
  @synchronized(self) {
    debugLog(@"update switch ceneter");
    NSDictionary *userInfo;
    if ([[self.switchsDict allKeys] containsObject:aSwitch.mac]) {
      //修改
      userInfo = @{ @"type" : @0, @"mac" : aSwitch.mac };
    } else {
      //新增一条记录
      userInfo = @{ @"type" : @1 };
    }
    [self.switchsDict setObject:aSwitch forKey:aSwitch.mac];
    self.switchs = [self.switchsDict allValues];
    [[NSNotificationCenter defaultCenter] postNotificationName:kSwitchUpdate
                                                        object:self
                                                      userInfo:userInfo];
  }
}
@end
