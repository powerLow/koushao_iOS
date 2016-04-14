//
//  ImageUploader.m
//  koushao_iOS
//
//  Created by 陈奇 on 15/11/12.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "ImageUploader.h"
#import <QiniuSDK.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "KSGetImageUploadTokenResult.h"
#import "KSApplicationSettings.h"
#import "ImageUploadProgress.h"
#import "KSActivityCreatManager.h"

@interface ImageUploader ()
@property(nonatomic,strong)  ALAssetsLibrary *assetsLibrary;
@property(nonatomic,strong) KSApplicationSettings* appSettings;
@property(nonatomic,strong) KSActivityCreatManager* activityManager;
@end
@implementation ImageUploader
-(void)beginUploadImageWithSuccessBlock:(void (^)(NSString *url))successBlock andFailureBlock:(void (^)(void))failureBlock
{
    if(!self.appSettings)
        self.appSettings=[KSApplicationSettings sharedManager];
    if(!self.activityManager)
        self.activityManager=[KSActivityCreatManager sharedManager];
    NSString* token=self.appSettings.imageUploadToken;
    NSInteger lastGetTokenTime=self.appSettings.getImageUploadTokenTime;
    NSDate* dateNow= [NSDate dateWithTimeIntervalSinceNow:0];
    //这里需要获取新的token
    if(!token||([dateNow timeIntervalSince1970]-lastGetTokenTime)/1000>3600)
    {
        [[KSClientApi getImageUploadToken]subscribeNext:^(KSGetImageUploadTokenResult* x) {
            NSDate* dateNow= [NSDate dateWithTimeIntervalSinceNow:0];
            self.appSettings.imageUploadToken=x.token;
            self.appSettings.getImageUploadTokenTime=[dateNow timeIntervalSince1970];
            [self uploadImageWithToken:x.token WithSuccessBlock:successBlock andFailureBlock:failureBlock];
        } error:^(NSError *error) {
            
        }];
    }
    else //不需要获取新的token
    {
        [self uploadImageWithToken:token WithSuccessBlock:successBlock andFailureBlock:failureBlock];
    }
    
}
-(void)uploadImageByAssetURLWithToken:(NSString*)token WithSuccessBlock:(void (^)(NSString *url))successBlock andFailureBlock:(void (^)(void))failureBlock Option:(QNUploadOption*)opt
{
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    [KSUtil loadItem:[NSURL URLWithString:self.imagePath ] withSuccessBlock:^(ALAsset *asset) {
        ALAssetRepresentation *rep = [asset defaultRepresentation];
        Byte *buffer = (Byte*)malloc(rep.size);
        NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:rep.size error:nil];
        NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
        [upManager putData:data key:nil token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            [self.activityManager.imageUploadProgressHashMap removeObjectForKey:self.imagePath];
            if(resp)
            {
                NSDictionary* result=[resp objectForKey:@"result"];
                if(result)
                {
                    NSString* url=[result objectForKey:@"url"];
                    successBlock(url);
                }
                else
                {
                    failureBlock();
                }
            }
            else
            {
                failureBlock();
            }
        } option:opt];
        
        
    } andFailureBlock:^{
        [self.activityManager.imageUploadProgressHashMap removeObjectForKey:self.imagePath];
        failureBlock();
        
    }];
    
    
}
-(void)uploadImageBySandBoxURLWithToken:(NSString*)token WithSuccessBlock:(void (^)(NSString *url))successBlock andFailureBlock:(void (^)(void))failureBlock Option:(QNUploadOption*)opt
{
    UIImage* image=[KSUtil getImageFileWithLocalName:[NSString stringWithFormat:@"%@/%@",LOCAL_IMAGE_DIC,[self.imagePath stringByReplacingOccurrencesOfString:KS_SANDBOX withString:@""]]];
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    [upManager putData:imageData key:nil token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        [self.activityManager.imageUploadProgressHashMap removeObjectForKey:self.imagePath];
        if(resp)
        {
            NSDictionary* result=[resp objectForKey:@"result"];
            if(result)
            {
                NSString* url=[result objectForKey:@"url"];
                successBlock(url);
            }
            else
            {
                failureBlock();
            }
        }
        else
        {
            failureBlock();
        }
    } option:opt];
    
    
}


-(void)uploadImageWithToken:(NSString*)token WithSuccessBlock:(void (^)(NSString *url))successBlock andFailureBlock:(void (^)(void))failureBlock
{
    if(self.imagePath)
    {
        
        NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
        [params setObject:[NSString stringWithFormat:@"%ld",(long)self.action] forKey:@"x:action"];
        if(self.action==5)
        {
            [params setObject:[NSString stringWithFormat:@"%ld",(long)self.activityManager.detailStyle+1] forKey:@"x:detail"];
        }
        if(self.action==1)
        {
            [params setObject:[NSString stringWithFormat:@"%ld",(long)self.activityManager.coverStyle+1] forKey:@"x:cover"];
        }
        if (self.activityManager.hashCode) {
            [params setObject:self.activityManager.hashCode forKey:@"x:hash"];
        }
        
        if([KSUser currentUser])
        {
            KSUser *user = [KSUser currentUser];
            [params setObject:user.sessionToken forKey:@"x:token"];
            [params setObject:user.username forKey:@"x:username"];
        }
        [self.activityManager.imageUploadProgressHashMap setObject:[NSNumber numberWithFloat:0.0] forKey:self.imagePath];
        
        @weakify(self)
        QNUploadOption *opt = [[QNUploadOption alloc] initWithMime:@"text/plain" progressHandler:^(NSString *key, float percent) {
            @strongify(self)
            ImageUploadProgress* imageUploadProgress=[[ImageUploadProgress alloc]init];
            imageUploadProgress.filePath=self.imagePath;
            imageUploadProgress.percent=percent;
            [self.activityManager.imageUploadProgressHashMap setObject:[NSNumber numberWithFloat:percent] forKey:self.imagePath];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_IMAGE_UPLOAD object:imageUploadProgress];
        } params:params checkCrc:YES cancellationSignal:nil];
        
        //在这里判断所上传的图片是相册里的图片还是沙盒里的图片
        if([self.imagePath hasPrefix:KS_SANDBOX])
        {
            [self uploadImageBySandBoxURLWithToken:token WithSuccessBlock:successBlock andFailureBlock:failureBlock Option:opt];
        }
        else if ([self.imagePath hasPrefix:@"assets-library://"])
        {
            [self uploadImageByAssetURLWithToken:token WithSuccessBlock:successBlock andFailureBlock:failureBlock Option:opt];
        }
    }
}

@end
