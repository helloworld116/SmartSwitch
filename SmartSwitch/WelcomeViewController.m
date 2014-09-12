//
//  WelcomeViewController.m
//  SmartSwitch
//
//  Created by sdzg on 14-8-15.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "WelcomeViewController.h"
#import <EAIntroView.h>

@interface WelcomeViewController ()<EAIntroDelegate>
@property(strong, nonatomic) IBOutlet EAIntroView *introView;

@end

@implementation WelcomeViewController

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

  //  self.introView.delegate = self;
  EAIntroPage *page1 = [EAIntroPage page];
  //  [page1 setBgImage:[UIImage
  //                        imageWithContentsOfFile:[[NSBundle mainBundle]
  //                                                    pathForResource:@"yanshi01"
  //                                                             ofType:@"png"]]];
  //  [page1
  //      setBgImage:[UIImage imageWithContentsOfFile:
  //                              [[NSBundle mainBundle]
  //                                  pathForResource:@"yanshi01"
  //                                           ofType:@"png"
  //                                      inDirectory:@"Images.xcassets/image"]]];
  [page1 setBgImage:[UIImage imageNamed:@"yanshi01"]];
  EAIntroPage *page2 = [EAIntroPage page];
  //  [page2 setBgImage:[UIImage
  //                        imageWithContentsOfFile:[[NSBundle mainBundle]
  //                                                    pathForResource:@"yanshi02"
  //                                                             ofType:@"png"]]];
  EAIntroPage *page3 = [EAIntroPage page];
  [page2 setBgImage:[UIImage imageNamed:@"yanshi02"]];
  //  [page3 setBgImage:[UIImage
  //                        imageWithContentsOfFile:[[NSBundle mainBundle]
  //                                                    pathForResource:@"yanshi03"
  //                                                             ofType:@"png"]]];
  [page3 setBgImage:[UIImage imageNamed:@"yanshi03"]];

  EAIntroPage *page4 = [EAIntroPage page];
  [page4 setBgImage:[UIImage imageNamed:@"yanshi04"]];
  UIButton *enterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  [enterBtn setBackgroundImage:[UIImage imageNamed:@"mskq"]
                      forState:UIControlStateNormal];
  [enterBtn setFrame:CGRectMake(0, 0, 105, 37)];
  [enterBtn setTitle:@"马上开启" forState:UIControlStateNormal];
  [enterBtn addTarget:self
                action:@selector(enterMainViewController:)
      forControlEvents:UIControlEventTouchUpInside];
  page4.titleIconPositionY = [[UIScreen mainScreen] bounds].size.height - 120;
  page4.titleIconView = enterBtn;

  NSArray *pages = @[ page1, page2, page3, page4 ];
  [self.introView setPages:pages];
  [self.introView setSwipeToExit:NO];
  [self.introView setSkipButton:nil];
  self.introView.pageControl.currentPageIndicatorTintColor =
      [UIColor colorWithHexString:@"#0099ff"];
  self.introView.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - UIStatusBarStyle
- (UIStatusBarStyle)preferredStatusBarStyle {
  return UIStatusBarStyleLightContent;
}

- (void)enterMainViewController:(id)sender {
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  [userDefaults setObject:@YES forKey:kWelcomePageShowed];

  NSString *appVersion =
      [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
  [userDefaults setObject:appVersion forKey:kCurrentVersion];

  UIViewController *mainViewController = [self.storyboard
      instantiateViewControllerWithIdentifier:@"SDZGSidePanelController"];
  [mainViewController
      setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
  [self presentViewController:mainViewController
                     animated:YES
                   completion:^{
                       kSharedAppliction.window.rootViewController =
                           mainViewController;
                   }];
}

#pragma mark - EAIntroDelegate
- (void)introDidFinish:(EAIntroView *)introView {
}
@end
