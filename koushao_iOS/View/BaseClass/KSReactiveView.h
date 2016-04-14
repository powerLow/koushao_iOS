//
//  KSReactiveView.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/15.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KSReactiveView <NSObject>


- (void)bindViewModel:(id)viewModel;

@end
