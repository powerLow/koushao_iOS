//
//  KSMyDataViewModel.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/15.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSTableViewModel.h"
#import "KSMyinfo.h"

@interface KSMyDataViewModel : KSTableViewModel


@property(nonatomic, strong, readonly) NSArray *datas;

- (NSArray *)dataSourceWithDatas:(NSArray *)datas;


//--------应该是新建一个cell model,偷懒
//标题
@property(nonatomic, copy, readonly) NSString *labelTitle;
//访问次数
@property(nonatomic, strong, readonly) NSNumber *count;
//单位
@property(nonatomic, copy, readonly) NSString *unit;
//--------



@end
