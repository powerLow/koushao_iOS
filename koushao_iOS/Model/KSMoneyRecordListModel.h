//
//  KSMoneyRecordListModel.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/12/5.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSMoneyRecordItemModel : NSObject
@property (nonatomic,strong,readonly) NSNumber* mid;
//累计获得（卖票收入）
@property (nonatomic,copy,readonly) NSString* title;
@property (nonatomic,strong,readonly) NSNumber* money;
@property (nonatomic,strong,readonly) NSNumber* time;

//
@property (nonatomic,copy,readonly) NSString* receiver;
@property (nonatomic,strong,readonly) NSNumber* status;

@end


@interface KSMoneyRecordListModel : NSObject

@property (nonatomic,strong,readonly) NSNumber* record_type;
@property (nonatomic,strong,readonly) NSArray* list;

@end
