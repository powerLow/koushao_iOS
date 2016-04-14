//
//  KSUtil.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/12.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSUtil.h"
#import "KSStartpageViewModel.h"
#import "KSViewModelServices.h"
#import "KSClientApi.h"
#import "APService.h"

@implementation KSUtil

+(YTKKeyValueStore*)getDatabase {
    return [[KSMemoryCache sharedInstance] objectForKey:@"database"];
}
+(YTKKeyValueStore*)getUserDB {
    return [[KSMemoryCache sharedInstance] objectForKey:@"userdb"];
}
+(void)cacheCurrentActivity:(KSActivity*)activity {
    if (activity != nil) {
        [[KSMemoryCache sharedInstance] setObject:activity forKey:@"curActivity"];
    }
}
+(id)getCurrentActivity {
    return [[KSMemoryCache sharedInstance] objectForKey:@"curActivity"];
}

+(NSString*)StringTimeFromNumber:(NSNumber*)time withSeconds:(BOOL)needSec{
    NSDate* signTime = [NSDate dateWithTimeIntervalSince1970:[time unsignedIntegerValue]];
    NSDateFormatter *ft = [NSDateFormatter new];
    if (needSec) {
        ft.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }else{
        ft.dateFormat = @"yyyy-MM-dd HH:mm";
    }
    
    NSString *strsignTime = [ft stringFromDate:signTime];
    return [strsignTime copy];
}

+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}
+(CGFloat)textHeight:(NSString *)text withFont:(UIFont *)font targetWidth:(CGFloat)width
{
    
    NSString *str = text;
    CGSize size = CGSizeMake(width,10000);
    CGRect labelRect = [str boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)  attributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName] context:nil];
    return labelRect.size.height;
}

+(void)loadItem:(NSURL *)url withSuccessBlock:(void (^)(ALAsset *asset))successBlock andFailureBlock:(void (^)(void))failureBlock {
    ALAssetsLibrary *assetsLibrary=[[ALAssetsLibrary alloc]init];
    [assetsLibrary assetForURL:url
                   resultBlock:^(ALAsset *asset)
     {
         if (asset){
             
             successBlock(asset);
         }
         else {
             [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupPhotoStream
                                          usingBlock:^(ALAssetsGroup *group, BOOL *stop)
              {
                  [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                      if([result.defaultRepresentation.url isEqual:url])
                      {
                          successBlock(asset);
                          *stop = YES;
                      }
                  }];
              }
                                        failureBlock:^(NSError *error)
              {
                  NSLog(@"Error: Cannot load asset from photo stream - %@", [error localizedDescription]);
                  failureBlock();
                  
              }];
         }
     }
                  failureBlock:^(NSError *error)
     {
         NSLog(@"Error: Cannot load asset - %@", [error localizedDescription]);
         failureBlock();
     }
     ];
    
}


//获取UUID字符串
+ (NSString*) getUUIDString
{
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    NSString *uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return uuidString;
}
+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}
+(CGFloat)textWidth:(NSString *)text withFont:(UIFont *)font{
    
    NSString *str = text;
    CGSize size = CGSizeMake(MAXFLOAT,40);
    CGRect labelRect = [str boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)  attributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName] context:nil];
    return labelRect.size.width;
}

//根据沙盒图片名称获取沙盒内的图片
+(UIImage*) getImageFileWithLocalName:(NSString*)filePath
{
    NSError* err = [[NSError alloc] init];
    NSData* data = [[NSData alloc] initWithContentsOfFile:filePath
                                                  options:NSDataReadingMapped
                                                    error:&err];
    UIImage* img = nil;
    if(data != nil)
    {
        img = [[UIImage alloc] initWithData:data];
    }
    else
    {
        NSLog(@"getImageFileWithName error code : %ld",(long)[err code]);
    }
    return img;
}


+(void)filterError:(NSError*)error params:(id)params {
    NSLog(@"集中处理错误 = %@",error);
    NSString *msg = error.userInfo[@"tips"];
    switch (error.code) {
        case KSInstantSuccess: {
            
            break;
        }
        case KSInstantErrorUsernameIsMissing:
        {
            KSError(@"用户名不能为空");
            break;
        }
        case KSInstantErrorPasswordIsMissing:
        {
            KSError(@"密码不能为空");
            break;
        }
        case KSInstantErrorAccessDenied: {
            KSError(@"服务器内部错误");
            break;
        }
        case KSInstantErrorInvalidResponse: {
            KSError(msg);
            break;
        }
        case KSInstantErrorSubAccountHasBeenTaken: {
            KSError(@"该账号已经存在!");
            break;
        }
        case KSInstantErrorTokenHasNotFound:
        case KSInstantErrorTokenHasExpired: {
            id<KSViewModelServices> service = (id<KSViewModelServices>)params;
            KSStartpageViewModel *viewModel = [[KSStartpageViewModel alloc] initWithServices:service params:nil];
            [APService setAlias:@"" callbackSelector:nil object:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                [service resetRootViewModel:viewModel];
            });
            break;
        }
        default: {
            if (msg == nil) {
                KSError(@"未知错误!");
            }else{
                KSError(msg);
            }
            
            break;
        }
    }
    
}
#pragma mark - GCD
+(void)runInMainQueue:(void (^)())queue{
    dispatch_async(dispatch_get_main_queue(), queue);
}

+(void)runInGlobalQueue:(void (^)())queue{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), queue);
}

+(void)runAfterSecs:(float)secs block:(void (^)())block{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs*NSEC_PER_SEC), dispatch_get_main_queue(), block);
}
@end

@implementation NSString (Util)

- (BOOL)isExist {
    return self && ![self isEqualToString:@""];
}

- (NSString *)firstLetter {
    return [[self substringToIndex:1] uppercaseString];
}

- (BOOL)isMarkdown {
    if (![self isExist]) return NO;
    
    NSArray *markdownExtensions = @[ @".md", @".mkdn", @".mdwn", @".mdown", @".markdown", @".mkd", @".mkdown", @".ron" ];
    for (NSString *extension in markdownExtensions) {
        if ([self.lowercaseString hasSuffix:extension]) return YES;
    }
    
    return NO;
}

@end

@implementation UIColor (Util)

- (UIImage *)color2Image {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [self CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)color2ImageSized:(CGSize)size {
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [self CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end

