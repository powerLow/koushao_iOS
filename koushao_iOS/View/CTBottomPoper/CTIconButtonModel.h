//
//  CTIconButtonModel.h
//  koushao_iOS
//
//  Created by 陈奇 on 15/12/24.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTIconButtonModel : NSObject
@property(nonatomic,copy)NSString* buttonText;
@property(nonatomic,copy)NSString* buttonIcon;
-(id)initWithText:(NSString*)text andIcon:(NSString*)icon;
+(CTIconButtonModel*)buttonWithText:(NSString*)text andIcon:(NSString*)icon;
@end
