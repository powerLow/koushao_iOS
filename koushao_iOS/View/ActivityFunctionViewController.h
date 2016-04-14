//
//  ActivityFunctionViewController.h
//  koushao_iOS
//
//  Created by 陈奇 on 15/10/31.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSViewController.h"

@protocol ActivityFunctionViewControllerDelegate <NSObject>

@required
-(void)onActivityPublished;

@end
@interface ActivityFunctionViewController : KSViewController
@property(nonatomic,strong)id<ActivityFunctionViewControllerDelegate>delegate;

@end
