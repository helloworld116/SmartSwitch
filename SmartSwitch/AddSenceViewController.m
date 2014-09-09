//
//  AddSenceViewController.m
//  SmartSwitch
//
//  Created by sdzg on 14-8-6.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "AddSenceViewController.h"
#import "SceneAddListCell.h"
#import "SceneAddView.h"
#import "SceneDetail.h"

@interface SceneTextField : UITextField

@end

@implementation SceneTextField
//控制文本所在的的位置，左右缩 10
- (CGRect)textRectForBounds:(CGRect)bounds {
  return CGRectInset(bounds, 15, 0);
}

//控制编辑文本时所在的位置，左右缩 10
- (CGRect)editingRectForBounds:(CGRect)bounds {
  return CGRectInset(bounds, 15, 0);
}

@end

@interface AddSenceViewController ()<
    UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate,
    UITextFieldDelegate, SceneAddViewDelegate, SceneAddListCellDeleage>
- (IBAction)backgroundTouch:(id)sender;
- (IBAction)back:(id)sender;
@property(strong, nonatomic) IBOutlet UITableView *tableViewOfSceneList;
@property(strong, nonatomic) IBOutlet SceneTextField *textFieldSceneName;
@property(strong, nonatomic) IBOutlet SceneAddView *viewOfAddScene;
@property(strong, nonatomic) NSString *sceneName;

@property(nonatomic, strong) NSMutableArray *detailList;  //保存记录
@property(nonatomic, strong) NSIndexPath *editIndexPath;  //长按短按时的index
- (IBAction)save:(id)sender;

@end

@implementation AddSenceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)setup {
  [self.sidePanelController setLeftPanel:nil];
  self.tableViewOfSceneList.dataSource = self;
  self.tableViewOfSceneList.delegate = self;
  self.textFieldSceneName.delegate = self;
  self.detailList = [@[] mutableCopy];
  self.viewOfAddScene.delegate = self;
  if (!self.scene) {
    self.scene = [[Scene alloc] init];
  } else {
    self.textFieldSceneName.text = self.scene.name;
    [self.detailList addObjectsFromArray:self.scene.detailList];
  }
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  self.navigationItem.title = @"添加场景";
  self.navigationItem.rightBarButtonItem =
      [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"tj"]
                                       style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(addScene:)];
  [self setup];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  return self.detailList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellId = @"SceneAddListCell";
  SceneAddListCell *listCell = (SceneAddListCell *)
      [self.tableViewOfSceneList dequeueReusableCellWithIdentifier:CellId];
  listCell.delegate = self;
  SceneDetail *detail = [self.detailList objectAtIndex:indexPath.row];
  listCell.lblAction.text = [detail description];
  UILongPressGestureRecognizer *longPressGesture =
      [[UILongPressGestureRecognizer alloc]
          initWithTarget:self
                  action:@selector(handlerLongPress:)];
  longPressGesture.minimumPressDuration = 0.5;
  [listCell addGestureRecognizer:longPressGesture];
  return listCell;
}

#pragma mark - SceneAddListCellDelegate
- (void)selectedCell:(SceneAddListCell *)cell {
  NSIndexPath *indexPath = [self.tableViewOfSceneList indexPathForCell:cell];
  SceneDetail *detail = [self.detailList objectAtIndex:indexPath.row];
  [self.viewOfAddScene selectTableViewWithMac:detail.mac
                                     socketId:detail.socketId
                                      onOrOff:detail.onOrOff
                                    editIndex:indexPath.row];
  [self addSceneViewBringToFront];
}

#pragma mark - SceneAddListCellHandler
- (void)handlerLongPress:(UILongPressGestureRecognizer *)gestureRecognizer {
  CGPoint p = [gestureRecognizer locationInView:self.tableViewOfSceneList];
  NSIndexPath *indexPath = [self.tableViewOfSceneList indexPathForRowAtPoint:p];
  self.editIndexPath = indexPath;
  if (indexPath && gestureRecognizer.state == UIGestureRecognizerStateBegan) {
    UIAlertView *alertView =
        [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                   message:@"确定删除该条记录"
                                  delegate:self
                         cancelButtonTitle:@"取消"
                         otherButtonTitles:@"确定", nil];
    [alertView show];
  }
}

