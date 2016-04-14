//
//  ChooseCoverStyleViewController.h
//  koushao_iOS
//
//  Created by 陈奇 on 15/10/30.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSViewController.h"
#import "RSKImageCropViewController.h"

@interface ChooseCoverStyleViewController : KSViewController<UITableViewDataSource,UITableViewDelegate,RSKImageCropViewControllerDataSource,RSKImageCropViewControllerDelegate>
@property(nonatomic,assign)BOOL isModify;
@end
