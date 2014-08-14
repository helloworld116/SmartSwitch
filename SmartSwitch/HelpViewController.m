//
//  HelpViewController.m
//  SmartSwitch
//
//  Created by sdzg on 14-8-6.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "HelpViewController.h"
#import <UINavigationController+SGProgress.h>

@interface HelpViewController ()<UIWebViewDelegate>
@property(strong, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)back:(id)sender;
@end

@implementation HelpViewController

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
  self.navigationItem.title = @"晟大帮助";
  [self.sidePanelController setLeftPanel:nil];

  [self.navigationController showSGProgressWithDuration:1
                                           andTintColor:[UIColor whiteColor]];
  NSURL *url =
      [NSURL URLWithString:@"http://server.itouchco.com:18080/faq.html"];
  NSURLRequest *request = [NSURLRequest requestWithURL:url];
  self.webView.delegate = self;
  [self.webView loadRequest:request];
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

#pragma mark - UIWebviewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
  //    [self.navigationController showSGProgress];  // defaults to 3 seconds
  //  [self.navigationController
  //      showSGProgressWithDuration:3];  // uses the navbar tint color
  //  [self.navigationController showSGProgressWithDuration:3
  //                                           andTintColor:[UIColor
  //                                           blueColor]];
  //  [self.navigationController showSGProgressWithDuration:3
  //                                           andTintColor:[UIColor blueColor]
  //                                               andTitle:@"Sending..."];
  //  [self.navigationController showSGProgressWithMaskAndDuration:3];
  //  [self.navigationController showSGProgressWithMaskAndDuration:3
  //                                                      andTitle:@"Sending..."];

  //  [self.navigationController showSGProgressWithDuration:3
  //                                           andTintColor:[UIColor redColor]
  //                                               andTitle:@"Sending..."];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
  //  [self.navigationController finishSGProgress];
}
@end
