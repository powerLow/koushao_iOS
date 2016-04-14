//
//  KSSignRecordListItemViewModel.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/10.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSViewModel.h"
#import "KSSigninListModel.h"

@interface KSSignRecordListItemViewModel : KSViewModel

@property(nonatomic, assign) CGFloat cellHeight;
@property(nonatomic, strong) KSSigninListItemModel *itemModel;
@property(nonatomic, assign) BOOL isSignin;
@property(nonatomic, assign) BOOL showTime;

@end
