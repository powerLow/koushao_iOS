//
//  HorizonalTagFlowLayout.h
//  koushao_iOS
//
//  Created by 陈奇 on 15/11/5.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HorizonalTagFlowLayout : UICollectionViewFlowLayout
@property(nonatomic,assign)id<UICollectionViewDelegateFlowLayout> delegate;
@property(nonatomic,assign)NSInteger cellCount;//cell的个数
@property(nonatomic,strong)NSMutableDictionary *attributeDict;//cell的位置信息
@property(nonatomic,assign,readonly)NSInteger rowNumber;
@end
