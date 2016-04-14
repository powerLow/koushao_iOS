//
//  KSCreateActivityViewNavController.m
//  koushao_iOS
//
//  Created by 陈奇 on 15/10/28.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSCreateActivityViewNavController.h"
#import "TimeLocationViewController.h"

@interface KSCreateActivityViewNavController ()
@property(nonatomic,strong)TimeLocationViewController *timeLocationViewController;
@end

@implementation KSCreateActivityViewNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.shadowImage=[UIImage new];
    [self initView];
    if(!self.startViewController)
    {
        self.timeLocationViewController=[[TimeLocationViewController alloc]init];
        self.timeLocationViewController.navigationItem.title=@"活动基本信息";
        self.timeLocationViewController.view.backgroundColor=[UIColor whiteColor];
        [self pushViewController:self.timeLocationViewController animated:YES];
    }
    else
    {
        [self pushViewController:self.startViewController animated:YES];
    }
}
-(void)initView
{
    //设置NavigationBar的相关属性
    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)forBarMetrics:UIBarMetricsDefault];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
