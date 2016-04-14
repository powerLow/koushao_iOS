//
//  BEMCheckBox+RACSignalSupport.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/18.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "BEMCheckBox.h"

@interface BEMCheckBox (RACSignalSupport)

- (RACSignal *)rac_StatueChangeSignal;
@end
