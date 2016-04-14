//
//  ImageUploader.h
//  koushao_iOS
//
//  Created by 陈奇 on 15/11/12.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageUploader : NSObject
@property(nonatomic,copy)NSString* imagePath;
@property(nonatomic,assign)NSInteger action;
//action，1为上传封面照，2为上传活动编辑内容里的照片，3为上传头像 4上传身份证 5.详情图片
-(void)beginUploadImageWithSuccessBlock:(void (^)(NSString *url))successBlock andFailureBlock:(void (^)(void))failureBlock;
@end
