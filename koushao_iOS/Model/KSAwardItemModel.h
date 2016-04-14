//
//  KSAwardItemModel.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/16.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 {
 "result": [
 {
 "id": "FL6231447321961967",
 "welfare_name": "暴力熊11",
 "receiver": "13141271541"
 },
 {
 "id": "FL6001447317262534",
 "welfare_name": "暴力熊11",
 "receiver": "13216708954"
 }
 ],
 "error": {
 "errorno": 0,
 "msg": "success"
 }
 }
 */
@interface KSAwardItemModel : NSObject

@property (nonatomic,strong,readonly) NSNumber* wid;             //id
@property (nonatomic,copy,readonly) NSString* id;                //编号
@property (nonatomic,copy,readonly) NSString* welfare_name;      //奖品标题
@property (nonatomic,copy,readonly) NSString* receiver;          //接收者
@property (nonatomic,strong,readonly) NSNumber* time;            //接收时间 or 发放时间
@property (nonatomic,copy,readonly) NSString* admin;             //发放操作者

@end
