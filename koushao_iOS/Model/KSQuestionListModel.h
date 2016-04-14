//
//  KSQuestionListModel.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/23.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
{
    "result": {
        "list": [
        {
            "answer_time": 0,
            "user_avatar": "https://dn-koushao.qbox.me/avatar/16.png",
            "question": "5",
            "create_time": 1448248264,
            "user": "132****8954",
            "answer": "",
            "id": 849
        },
        {
            "answer_time": 0,
            "user_avatar": "https://dn-koushao.qbox.me/avatar/16.png",
            "question": "4",
            "create_time": 1448248248,
            "user": "132****8954",
            "answer": "",
            "id": 848
        },
                 ]
    },
    "error": {
        "errorno": 0,
        "msg": "成功"
    }
}
*/
@interface KSQuestionListItemModel : NSObject

@property (nonatomic,strong) NSNumber* answer_time;
@property (nonatomic,copy) NSString* user_avatar;
@property (nonatomic,copy) NSString* question;
@property (nonatomic,strong) NSNumber* create_time;
@property (nonatomic,copy) NSString* user;
@property (nonatomic,copy) NSString* answer;
@property (nonatomic,copy) NSString* answerer; //回答的人

@property (nonatomic,strong) NSNumber* id;
@end

@interface KSQuestionListModel : NSObject

@property (nonatomic,strong) NSArray* list;


@end
