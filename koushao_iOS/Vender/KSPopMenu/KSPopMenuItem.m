//
//  KSPopMenuItem.m
//  koushao
//
//  Created by 廖哲琦 on 15-3-30.
//  Copyright (c) 2015年 Liao. All rights reserved.
//

#import "KSPopMenuItem.h"

@implementation KSPopMenuItem

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title {
    self = [super init];
    if (self) {
        self.image = image;
        self.title = title;
    }
    return self;
}

@end