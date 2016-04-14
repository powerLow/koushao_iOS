//
//  KSMemoryCache.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/13.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSMemoryCache.h"

static KSMemoryCache *_memoryCache = nil;

@interface KSMemoryCache ()

@property (nonatomic, strong) NSMutableDictionary *dictionary;

@end

@implementation KSMemoryCache

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _memoryCache = [[KSMemoryCache alloc] init];
    });
    return _memoryCache;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _dictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (id)objectForKey:(NSString *)key {
    return [self.dictionary objectForKey:key];
}

- (void)setObject:(id)object forKey:(NSString *)key {
    if (object != nil) {
        [self.dictionary setObject:object forKey:key];
    }
}

- (void)removeObjectForKey:(NSString *)key {
    [self.dictionary removeObjectForKey:key];
}
@end
