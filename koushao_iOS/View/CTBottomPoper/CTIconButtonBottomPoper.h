//
//  CTIconButtonBottomPoper.h
//  koushao_iOS
//
//  Created by 陈奇 on 15/12/24.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "CTBottomPoper.h"
#import "CTIconButtonModel.h"

@interface CTIconButtonBottomPoper : CTBottomPoper
@property(nonatomic,copy)NSString* title;
@property(nonatomic,assign)BOOL showCancelButton;
@property(nonatomic,copy) void (^onButtonItemClicked)(NSIndexPath* indexPath);
-(id)initWithButtons:(NSArray*)buttonsArray;
@end
