//
//  ElecRealTimeView.m
//  SmartSwitch
//
//  Created by 文正光 on 14-8-23.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "ElecRealTimeView.h"

#define kLineColor [UIColor whiteColor]
#define kFillColor [UIColor colorWithWhite:1.0 alpha:0.2]
#define kBigRoundStrokeColor [UIColor colorWithHexString:@"#0099ff"]
#define kBigRoundFillColor [UIColor whiteColor]
#define kTextColor [UIColor whiteColor]
#define str(value) [NSString stringWithFormat:@"%.fw", value]
#define kTopMargin 10 //上边距

@interface ElecRealTimeView ()
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, strong) NSMutableArray *points;
@end
@implementation ElecRealTimeView
- (void)awakeFromNib {
  self.points = [@[] mutableCopy];
  __weak id weakSelf = self;
  double delayInSeconds = 1;
  self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,
                                      dispatch_get_main_queue());
  dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0),
                            (unsigned)(delayInSeconds * NSEC_PER_SEC), 0);
  dispatch_source_set_event_handler(_timer, ^{ [weakSelf updateView]; });
  dispatch_resume(_timer);
}

- (void)updateView {
  //随机取0到2000的值
  int value = (arc4random() % 500);
  //  int value = 0;
  //  NSLog(@"next value is %d", value);
  [self.points addObject:@(value)];
  //最大显示个数
  static int count = 8;
  if (self.points.count > count) {
    [self.points removeObjectAtIndex:0];
  }
  [self setNeedsDisplay];
}

- (void)dealloc {
  dispatch_source_cancel(self.timer);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
  if (self.points.count == 0) {
    return;
  }

  // Drawing code
  CGContextRef context = UIGraphicsGetCurrentContext();

  //创建句柄
  CGMutablePathRef pathRef = CGPathCreateMutable();
  CGContextSetLineCap(context, kCGLineCapRound);
  CGContextSetLineJoin(context, kCGLineJoinRound);
  CGContextSetLineWidth(context, 1);
  CGContextSetStrokeColorWithColor(context, kLineColor.CGColor);
  CGContextSetFillColorWithColor(context, kFillColor.CGColor);
  int maxValue = [[self.points valueForKeyPath:@"@max.self"] integerValue];
  CGFloat height = rect.size.height - kTopMargin; //离上边距
  CGFloat scaleY = 1;
  if (maxValue > height) {
    scaleY = height / maxValue;
  }
  CGFloat scaleX = 42;
  for (int i = 0; i < self.points.count; i++) {
    double point = [[self.points objectAtIndex:i] doubleValue];
    CGFloat x = scaleX * i, y = height - (point * scaleY) + kTopMargin / 2;
    if (i == 0) {
      CGPathMoveToPoint(pathRef, NULL, x, y);
    } else {
      CGPathAddLineToPoint(pathRef, NULL, x, y);
    }
  }
  //填充颜色
  CGPathAddLineToPoint(pathRef, NULL, (scaleX * self.points.count - 1),
                       height + kTopMargin + 1);
  CGPathAddLineToPoint(pathRef, NULL, -2, height + kTopMargin + 1);
  CGPathCloseSubpath(pathRef);
  //将path添加到上下文
  CGContextAddPath(context, pathRef);
  CGContextDrawPath(context, kCGPathEOFillStroke);
  CGPathRelease(pathRef);

  //大圆
  pathRef = CGPathCreateMutable();
  CGContextSetLineWidth(context, 0.5f);
  CGContextSetStrokeColorWithColor(context, kBigRoundStrokeColor.CGColor);
  CGContextSetFillColorWithColor(context, kBigRoundFillColor.CGColor);
  for (int i = 0; i < self.points.count; i++) {
    double point = [[self.points objectAtIndex:i] doubleValue];
    CGFloat x = scaleX * i, y = height - (point * scaleY) + kTopMargin / 2;
    double bigRoundRadius = 4.0f; //大圆半径
    CGContextAddEllipseInRect(
        context, CGRectMake(x - bigRoundRadius, y - bigRoundRadius,
                            2 * bigRoundRadius, 2 * bigRoundRadius));
  }
  CGContextAddPath(context, pathRef);
  CGContextDrawPath(context, kCGPathFillStroke);
  CGPathRelease(pathRef);

  //小圆
  pathRef = CGPathCreateMutable();
  CGContextSetFillColorWithColor(context, kBigRoundStrokeColor.CGColor);
  for (int i = 0; i < self.points.count; i++) {
    double point = [[self.points objectAtIndex:i] doubleValue];
    CGFloat x = scaleX * i, y = height - (point * scaleY) + kTopMargin / 2;
    double smallRoundRadius = 1.5f; //小圆半径
    CGContextAddEllipseInRect(
        context, CGRectMake(x - smallRoundRadius, y - smallRoundRadius,
                            2 * smallRoundRadius, 2 * smallRoundRadius));
  }
  CGContextAddPath(context, pathRef);
  CGContextDrawPath(context, kCGPathFill);
  CGPathRelease(pathRef);

  CGContextSaveGState(context);
  CGContextSetFillColorWithColor(context, kTextColor.CGColor);
  //  [kTextColor set];
  for (int i = 0; i < self.points.count; i++) {
    double point = [[self.points objectAtIndex:i] doubleValue];
    CGFloat textOffset;
    if (i == 0) {
      textOffset = 0.f;
    } else if (i == self.points.count - 1) {
      textOffset = -16.f;
    } else {
      textOffset = -8.f;
    }
    CGFloat y = height - (point * scaleY);
    if (y < kTopMargin) {
      y += kTopMargin;
    } else {
      y -= kTopMargin;
    }
    CGPoint cPoint = CGPointMake(scaleX * i + textOffset, y);
    [self drawAtPoint:cPoint withStr:str(point)];
  }
  CGContextRestoreGState(context);
}

- (void)drawAtPoint:(CGPoint)point withStr:(NSString *)str {
  [str drawAtPoint:point withFont:[UIFont systemFontOfSize:10]];
  //  [str drawAtPoint:point
  //      withAttributes:@{
  //                       NSFontAttributeName : [UIFont systemFontOfSize:10],
  //                       NSForegroundColorAttributeName : kTextColor
  //                     }];
}

@end
