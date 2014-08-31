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

@interface AddSenceViewController ()<UITableViewDelegate, UITableViewDataSource,
                                     UITextFieldDelegate>
- (IBAction)back:(id)sender;
@property(strong, nonatomic) IBOutlet UITableView *tableViewOfSceneList;
@property(strong, nonatomic) IBOutlet UITextField *textFieldSceneName;
@property(strong, nonatomic) IBOutlet SceneAddView *viewOfAddScene;
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
  self.tableViewOfSceneList.dataSource = self;
  self.tableViewOfSceneList.delegate = self;
  self.textFieldSceneName.delegate = self;
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
  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellId = @"SceneAddListCell";
  SceneAddListCell *listCell = (SceneAddListCell *)
      [self.tableViewOfSceneList dequeueReusableCellWithIdentifier:CellId];
  UILongPressGestureRecognizer *longPressGesture =
      [[UILongPressGestureRecognizer alloc]
          initWithTarget:self
                  action:@selector(handlerLongPress:)];
  longPressGesture.minimumPressDuration = 0.5;
  [listCell addGestureRecognizer:longPressGesture];
  return listCell;
}

#pragma mark - SceneAddListCellHandler
- (void)handlerLongPress:(UILongPressGestureRecognizer *)gestureRecognizer {
  CGPoint p = [gestureRecognizer locationInView:self.tableViewOfSceneList];
  NSIndexPath *indexPath = [self.tableViewOfSceneList indexPathForRowAtPoint:p];
  if (indexPath && gestureRecognizer.state == UIGestureRecognizerStateBegan) {
    NSLog(@"indexPath is %d", indexPath.row);
  }
}

- (void)actionSheet:(UIActionSheet *)actionSheet
    clickedButtonAtIndex:(NSInteger)buttonIndex {
  NSLog(@"index is %d", buttonIndex);
}

#pragma mark - 场景添加视图显示和消失
- (void)addScene:(id)sender {
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

- (IBAction)back:(id)sender {
  [self dismissViewControllerAnimated:YES completion:^{}];
}
- (IBAction)save:(id)sender {
}
@end
