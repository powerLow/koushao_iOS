//
//  KSDrawMoneyViewController.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/30.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSViewController.h"

@interface KSDrawMoneyViewController : KSViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property(nonatomic, strong) NSNumber *currentMoney;
@end
