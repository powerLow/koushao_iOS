//
//  KSActivityAdminManagerViewModel.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/26.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSViewModel.h"
#import "KSAddSubAccountResultModel.h"
#import "KSActivityAdminListViewModel.h"

@interface KSActivityAdminManagerViewModel : KSViewModel

@property(nonatomic, strong, readonly) RACCommand *didClickLookBtn;
@property(nonatomic, strong, readonly) RACCommand *didClickEditBtn;
@property(nonatomic, strong, readonly) RACCommand *didClickAddBtn;
@property(nonatomic, strong, readonly) KSAddSubAccountResultModel *resultModel;
@property(nonatomic, strong, readonly) KSActivityAdminItemViewModel *item;
@end
