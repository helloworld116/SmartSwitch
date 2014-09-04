//
//  UserInfo.m
//  SmartSwitch
//
//  Created by sdzg on 14-9-3.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "UserInfo.h"
#import "LoginResponse.h"

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
  manager.responseSerializer = [AFHTTPResponseSerializer serializer];
  //  manager.responseSerializer.acceptableContentTypes =
  //      [NSSet setWithObject:@"text/html"];
  NSDictionary *parameters = @{
    @"username" : __ENCRYPT(self.username),
    @"password" : __ENCRYPT(self.password)
  };
  [manager POST:loginUrl
      parameters:parameters
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSString *string =
              [[NSString alloc] initWithData:responseObject
                                    encoding:NSUTF8StringEncoding];
          NSString *responseStr = __DECRYPT(string);
          LoginResponse *response =
              [[LoginResponse alloc] initWithResponseString:responseStr];
      }
      failure:^(AFHTTPRequestOperation *operation,
                NSError *error) { NSLog(@"Error: %@", error); }];
}

@end
