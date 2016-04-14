//
//  KSAwardSendItemViewModel.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/16.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSViewModel.h"
#import "KSAwardItemModel.h"

@interface KSAwardItemViewModel : KSViewModel

@property(nonatomic, assign) CGFloat cellHeight;
@property(nonatomic, strong, readonly) KSAwardItemModel *itemModel;
@property(nonatomic, assign) BOOL isSend;//是否已经发放了
@property(nonatomic, assign) BOOL showTime;

@end
