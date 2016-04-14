//
//  KSWithdrawMoneyItemViewModel.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/12/5.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSViewModel.h"
#import "KSMoneyRecordListModel.h"
@interface KSWithdrawMoneyItemViewModel : KSViewModel
@property(nonatomic, assign) CGFloat cellHeight;
@property(nonatomic, strong) KSMoneyRecordItemModel *itemModel;
@end
