//
//  KSUtil.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/12.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
@class KSActivity;
@interface KSUtil : NSObject

//程序数据库
+(YTKKeyValueStore*)getDatabase;
//每个登陆用户自己的数据库
+(YTKKeyValueStore*)getUserDB;

+(void)cacheCurrentActivity:(KSActivity*)activity;
+(id)getCurrentActivity;

+(NSString*)StringTimeFromNumber:(NSNumber*)time withSeconds:(BOOL)needSec;

+(void)filterError:(NSError*)error params:(id)params;

+ (UIColor *) colorWithHexString: (NSString *)color;
+ (NSString*) getUUIDString;

//根据AssetsURL来加载图片
+ (void)loadItem:(NSURL *)url withSuccessBlock:(void (^)(ALAsset *asset))successBlock andFailureBlock:(void (^)(void))failureBlock;

+(CGFloat)textHeight:(NSString*) text withFont:(UIFont *)font targetWidth:(CGFloat)width;
+(CGFloat)textWidth:(NSString *)text withFont:(UIFont *)font;
+(UIImage*) getImageFileWithLocalName:(NSString*)filePath;
+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate;

#pragma mark - GCD
+(void)runInMainQueue:(void (^)())queue;

+(void)runInGlobalQueue:(void (^)())queue;

+(void)runAfterSecs:(float)secs block:(void (^)())block;

@end

@interface NSString (Util)

- (BOOL)isExist;

- (NSString *)firstLetter;

- (BOOL)isMarkdown;

@end

@interface UIColor (Util)

// Generating a new image by the color.
//
// Returns a new image.
- (UIImage *)color2Image;

- (UIImage *)color2ImageSized:(CGSize)size;

@end