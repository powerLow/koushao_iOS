//
//  KSMyMoneyInfoViewModel.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/22.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSTableViewModel.h"
#import "KSDrawMoneyViewModel.h"

@interface KSMyMoneyInfoViewModel : KSTableViewModel

@property(nonatomic, strong, readonly) RACCommand *didDrawMoneyBtnClick;

@property(nonatomic, strong, readonly) NSArray *datas;

- (NSArray *)dataSourceWithDatas:(NSArray *)datas;

//UI上是否有向右箭头,因为要控件对齐,所以只能自己添加
@property (nonatomic, assign, readonly) BOOL has_arrow;

//--------应该是新建一个cell model,偷懒
//标题
@property(nonatomic, copy, readonly) NSString *labelTitle;
//访问次数
@property(nonatomic, strong, readonly) NSNumber *count;
//单位
@property(nonatomic, copy, readonly) NSString *unit;
//--------


@end
