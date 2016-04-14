//
//  MapSelectNavigationController.m
//  koushao_iOS
//
//  Created by 陈奇 on 15/11/25.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "MapSelectNavigationController.h"
#import "MapSelectViewController.h"
@interface MapSelectNavigationController ()
@property(nonatomic,strong)MapSelectViewController *mapSelectViewController;
@end
@implementation MapSelectNavigationController
-(void)viewDidLoad
{
    [super viewDidLoad];
    _mapSelectViewController=[[MapSelectViewController alloc]init];
    _mapSelectViewController.title=@"地图选点";
    [self pushViewController:_mapSelectViewController animated:YES];
}
@end
