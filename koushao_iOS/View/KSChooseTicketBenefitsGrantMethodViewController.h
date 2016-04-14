//
//  KSChooseTicketBenefitsGrantMethodViewController.h
//  koushao_iOS
//
//  Created by 陈奇 on 15/12/9.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSViewController.h"
@protocol KSChooseTicketBenefitsGrantMethodViewControllerDelegate <NSObject>
@required
- (void)onDeliverySelectFinished:(NSInteger)delivery;
@optional
@end
@interface KSChooseTicketBenefitsGrantMethodViewController : KSViewController<UITableViewDelegate,UITableViewDataSource>
-(instancetype)initWithType:(NSUInteger)type;
@property(nonatomic,strong)id<KSChooseTicketBenefitsGrantMethodViewControllerDelegate> delegate;
@end