- (void)alertView:(UIAlertView *)alertView
    clickedButtonAtIndex:(NSInteger)buttonIndex {
  switch (buttonIndex) {
    case 0:
      //取消
      break;
    case 1:
      [self.detailList removeObjectAtIndex:self.editIndexPath.row];
      [self.tableViewOfSceneList reloadData];
      break;
    default:
      break;
  }
}

#pragma mark - 场景添加视图显示和消失
- (void)addScene:(id)sender {
  [self.viewOfAddScene selectTableViewWithMac:nil
                                     socketId:0
                                      onOrOff:YES
                                    editIndex:-1];
  [self addSceneViewBringToFront];
}

- (void)addSceneViewBringToFront {
  CGRect addSceneViewRect = self.viewOfAddScene.frame;
  CGFloat originY = 0;
  if (addSceneViewRect.origin.y == self.view.frame.size.height) {
    originY = 0;
  } else {
    originY = self.view.frame.size.height;
  }
  addSceneViewRect =
      CGRectMake(addSceneViewRect.origin.x, originY,
                 addSceneViewRect.size.width, addSceneViewRect.size.height);
  [UIView
      animateWithDuration:0.3
               animations:^{ self.viewOfAddScene.frame = addSceneViewRect; }];
  [[self.viewOfAddScene superview] bringSubviewToFront:self.viewOfAddScene];
}

#pragma mark - UITextField
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  return YES;
}

#pragma mark - SceneAddViewDelegate
- (void)selectedSwitch:(SDZGSwitch *)aSwitch
                socket:(SDZGSocket *)socket
               onOrOff:(BOOL)onOrOff
             editIndex:(NSInteger)editIndex {
  SceneDetail *detail = [[SceneDetail alloc] initWithMac:aSwitch.mac
                                                socketId:socket.socketId
                                              switchName:aSwitch.name
                                              socketName:socket.name
                                                 onOrOff:onOrOff];
  if (editIndex == -1) {  //-1表示添加，其他则为修改，并且index即为编辑的索引
    [self.detailList addObject:detail];
  } else {
    [self.detailList replaceObjectAtIndex:editIndex withObject:detail];
  }
  [self.tableViewOfSceneList reloadData];
}

- (IBAction)backgroundTouch:(id)sender {
  [self.textFieldSceneName resignFirstResponder];
}

- (IBAction)back:(id)sender {
  if (self.type == 3) {
    [self.navigationController popViewControllerAnimated:YES];
  } else {
    [self dismissViewControllerAnimated:YES completion:^{}];
    [self.sidePanelController
        setCenterPanel:kSharedAppliction.centerViewController];
  }
}
- (IBAction)save:(id)sender {
  if ([self check]) {
    self.scene.name = self.sceneName;
    self.scene.detailList = self.detailList;
    BOOL result = [[DBUtil sharedInstance] saveScene:self.scene];
    if (result) {
      [self.view makeToast:@"执行成功"
                  duration:1.f
                  position:[NSValue valueWithCGPoint:
                                        CGPointMake(
                                            self.view.frame.size.width / 2,
                                            self.view.frame.size.height - 40)]];
      [[NSNotificationCenter defaultCenter]
          postNotificationName:kSceneDataChanged
                        object:nil];
    }
  }
}

//检查数据是否完善
- (BOOL)check {
  NSCharacterSet *charSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
  NSString *sceneName =
      [self.textFieldSceneName.text stringByTrimmingCharactersInSet:charSet];
  if ([sceneName length] == 0) {
    [self.view
        makeToast:@"请输入场景名称"
         duration:1.f
         position:[NSValue
                      valueWithCGPoint:CGPointMake(
                                           self.view.frame.size.width / 2,
                                           self.view.frame.size.height - 40)]];
    self.textFieldSceneName.text = @"";  //去除可能的空格或换行
    [self.textFieldSceneName performSelector:@selector(becomeFirstResponder)
                                  withObject:nil
                                  afterDelay:1.f];
    return NO;
  }
  if (self.detailList.count == 0) {
    [self.view
        makeToast:@"请先添加一条操作"
         duration:1.f
         position:[NSValue
                      valueWithCGPoint:CGPointMake(
                                           self.view.frame.size.width / 2,
                                           self.view.frame.size.height - 40)]];
    [self performSelector:@selector(addScene:) withObject:nil afterDelay:1.f];
    return NO;
  }
  self.sceneName = sceneName;
  return YES;
}
@end
