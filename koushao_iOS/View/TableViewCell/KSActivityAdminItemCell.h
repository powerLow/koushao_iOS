//
//  KSActivityAdminItemCell.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/19.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "KSActivityAdminItemViewModel.h"
@interface KSActivityAdminItemCell : SWTableViewCell<KSReactiveView>

@property (nonatomic,strong,readonly) KSActivityAdminItemViewModel* viewModel;


@end