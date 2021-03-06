//
//  SocketView.m
//  SmartSwitch
//
//  Created by sdzg on 14-8-11.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "SocketView.h"
#import "TimeDisplayView.h"

@interface SocketView ()
@property(nonatomic, assign) int socketId;
@property(nonatomic, strong) IBOutlet UIButton *btnName;
@property(nonatomic, strong) IBOutlet UIButton *btnIcon;
@property(nonatomic, strong) IBOutlet TimeDisplayView *viewTimeDisplay;
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
  //  self.btnIcon.selected = NO;
}

- (IBAction)touchName:(id)sender {
  debugLog(@"touchName");
}
- (IBAction)touchIcon:(id)sender {
  if ([self.delegate respondsToSelector:@selector(socketChangeStatus:)]) {
    [self.delegate socketChangeStatus:self.socketId];
  }
  //是否震动 userdefault
  BOOL shake =
      [[[NSUserDefaults standardUserDefaults] valueForKey:kShake] boolValue];
  if (shake) {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
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
       timerList:(NSArray *)timerList
           delay:(int)delay {
  self.socketId = socketId;
  [self setSocketName:name];
  [self setSocketStatus:status];
  [self setTimer:[SDZGTimerTask getShowSeconds:timerList]];
  [self countDown:delay * 60];
}

- (void)countDown:(int)seconds {
  [self.viewDelayCountdown countDown:seconds];
}

- (void)setTimer:(int)seconds {
  [self.viewTimeDisplay dispSeconds:seconds];
}

- (void)setSocketName:(NSString *)socketName {
  dispatch_async(dispatch_get_main_queue(), ^{
      [self.btnName setTitle:socketName forState:UIControlStateNormal];
  });
}

- (void)setSocketStatus:(SocketStatus)status {
  dispatch_async(dispatch_get_main_queue(), ^{
      if (status == SocketStatusOn) {
        self.btnIcon.selected = YES;
      } else {
        self.btnIcon.selected = NO;
      }
  });
}
@end
