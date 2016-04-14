//
//  KSPopMenuItem.h
//  koushao
//
//  Created by 廖哲琦 on 15-3-30.
//  Copyright (c) 2015年 Liao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Foundation/Foundation.h>

#define kCDMenuTableViewWidth 200
#define kCDMenuTableViewSapcing 7

#define kCDMenuItemViewHeight 40
#define kCDMenuItemViewImageSapcing 15
#define kCDSeparatorLineImageViewHeight 0.5

@interface KSPopMenuItem : NSObject

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) NSString *title;

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title;

@end
