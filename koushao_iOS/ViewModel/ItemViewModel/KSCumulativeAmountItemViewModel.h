//
//  KSCumulativeAmountItemViewModel.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/12/7.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSViewModel.h"
#import "KSMoneyRecordListModel.h"
@interface KSCumulativeAmountItemViewModel : KSViewModel

@property(nonatomic, assign) CGFloat cellHeight;
@property(nonatomic, strong) KSMoneyRecordItemModel *itemModel;

@end
