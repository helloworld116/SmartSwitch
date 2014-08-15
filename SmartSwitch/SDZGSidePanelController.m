//
//  SDZGSidePanelController.m
//  SmartSwitch
//
//  Created by sdzg on 14-8-6.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "SDZGSidePanelController.h"

@interface SDZGSidePanelController ()

@end

@implementation SDZGSidePanelController

- (void)awakeFromNib {
  kSharedAppliction.leftViewController = [self.storyboard
      instantiateViewControllerWithIdentifier:@"MenuViewController"];
  [self setLeftPanel:kSharedAppliction.leftViewController];
  [self setCenterPanel:[self.storyboard instantiateViewControllerWithIdentifier:
                                            @"SwitchAndSceneNavController"]];
  [self setLeftFixedWidth:269.f];
}

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
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - UIStatusBarStyle
- (UIStatusBarStyle)preferredStatusBarStyle {
  return UIStatusBarStyleLightContent;
}

#pragma mark - override JASidePanelController
- (void)styleContainer:(UIView *)container
               animate:(BOOL)animate
              duration:(NSTimeInterval)duration {
  UIBezierPath *shadowPath =
      [UIBezierPath bezierPathWithRoundedRect:container.bounds
                                 cornerRadius:0.0f];
  if (animate) {
    CABasicAnimation *animation =
        [CABasicAnimation animationWithKeyPath:@"shadowPath"];
    animation.fromValue = (id)container.layer.shadowPath;
    animation.toValue = (id)shadowPath.CGPath;
    animation.duration = duration;
    [container.layer addAnimation:animation forKey:@"shadowPath"];
  }
  //  container.layer.shadowPath = shadowPath.CGPath;
  //  container.layer.shadowColor = [UIColor blackColor].CGColor;
  //  container.layer.shadowRadius = 0.0f;
  //  container.layer.shadowOpacity = 0.75f;
  container.clipsToBounds = NO;
}

- (void)stylePanel:(UIView *)panel {
  panel.layer.cornerRadius = 0.0f;
  panel.clipsToBounds = YES;
}

@end
