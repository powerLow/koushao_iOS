//
//  KSActivityAdminListViewModel.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/18.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSRefreshTableViewModel.h"
#import "KSActivityAdminItemViewModel.h"

@interface KSActivityAdminListViewModel : KSRefreshTableViewModel

@property(nonatomic, strong, readonly) RACCommand *didClickItemEditBtn;
@property(nonatomic, strong, readonly) RACCommand *didClickItemDeleteBtn;



@end
