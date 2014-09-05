//
//  SceneActionView.m
//  SmartSwitch
//
//  Created by sdzg on 14-9-5.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "SceneActionView.h"

@implementation SceneActionView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
  }
  return self;
}

- (IBAction)cancel:(id)sender {
  [self layoutSubviews];
}

@end
