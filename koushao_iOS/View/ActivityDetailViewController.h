//
//  ActivityDetailViewController.h
//  koushao_iOS
//
//  Created by 陈奇 on 15/10/29.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSViewController.h"

@interface ActivityDetailViewController : KSViewController<UIImagePickerControllerDelegate,UITableViewDataSource,UIScrollViewDelegate,UITableViewDelegate,UINavigationControllerDelegate>
@property(nonatomic,assign)BOOL isModify;
@end
