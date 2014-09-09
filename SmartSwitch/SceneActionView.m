//
//  SceneActionView.m
//  SmartSwitch
//
//  Created by sdzg on 14-9-5.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "SceneActionView.h"
@implementation SceneActionCell
@end

@implementation SceneActionView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
  }
  return self;
}

- (void)sceneDetails:(NSArray *)sceneDetails {
  _sceneDetails = sceneDetails;
  int count = sceneDetails.count;
//self.tableView
}

- (IBAction)cancel:(id)sender {
  //  [self layoutSubviews];
  if ([self.delegate respondsToSelector:@selector(cancelAction)]) {
    [self.delegate cancelAction];
  }
}

@end
