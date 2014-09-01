//
//  SceneAddView.m
//  SmartSwitch
//
//  Created by sdzg on 14-8-31.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "SceneAddView.h"
#import "SwitchDataCeneter.h"

@interface SwitchSocketSceneCell : UITableViewCell
@property(nonatomic, strong) IBOutlet UILabel *lbl;
@end
@implementation SwitchSocketSceneCell

@end

@interface SceneAddView ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) NSArray *switchs;
@property(nonatomic, strong) NSArray *sockets;  //选中switch的socket个数

@property(nonatomic, assign) NSInteger switchSelectedIndex;
@property(nonatomic, assign) NSInteger socketSelectedIndex;
@property(nonatomic, assign) NSInteger type;  // 0表示修改，1表示添加
@property(nonatomic, assign) NSInteger editIndex;  //修改时index，添加则为-1
@end

@implementation SceneAddView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
  }
  return self;
}

- (void)awakeFromNib {
  self.tableViewOfSwitch.delegate = self;
  self.tableViewOfSocket.delegate = self;
  self.tableViewOfSwitch.dataSource = self;
  self.tableViewOfSocket.dataSource = self;
  self.switchs = [SwitchDataCeneter sharedInstance].switchs;
}

- (void)selectTableViewWithMac:(NSString *)mac
                      socketId:(int)socketId
                       onOrOff:(BOOL)onOrOff
                     editIndex:(NSInteger)editIndex {
  SDZGSwitch *selectedSwitch;
  int switchSelectIndex = 0;
  for (int i = 0; i < self.switchs.count; i++) {
    SDZGSwitch *aSwitch = [self.switchs objectAtIndex:i];
    if ([aSwitch.mac isEqualToString:mac]) {
      selectedSwitch = aSwitch;
      switchSelectIndex = i;
      self.sockets = aSwitch.sockets;
      [self.tableViewOfSocket reloadData];
      break;
    }
  }
  if (selectedSwitch) {
    //修改
    self.type = 0;
    NSIndexPath *switchIndexPath =
        [NSIndexPath indexPathForRow:switchSelectIndex inSection:0];
    [self.tableViewOfSwitch selectRowAtIndexPath:switchIndexPath
                                        animated:YES
                                  scrollPosition:UITableViewScrollPositionTop];
    NSIndexPath *socketIndexPath =
        [NSIndexPath indexPathForRow:(socketId - 1)inSection:0];
    [self.tableViewOfSocket selectRowAtIndexPath:socketIndexPath
                                        animated:YES
                                  scrollPosition:UITableViewScrollPositionTop];
    self.switchOfAction.on = onOrOff;
    self.editIndex = editIndex;
  } else {
    //添加
    self.type = 1;
    [self.tableViewOfSwitch reloadData];
    self.sockets = nil;
    [self.tableViewOfSocket reloadData];
    self.switchOfAction.on = YES;
    self.switchSelectedIndex = -1;
    self.socketSelectedIndex = -1;
    self.editIndex = -1;
  }
}

- (IBAction)save:(id)sender {
  if (self.switchSelectedIndex != -1 && self.socketSelectedIndex != -1) {
    [self hiddenSelfRectInScreen];
    SDZGSwitch *aSwitch = [self.switchs objectAtIndex:self.switchSelectedIndex];
    SDZGSocket *socket = [self.sockets objectAtIndex:self.socketSelectedIndex];
    BOOL onOrOff = self.switchOfAction.on;
    if ([self.delegate respondsToSelector:@selector(selectedSwitch:
                                                            socket:
                                                           onOrOff:
                                                         editIndex:)]) {
      [self.delegate selectedSwitch:aSwitch
                             socket:socket
                            onOrOff:onOrOff
                          editIndex:self.editIndex];
    }
  } else {
    [self
        makeToast:@"请选择插座和插孔"
         duration:1.f
         position:[NSValue valueWithCGPoint:CGPointMake(
                                                self.frame.size.width / 2,
                                                self.frame.size.height - 40)]];
  }
}

- (IBAction)close:(id)sender {
  [self hiddenSelfRectInScreen];
}

- (IBAction)touchBackground:(id)sender {
  [self hiddenSelfRectInScreen];
}

- (void)hiddenSelfRectInScreen {
  CGRect rect = self.frame;
  CGFloat originY = rect.size.height;
  rect = CGRectMake(rect.origin.x, originY, rect.size.width, rect.size.height);
  [UIView animateWithDuration:0.3 animations:^{ self.frame = rect; }];
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 30.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *identifier = @"SwitchSocketSceneCell";
  SwitchSocketSceneCell *cell =
      [tableView dequeueReusableCellWithIdentifier:identifier];
  if (tableView == self.tableViewOfSwitch) {
    SDZGSwitch *aSwitch = [self.switchs objectAtIndex:indexPath.row];
    cell.lbl.text = aSwitch.name;
  } else if (tableView == self.tableViewOfSocket) {
    SDZGSocket *socket = [self.sockets objectAtIndex:indexPath.row];
    cell.lbl.text = socket.name;
  }
  return cell;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  if (tableView == self.tableViewOfSwitch) {
    return self.switchs.count;
  } else if (tableView == self.tableViewOfSocket) {
    return self.sockets.count;
  }
  return 0;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.tableViewOfSwitch == tableView) {
    self.switchSelectedIndex = indexPath.row;
    SDZGSwitch *aSwitch = [self.switchs objectAtIndex:indexPath.row];
    self.sockets = aSwitch.sockets;
    [self.tableViewOfSocket reloadData];
  } else if (self.tableViewOfSocket == tableView) {
    self.socketSelectedIndex = indexPath.row;
  }
}
@end
