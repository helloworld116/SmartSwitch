//
//  SwitchInfoViewController.m
//  SmartSwitch
//
//  Created by sdzg on 14-8-15.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "SwitchInfoViewController.h"
@interface SwitchInfoCell : UITableViewCell

@end

@implementation SwitchInfoCell

- (void)drawRect:(CGRect)rect {
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetLineWidth(context, 2.f);
  CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
  CGRect rectange = CGRectMake(rect.origin.x + 15, rect.origin.y,
                               rect.size.width - 2 * 15, rect.size.height - 2);
  CGContextAddRect(context, rectange);
  CGContextStrokePath(context);

  //    CGRect rectage = CGRectMake(150, 20, 100, 20);
  //    CGContextSetLineWidth(ctx, 2.f);
  //    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
  //    CGContextAddRect(ctx, rectage);
  //    CGContextStrokePath(ctx);
}

@end

@interface SwitchInfoViewController ()

@end

@implementation SwitchInfoViewController

- (id)initWithStyle:(UITableViewStyle)style {
  self = [super initWithStyle:style];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  // Uncomment the following line to preserve selection between presentations.
  // self.clearsSelectionOnViewWillAppear = NO;

  // Uncomment the following line to display an Edit button in the navigation
  // bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
