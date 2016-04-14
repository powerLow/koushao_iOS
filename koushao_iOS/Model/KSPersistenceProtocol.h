//
//  KSPersistenceProtocol.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/13.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTKKeyValueStore.h"
@protocol KSPersistenceProtocol <NSObject>

@required
- (BOOL)ks_saveOrUpdate;
- (BOOL)ks_delete;
@optional
+ (instancetype)ks_fetchById:(NSString*)key;
+ (instancetype)ks_fetch;
@end
