//
//  CycleViewController.m
//  SmartSwitch
//
//  Created by sdzg on 14-8-14.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "CycleViewController.h"
#define kCycleDict                                                             \
  @{                                                                           \
    @"0" : @"周一",                                                          \
    @"1" : @"周二",                                                          \
    @"2" : @"周三",                                                          \
    @"3" : @"周四",                                                          \
    @"4" : @"周五",                                                          \
    @"5" : @"周六",                                                          \
    @"6" : @"周日"                                                           \
  }

@interface CycleCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *viewOfCellContent;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UIButton *btnSelected;
@end
@implementation CycleCell
- (void)awakeFromNib {
  self.viewOfCellContent.layer.borderWidth = 1.0f;
  self.viewOfCellContent.layer.borderColor = [UIColor lightGrayColor].CGColor;
  self.viewOfCellContent.layer.cornerRadius = 1.5f;
  self.btnSelected.selected = NO;
}

@end

@interface CycleViewController ()
@property (nonatomic, strong) NSMutableDictionary *data;

@end
@implementation CycleViewController
- (id)initWithStyle:(UITableViewStyle)style {
  self = [super initWithStyle:style];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)setup {
  if (self.week == 0) {
    self.data = [@{
      @"section0" : [@[ @NO, @NO, @NO, @NO, @NO, @NO, @NO ] mutableCopy],
      @"section1" : [@[ @NO ] mutableCopy]
    } mutableCopy];
  } else if (self.week == 127) {
    self.data = [@{
      @"section0" :
          [@[ @YES, @YES, @YES, @YES, @YES, @YES, @YES ] mutableCopy],
      @"section1" : [@[ @YES ] mutableCopy]
    } mutableCopy];
  } else {
    self.data = [@{
      @"section0" : [@[
        @((self.week & 1 << 0) == 1 << 0),
        @((self.week & 1 << 1) == 1 << 1),
        @((self.week & 1 << 2) == 1 << 2),
        @((self.week & 1 << 3) == 1 << 3),
        @((self.week & 1 << 4) == 1 << 4),
        @((self.week & 1 << 5) == 1 << 5),
        @((self.week & 1 << 6) == 1 << 6),
      ] mutableCopy],
      @"section1" : [@[ @NO ] mutableCopy]
    } mutableCopy];
  }
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.navigationItem.title = @"周期选择";
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
      initWithImage:[UIImage imageNamed:@"fh"]
              style:UIBarButtonItemStylePlain
             target:self.navigationController
             action:@selector(popViewControllerAnimated:)];
  self.navigationItem.rightBarButtonItem =
      [[UIBarButtonItem alloc] initWithTitle:@"保存"
                                       style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(save:)];

  UIView *tableHeaderView = [[UIView alloc]
      initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 30)];
  tableHeaderView.backgroundColor = [UIColor clearColor];
  self.tableView.tableHeaderView = tableHeaderView;
  self.tableView.tableFooterView = tableHeaderView;
#warning UITableView出了问题看这里
  [[UITableViewHeaderFooterView appearance] setTintColor:[UIColor clearColor]];

  [self setup];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 2;
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForHeaderInSection:(NSInteger)section {
  if (section == 1) {
    return 40.f;
  }
  return 0.f;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  if (section == 0) {
    return 7;
  } else {
    return 1;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellID = @"CycleCell";
  CycleCell *cell =
      (CycleCell *)[tableView dequeueReusableCellWithIdentifier:cellID
                                                   forIndexPath:indexPath];
  switch (indexPath.section) {
    case 0:
      cell.lblDate.text = [kCycleDict
          objectForKey:[NSString stringWithFormat:@"%d", indexPath.row]];
      cell.btnSelected.selected = [[[self.data objectForKey:@"section0"]
          objectAtIndex:indexPath.row] boolValue];
      break;

    case 1:
      cell.lblDate.text = @"每天";
      cell.btnSelected.selected = [[[self.data objectForKey:@"section1"]
          objectAtIndex:indexPath.row] boolValue];

      break;
  }
  return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0) {
    NSMutableArray *array = [self.data objectForKey:@"section0"];
    BOOL state = ![[array objectAtIndex:indexPath.row] boolValue];
    [array replaceObjectAtIndex:indexPath.row withObject:@(state)];
    [tableView reloadRowsAtIndexPaths:@[ indexPath ]
                     withRowAnimation:UITableViewRowAnimationNone];
    //修改section1
    int result = 0;
    for (int i = 0; i < array.count; i++) {
      int oneCellState = [[array objectAtIndex:i] boolValue];
      //如果所有的都是勾选，则每天勾选，反之有一个没勾选则每天不勾选
      result += oneCellState;
    }
    NSMutableArray *arrayInSection1 = [self.data objectForKey:@"section1"];
    NSNumber *num;
    if (result == 7) {
      num = @YES;
    } else {
      num = @NO;
    }
    [arrayInSection1 replaceObjectAtIndex:0 withObject:num];
    [tableView reloadSections:[NSIndexSet indexSetWithIndex:1]
             withRowAnimation:UITableViewRowAnimationNone];
  } else {
    NSMutableArray *array = [self.data objectForKey:@"section1"];
    BOOL state = ![[array objectAtIndex:indexPath.row] boolValue];
    [array replaceObjectAtIndex:indexPath.row withObject:@(state)];
    [tableView reloadRowsAtIndexPaths:@[ indexPath ]
                     withRowAnimation:UITableViewRowAnimationNone];
    //修改section0的状态
    NSMutableArray *arrayInSection0 = [self.data objectForKey:@"section0"];
    for (int i = 0; i < arrayInSection0.count; i++) {
      [arrayInSection0 replaceObjectAtIndex:i withObject:@(state)];
    }
    [tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
             withRowAnimation:UITableViewRowAnimationNone];
  }
}

#pragma mark - UINavigationBar事件
- (void)save:(id)sender {
  NSArray *array = [self.data objectForKey:@"section0"];
  int week = [array[0] intValue] << 0 | [array[1] intValue] << 1 |
             [array[2] intValue] << 2 | [array[3] intValue] << 3 |
             [array[4] intValue] << 4 | [array[5] intValue] << 5 |
             [array[6] intValue] << 6;
  [self.delegate passValue:@(week)];
  debugLog(@"week is %d", week);
  [self.navigationController popViewControllerAnimated:YES];
}
@end
