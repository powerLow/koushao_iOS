//
//  KSAwardConfirmResultModel.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/17.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
{
    "result": {
        "company": "快递",
        "hash": "52ec083a-8855-11e5-b400-0242c0a82a0d",
        "id": "FL6231447321961967",
        "nu": "123456"
    },
    "error": {
        "errorno": 0,
        "msg": "success"
    }
}
*/
@interface KSAwardConfirmResultModel : NSObject

@property (nonatomic,copy,readonly) NSString* id;
@property (nonatomic,copy,readonly) NSString* company;
@property (nonatomic,copy,readonly) NSString* nu;

@end
