//
//  CTIconButton.h
//  koushao_iOS
//
//  Created by 陈奇 on 15/12/25.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTIconButtonModel.h"

@interface CTIconButton : UIButton
-(id)initWithButtonModel:(CTIconButtonModel*)buttonModel;
@property(nonatomic,strong)NSIndexPath* indexPath;
@end
