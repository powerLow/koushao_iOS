//
//  KSUser.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/13.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KSPersistenceProtocol.h"
//子账户的权限
@interface KSUserAttr : NSObject

@property (nonatomic, strong, readonly) NSNumber *question;
@property (nonatomic, strong, readonly) NSNumber *signin;
@property (nonatomic, strong, readonly) NSNumber *welfare;
@end

@interface KSUser : NSObject <KSPersistenceProtocol>

@property (nonatomic, copy, readwrite) NSString *username;
@property (nonatomic, copy, readwrite) NSString *nickname;
@property (nonatomic, copy, readonly) NSString *mobilePhone;
@property (nonatomic, copy, readonly) NSString *password;
@property (nonatomic, strong, readwrite) NSNumber *gender;
@property (nonatomic, copy, readonly) NSString *sessionToken;
@property (nonatomic, copy, readwrite) NSString *avatar;
@property (nonatomic, strong, readonly) KSUserAttr *attr;
@property (nonatomic, strong, readonly) NSDictionary *auth;

@property (nonatomic, assign, readonly) BOOL isSubAccount;
@property (nonatomic, assign, readonly) BOOL isnew;

@property (nonatomic, assign, readwrite) BOOL isLogin;
+ (instancetype)currentUser;
+ (instancetype)sharedInstance;

+ (void)cacheUser:(KSUser*)user;

@end
