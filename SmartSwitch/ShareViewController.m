//
//  ShareViewController.m
//  SmartSwitch
//
//  Created by sdzg on 14-8-6.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "ShareViewController.h"

@interface ShareViewController ()
- (IBAction)back:(id)sender;
- (IBAction)share:(id)sender;
@end

@implementation ShareViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  self.navigationItem.title = @"晟大分享";
  [self.sidePanelController setLeftPanel:nil];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - 返回
- (IBAction)back:(id)sender {
  [self.sidePanelController
      setCenterPanel:kSharedAppliction.centerViewController];
  [[NSNotificationCenter defaultCenter] postNotificationName:@"back"
                                                      object:self];
}

- (IBAction)share:(id)sender {
  NSArray *shareList = [ShareSDK
      getShareListWithType:ShareTypeWeixiSession, ShareTypeWeixiTimeline,
                           ShareTypeSinaWeibo, ShareTypeQQ,
                           ShareTypeTencentWeibo, ShareTypeYiXinSession,
                           ShareTypeMail, ShareTypeSMS, ShareTypeCopy, nil];
  //定义容器
  id<ISSContainer> container = [ShareSDK container];
  [container setIPhoneContainerWithViewController:self];

  //定义分享内容
  id<ISSContent> publishContent = nil;

  NSString *contentString = @"无线开关APP下载地址http://www.pgyer.com/"
                            @"6L9J";
  NSString *titleString = @"分享无线开关APP下载地址";
  NSString *urlString = @"http://www.ShareSDK.cn";
  NSString *description = @"Sample";

  publishContent = [ShareSDK content:contentString
                      defaultContent:@""
                               image:nil
                               title:titleString
                                 url:urlString
                         description:description
                           mediaType:SSPublishContentMediaTypeText];

  //定义分享设置
  id<ISSShareOptions> shareOptions =
      [ShareSDK simpleShareOptionsWithTitle:@"分享内容"
                          shareViewDelegate:nil];

  [ShareSDK showShareActionSheet:container
                       shareList:shareList
                         content:publishContent
                   statusBarTips:YES
                     authOptions:nil
                    shareOptions:shareOptions
                          result:nil];
}
@end
