//
//  SceneListCell.m
//  SmartSwitch
//
//  Created by sdzg on 14-8-7.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "SceneListCell.h"

@implementation SceneListCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Initialization code
  }
  return self;
}

- (void)awakeFromNib {
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}

- (void)setScene:(Scene *)scene {
  self.lblName.text = scene.name;
}

- (IBAction)doScene:(id)sender {
  if ([self.delegate respondsToSelector:@selector(sceneAction:)]) {
    [self.delegate sceneAction:self];
  }
}
@end
