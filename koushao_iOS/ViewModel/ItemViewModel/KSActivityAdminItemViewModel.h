//
//  KSActivityAdminItemViewModel.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/18.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSViewModel.h"
#import "KSActivityAdminListModel.h"

@interface KSActivityAdminItemViewModel : KSViewModel

@property(nonatomic, assign) CGFloat cellHeight;
@property(nonatomic, strong) KSActivityAdminItemModel *itemModel;

@end
