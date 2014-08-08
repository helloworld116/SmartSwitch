//
//  InsetsTextField.m
//  SmartSwitch
//
//  Created by sdzg on 14-8-8.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "InsetsTextField.h"

@implementation InsetsTextField

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
  }
  return self;
}

//控制文本所在的的位置，左右缩 10
- (CGRect)textRectForBounds:(CGRect)bounds {
  return CGRectInset(bounds, 50, 0);
}

//控制编辑文本时所在的位置，左右缩 10
- (CGRect)editingRectForBounds:(CGRect)bounds {
  return CGRectInset(bounds, 50, 0);
}

//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//
//    //    绘制图片
//    //  UIImage *image = [UIImage imageNamed:@"off"];
//    //  [image drawInRect:rect];
//
//    //    绘线
//    CGContextMoveToPoint(ctx, 20, 20);
//    CGContextSetLineWidth(ctx, 10);
//    CGContextAddLineToPoint(ctx, 20, 40);
//    CGContextStrokePath(ctx);
//
//    //    绘制三角形
//    CGContextMoveToPoint(ctx, 100, 20);
//    CGContextAddLineToPoint(ctx, 80, 40);
//    CGContextAddLineToPoint(ctx, 120, 40);
//    CGContextFillPath(ctx);
//
//    //    绘制矩形
//    CGContextSaveGState(ctx);
//    CGRect rectage = CGRectMake(150, 20, 100, 20);
//    CGContextSetLineWidth(ctx, 2.f);
//    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
//    CGContextAddRect(ctx, rectage);
//    CGContextStrokePath(ctx);
//    CGContextRestoreGState(ctx);
//
//    CGColorRef backColor = [UIColor blackColor].CGColor;
//    CGColorRef lightColor = [UIColor lightGrayColor].CGColor;
//    CGColorRef darkColor = [UIColor darkGrayColor].CGColor;
//    CGColorRef shadowColor =
//    [UIColor colorWithRed:.2f green:.2f blue:.2f alpha:.5f].CGColor;
//
//    CGContextSaveGState(ctx);
//    CGContextSetFillColorWithColor(ctx, darkColor);
//    CGContextMoveToPoint(ctx, 10, 100);
//    CGContextAddLineToPoint(ctx, 310, 100);
//    CGContextStrokePath(ctx);
//    CGContextRestoreGState(ctx);
//
//    CGContextMoveToPoint(ctx, 120, 120);
//    CGContextAddLineToPoint(ctx, 0, 150);
//    CGContextStrokePath(ctx);
//}
@end
