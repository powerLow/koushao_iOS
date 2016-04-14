//
//  KSQuestionReplyItemViewModel.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/23.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSViewModel.h"
#import "KSQuestionListModel.h"

@interface KSQuestionReplyItemViewModel : KSViewModel

@property(nonatomic, assign) CGFloat cellHeight;
@property(nonatomic, strong) KSQuestionListItemModel *itemModel;

@end
