//
//  SwitchListCell.m
//  SmartSwitch
//
//  Created by sdzg on 14-8-7.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "SwitchListCell.h"

@implementation SwitchListCell

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

- (IBAction)doExpand:(id)sender {
  if ([self.cellDelegate respondsToSelector:@selector(cellDoExpand:)]) {
    [self.cellDelegate cellDoExpand:self];
  }
  self.isExpand = !self.isExpand;
}
@end
