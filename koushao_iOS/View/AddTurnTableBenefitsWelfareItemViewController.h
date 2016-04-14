//
//  AddTurnTableBenefitsWelfareItemViewController.h
//  koushao_iOS
//
//  Created by 陈奇 on 15/11/4.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSViewController.h"
#import "WelfareItem.h"
#import "KSChooseTicketBenefitsGrantMethodViewController.h"

@protocol AddTurnTableBenefitsWelfareItemViewControllerDelegate <NSObject>
@required
- (void)onBenefitsWelfareItemAdded:(WelfareItem*)welfareItem;
- (void)onBenefitsWelfareItemUpdated;
@optional
@end
@interface AddTurnTableBenefitsWelfareItemViewController : KSViewController<UITableViewDataSource,UITableViewDelegate,KSChooseTicketBenefitsGrantMethodViewControllerDelegate>
@property(nonatomic,strong)WelfareItem* welfareItem;
@property(nonatomic,strong)id<AddTurnTableBenefitsWelfareItemViewControllerDelegate>delegate;
@end
