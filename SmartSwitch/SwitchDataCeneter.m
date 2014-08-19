//
//  SwitchDataCeneter.m
//  SmartSwitch
//
//  Created by sdzg on 14-8-19.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "SwitchDataCeneter.h"
@interface SwitchDataCeneter ()
@property(strong, nonatomic) NSMutableDictionary *switchsDict;
@end

@implementation SwitchDataCeneter
- (id)init {
  self = [super init];
  if (self) {
    // TODO: 从本地文件加载

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
  [self.switchsDict setObject:aSwitch forKey:aSwitch.mac];
  self.switchs = [self.switchsDict allValues];
  [[NSNotificationCenter defaultCenter] postNotificationName:kSwitchUpdate
                                                      object:self
                                                    userInfo:nil];
}
@end
