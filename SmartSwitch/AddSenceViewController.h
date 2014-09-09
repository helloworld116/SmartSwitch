//
//  AddSenceViewController.h
//  SmartSwitch
//
//  Created by sdzg on 14-8-6.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Scene.h"
#import "SceneDetail.h"

@interface AddSenceViewController : UIViewController
@property(nonatomic, strong) Scene *scene;
@property(nonatomic, assign) int
    type;  //从不同页面跳转过来的方式，1代表从左滑过来，2代表从添加场景过来，3代表从修改过来
@end
