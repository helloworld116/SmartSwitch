//
//  SceneAddView.m
//  SmartSwitch
//
//  Created by sdzg on 14-8-31.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "SceneAddView.h"

@implementation SceneAddView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
  }
  return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (IBAction)save:(id)sender {
}
- (IBAction)close:(id)sender {
  CGRect rect = self.frame;
  CGFloat originY = rect.size.height;
  rect = CGRectMake(rect.origin.x, originY, rect.size.width, rect.size.height);
  [UIView animateWithDuration:0.3 animations:^{ self.frame = rect; }];
}

- (IBAction)touchBackground:(id)sender {
  CGRect rect = self.frame;
  CGFloat originY = rect.size.height;
  rect = CGRectMake(rect.origin.x, originY, rect.size.width, rect.size.height);
  [UIView animateWithDuration:0.3 animations:^{ self.frame = rect; }];
}
@end
