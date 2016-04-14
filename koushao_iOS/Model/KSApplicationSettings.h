//
//  KSApplicationSettings.h
//  koushao_iOS
//
//  Created by 陈奇 on 15/11/12.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSApplicationSettings : NSObject<KSPersistenceProtocol>
@property(nonatomic,assign)NSInteger getImageUploadTokenTime; //上次获取key的时间戳
@property(nonatomic,copy)NSString* imageUploadToken; //上次保存的上传图片的key
+ (KSApplicationSettings *)sharedManager;
@end
