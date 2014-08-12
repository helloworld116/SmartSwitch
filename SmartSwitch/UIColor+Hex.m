//
//  UIColor+Hex.m
//  SmartSwitch
//
//  Created by sdzg on 14-8-12.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)
+ (UIColor*)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue {
  return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16)) / 255.0
                         green:((float)((hexValue & 0xFF00) >> 8)) / 255.0
                          blue:((float)(hexValue & 0xFF)) / 255.0
                         alpha:alphaValue];
}

+ (UIColor*)colorWithHex:(NSInteger)hexValue {
  return [UIColor colorWithHex:hexValue alpha:1.0];
}

+ (UIColor*)whiteColorWithAlpha:(CGFloat)alphaValue {
  return [UIColor colorWithHex:0xffffff alpha:alphaValue];
}

+ (UIColor*)blackColorWithAlpha:(CGFloat)alphaValue {
  return [UIColor colorWithHex:0x000000 alpha:alphaValue];
}
@end
