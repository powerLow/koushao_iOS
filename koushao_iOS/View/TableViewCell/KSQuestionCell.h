//
//  KSQuestionCell.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/23.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSQuestionReplyItemViewModel.h"

@interface KSQuestionCell : UITableViewCell<KSReactiveView>

typedef void (^BtnClickedBlock) (id sender);


@property (nonatomic, copy) BtnClickedBlock commentClickedBlock;
@property (nonatomic, copy) BtnClickedBlock deleteQuestionClickedBlock;
@property (nonatomic, copy) BtnClickedBlock deleteReplyClickedBlock;

@property (nonatomic,strong,readonly) KSQuestionReplyItemViewModel* viewModel;

- (void)hiddenBtns;

@end
