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

- (void)drawRect:(CGRect)rect {
  //  rect = self.contentView.frame;
  //  CGContextRef context = UIGraphicsGetCurrentContext();
  //  //  CGContextSetFillColorWithColor(
  //  //      context, [UIColor colorWithHexString:@"#cccccc"].CGColor);
  //  //  CGContextFillRect(context, rect);
  //  //  CGContextSetStrokeColorWithColor(
  //  //      context, [UIColor colorWithHexString:@"#cccccc"].CGColor);
  //  //  CGContextStrokeRect(context,
  //  //                      CGRectMake(0, rect.size.height - 3,
  //  rect.size.width,
  //  //                      3));
  //  //  CGContextStrokePath(context);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}

- (void)setCellInfo:(SDZGSwitch *)aSwitch {
  self.lblName.text = aSwitch.name;
  if (aSwitch.lockStatus == LockStatusOn) {
    self.imgViewOfState.image = [UIImage imageNamed:@"lock"];
  } else if (aSwitch.lockStatus == LockStatusOff) {
    self.imgViewOfState.image = nil;
  }
}

- (IBAction)doExpand:(id)sender {
  if ([self.cellDelegate respondsToSelector:@selector(cellDoExpand:)]) {
    [self.cellDelegate cellDoExpand:self];
  }
  self.isExpand = !self.isExpand;
}
@end
