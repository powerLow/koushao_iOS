//
//  ImageUploadProgress.h
//  koushao_iOS
//
//  Created by 陈奇 on 15/11/16.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageUploadProgress : NSObject
@property(nonatomic,copy)NSString* filePath;
@property(nonatomic,assign)float percent;
@end
