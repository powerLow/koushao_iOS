//
//  TimeLocationViewController.h
//  koushao_iOS
//
//  Created by 陈奇 on 15/10/28.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSViewController.h"

@interface TimeLocationViewController : KSViewController<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UITextViewDelegate>
@property(nonatomic,assign)BOOL isModify;
@end
