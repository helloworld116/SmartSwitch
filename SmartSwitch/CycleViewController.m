//
//  CycleViewController.m
//  SmartSwitch
//
//  Created by sdzg on 14-8-14.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "CycleViewController.h"
#define kCycleDict    \
  @{                  \
    @"0" : @"周一", \
    @"1" : @"周二", \
    @"2" : @"周三", \
    @"3" : @"周四", \
    @"4" : @"周五", \
    @"5" : @"周六", \
    @"6" : @"周日"  \
  }

@interface CycleCell : UITableViewCell
@property(strong, nonatomic) IBOutlet UIView *viewOfCellContent;
@property(strong, nonatomic) IBOutlet UILabel *lblDate;
@property(strong, nonatomic) IBOutlet UIButton *btnSelected;
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
@end
@implementation CycleViewController
- (id)initWithStyle:(UITableViewStyle)style {
  self = [super initWithStyle:style];
  if (self) {
    // Custom initialization
  }
  return self;
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
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  // Return the number of sections.
  return 2;
}

//- (UIView *)tableView:(UITableView *)tableView
//    viewForFooterInSection:(NSInteger)section {
//  UIView *footerView;
//  if (section == 0) {
//    footerView = [[UIView alloc]
//        initWithFrame:CGRectMake(0, 1, self.view.frame.size.width, 50.f)];
//    footerView.backgroundColor = self.view.backgroundColor;
//  }
//  return footerView;
//}

- (CGFloat)tableView:(UITableView *)tableView
    heightForHeaderInSection:(NSInteger)section {
  if (section == 1) {
    return 40.f;
  }
  return 0.f;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  // Return the number of rows in the section.
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
      break;

    case 1:
      cell.lblDate.text = @"每天";
      break;
  }
  return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  CycleCell *cell = (CycleCell *)[tableView cellForRowAtIndexPath:indexPath];
  NSLog(@"btn is %@", NSStringFromCGRect(cell.btnSelected.frame));
  cell.btnSelected.selected = !cell.btnSelected.selected;
}

#pragma mark - UINavigationBar事件
- (void)save:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}
@end
