//
//  AddEnlistFeeItemViewController.h
//  koushao_iOS
//
//  Created by 陈奇 on 15/11/3.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSViewController.h"
#import "EnlistFeeItem.h"
@protocol AddEnlistFeeItemViewControllerDelegate <NSObject>
@required
- (void)onEnlistFeeitemAdded:(EnlistFeeItem*)enlistFeeItem;
- (void)onEnlistFeeitemUpdated;
@optional
@end

@interface AddEnlistFeeItemViewController : KSViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,assign)NSInteger type;
@property(nonatomic,strong)EnlistFeeItem* enlistFeeItem;
@property(nonatomic,strong)id<AddEnlistFeeItemViewControllerDelegate>delegate;
@end
