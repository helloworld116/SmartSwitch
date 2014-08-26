//
//  SwitchExpandCell.m
//  SmartSwitch
//
//  Created by sdzg on 14-8-7.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "SwitchExpandCell.h"

@implementation SwitchExpandCell

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

- (void)setCellInfo:(SDZGSwitch *)aSwitch {
  [super setCellInfo:aSwitch];
  SDZGSocket *socket1 = [aSwitch.sockets objectAtIndex:0];
  if (socket1.socketStatus == SocketStatusOn) {
    self.btnSocket1.selected = YES;
  } else {
    self.btnSocket1.selected = NO;
  }
  SDZGSocket *socket2 = [aSwitch.sockets objectAtIndex:1];
  if (socket2.socketStatus == SocketStatusOn) {
    self.btnSocket2.selected = YES;
  } else {
    self.btnSocket2.selected = NO;
  }
}

- (IBAction)doExpand:(id)sender {
  [super doExpand:sender];
}

- (IBAction)socketTouched:(id)sender {
  if ([self.expandCellDelegate
          respondsToSelector:@selector(socketAction:socketId:)]) {
    UIButton *btn = (UIButton *)sender;
    int socketId = btn.tag - 1000;  //按钮的tag已设置为1001和1002
    [self.expandCellDelegate socketAction:self socketId:socketId];
  }
}
@end
