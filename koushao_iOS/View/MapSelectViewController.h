//
//  MapSelectViewController.h
//  koushao_iOS
//
//  Created by 陈奇 on 15/10/31.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//
#import "KSViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
@interface MapSelectViewController : KSViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,MAMapViewDelegate,AMapSearchDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate,UISearchDisplayDelegate>
@end
