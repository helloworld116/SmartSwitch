//
//  UdpPort.m
//  SmartSwitch
//
//  Created by sdzg on 14-8-21.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "UdpPort.h"

@implementation UdpPort
- (id)initPort:(uint16_t)port
             isUsed:(BOOL)isUsed
    lastUsedSeconds:(long)lastUsedSeconds {
  self = [super init];
  if (self) {
    self.port = port;
    self.isUsed = isUsed;
    self.lastUsedSeconds = lastUsedSeconds;
  }
  return self;
}
@end

@implementation UdpPortCenter
- (id)init {
  self = [super init];
  if (self) {
    for (int i = APP_PORT_MIN; i <= APP_PORT_MAX; i++) {
      UdpPort *port = [[UdpPort alloc] initPort:i isUsed:NO lastUsedSeconds:0];
      NSString *key = [NSString stringWithFormat:@"%d", i];
      [self.portDict setObject:port forKey:key];
    }
  }
  return self;
}

+ (instancetype)sharedInstance {
  static UdpPortCenter *portCenter;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{ portCenter = [[UdpPortCenter alloc] init]; });
  return portCenter;
}

- (void)usedPort:(uint16_t)port {
  NSString *key = [NSString stringWithFormat:@"%d", port];
  UdpPort *udpPort = [self.portDict objectForKey:key];
  udpPort.isUsed = YES;
  [self.portDict setObject:udpPort forKey:key];
}

- (void)unUsedPort:(uint16_t)port {
  NSString *key = [NSString stringWithFormat:@"%d", port];
  UdpPort *udpPort = [self.portDict objectForKey:key];
  udpPort.isUsed = NO;
  [self.portDict setObject:udpPort forKey:key];
}

- (uint16_t)availablePort {
  NSArray *ports = [self.portDict allValues];
  uint16_t aPort = 0;
  for (UdpPort *port in ports) {
    if (!port.isUsed) {
      aPort = port.port;
      break;
    }
  }
  return aPort;
}
@end