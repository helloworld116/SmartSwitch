//
//  UserInfo.m
//  SmartSwitch
//
//  Created by sdzg on 14-9-3.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo
- (id)init {
  self = [super init];
  if (self) {
  }
  return self;
}

- (id)initWithUsername:(NSString *)username password:(NSString *)password {
  self = [super init];
  if (self) {
    self.username = username;
    self.password = password;
  }
  return self;
}

static NSString *const BaseURLString = @"http://192.168.0.89:8080/ais/";
- (void)send {
  NSString *loginUrl =
      [NSString stringWithFormat:@"%@api/login/login", BaseURLString];
  AFHTTPRequestOperationManager *manager =
      [AFHTTPRequestOperationManager manager];
  manager.responseSerializer.acceptableContentTypes =
      [NSSet setWithObjects:@"text/html", nil];
  NSDictionary *parameters = @{
    @"username" : __ENCRYPT(self.username),
    @"password" : __ENCRYPT(self.password)
  };
  debugLog(@"username is %@ after encrypt is %@", self.username,
           __ENCRYPT(self.username));
  debugLog(@"username decrypt is %@", __DECRYPT(__ENCRYPT(self.username)));

  debugLog(@"password is %@ after encrypt is %@", self.password,
           __ENCRYPT(self.password));
  debugLog(@"password decrypt is %@", __DECRYPT(__ENCRYPT(self.password)));

  debugLog(@"response is %@",
           __DECRYPT(@"8B0761E78B17F4E011302B15FAEA9547D08EF665F9BB814B8A8ECFB6"
                     @"8F663282ED435620AB8E9B04A3AA9C09814E6534"));
  [manager POST:loginUrl
      parameters:parameters
      success:^(AFHTTPRequestOperation *operation,
                id responseObject) { NSLog(@"JSON: %@", responseObject); }
      failure:^(AFHTTPRequestOperation *operation,
                NSError *error) { NSLog(@"Error: %@", error); }];
}
@end
