//
//  SceneAddListCell.m
//  SmartSwitch
//
//  Created by sdzg on 14-8-31.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "SceneAddListCell.h"

@implementation SceneAddListCell

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

- (IBAction)buttonClick:(id)sender {
  if ([self.delegate respondsToSelector:@selector(selectedCell:)]) {
    [self.delegate selectedCell:self];
  }
}
@end
