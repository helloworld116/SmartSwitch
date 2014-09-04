//
//  LoginResponse.m
//  SmartSwitch
//
//  Created by sdzg on 14-9-4.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "LoginResponse.h"

@implementation LoginResponse
- (id)initWithResponseString:(NSString *)response {
  self = [super init];
  if (self) {
    NSDictionary *responseDict = __JSON(response);
    self.status = [[responseDict objectForKey:@"status"] intValue];
    self.errorMsg = [responseDict objectForKey:@"errorMsg"];
    self.data = [responseDict objectForKey:@"data"];
  }
  return self;
}
@end
