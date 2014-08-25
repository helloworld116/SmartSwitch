//
//  SocketView.m
//  SmartSwitch
//
//  Created by sdzg on 14-8-11.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "SocketView.h"

@interface SocketView ()
@property(nonatomic, assign) int socketId;
@property(nonatomic, strong) IBOutlet UIButton *btnName;
@property(nonatomic, strong) IBOutlet UIButton *btnIcon;
@property(nonatomic, strong) IBOutlet TimerCountdownView *viewTimerCountdown;
@property(nonatomic, strong) IBOutlet TimerCountdownView *viewDelayCountdown;
- (IBAction)touchName:(id)sender;
- (IBAction)touchIcon:(id)sender;
- (IBAction)touchTimer:(id)sender;
- (IBAction)touchDelay:(id)sender;
@end

@implementation SocketView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
  }
  return self;
}

- (void)awakeFromNib {
}

- (IBAction)touchName:(id)sender {
  debugLog(@"touchName");
}
- (IBAction)touchIcon:(id)sender {
  if ([self.delegate respondsToSelector:@selector(socketChangeStatus:)]) {
    [self.delegate socketChangeStatus:self.socketId];
  }
}
- (IBAction)touchTimer:(id)sender {
  if ([self.delegate respondsToSelector:@selector(socketTimer:)]) {
    [self.delegate socketTimer:self.socketId];
  }
}
- (IBAction)touchDelay:(id)sender {
  if ([self.delegate respondsToSelector:@selector(socketDelay:)]) {
    [self.delegate socketDelay:self.socketId];
  }
}

#pragma mark - 修改socket的展现
- (void)socketId:(int)socketId
      socketName:(NSString *)name
          status:(SocketStatus)status
           timer:(int)timerSeconds
           delay:(int)delaySeconds {
  self.socketId = socketId;
  [self setSocketName:name];
  [self setSocketStatus:status];
  [self setTimer:timerSeconds];
  [self countDown:delaySeconds];
}

- (void)countDown:(int)seconds {
  [self.viewDelayCountdown countDown:seconds];
}

- (void)setTimer:(int)seconds {
}

- (void)setSocketName:(NSString *)socketName {
  [self.btnName setTitle:socketName forState:UIControlStateNormal];
}

- (void)setSocketStatus:(SocketStatus)status {
  if (status == SocketStatusOn) {
    self.btnIcon.selected = YES;
  } else {
    self.btnIcon.selected = NO;
  }
}
@end
