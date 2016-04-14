//
//  HorizonalTagFlowLayout.m
//  koushao_iOS
//
//  Created by 陈奇 on 15/11/5.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "HorizonalTagFlowLayout.h"
CGFloat const colCount = 3;
@interface HorizonalTagFlowLayout ()

@end

@implementation HorizonalTagFlowLayout
- (void)prepareLayout{
    [super prepareLayout];
    NSLog(@"prepareLayout");
    _rowNumber=1;
    _attributeDict = [NSMutableDictionary dictionary];
    self.delegate = (id<UICollectionViewDelegateFlowLayout>)self.collectionView.delegate;
    //获取cell的总个数
    _cellCount = [self.collectionView numberOfItemsInSection:0];
    if (_cellCount == 0) {
        return;
    }
    for (int i = 0; i < _cellCount; i++) {
        [self layoutItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
    }
    
}

- (void)layoutItemAtIndexPath:(NSIndexPath *)indexPath{
    //通过协议得到cell的间隙
    NSLog(@"layoutItemAtIndexPath");
    UIEdgeInsets edgeInsets = [self.delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:indexPath.row];
    CGSize itemSize = [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
    CGRect frame;
    CGFloat orignX;
    CGFloat orignY;
    if(indexPath.row==0)
    {
        frame = CGRectMake(edgeInsets.left,edgeInsets.top, itemSize.width, itemSize.height);
    }
    else
    {
        NSIndexPath *previousIndexPath=[NSIndexPath indexPathForRow:indexPath.row-1 inSection:0];
         NSArray *arr=[_attributeDict allKeysForObject:previousIndexPath];
        CGRect previousItemFrame=CGRectFromString([arr objectAtIndex:0]);
        if(itemSize.width+edgeInsets.left+previousItemFrame.origin.x+previousItemFrame.size.width>[self collectionViewContentSize].width)
        {
            _rowNumber++;
            orignX=edgeInsets.left;
            orignY=previousItemFrame.origin.y+previousItemFrame.size.height+edgeInsets.top;
            frame=CGRectMake(orignX, orignY, itemSize.width, itemSize.height);
        }
        else
        {
            orignX=previousItemFrame.origin.x+previousItemFrame.size.width+edgeInsets.left;
            orignY=previousItemFrame.origin.y;
            frame=CGRectMake(orignX, orignY, itemSize.width, itemSize.height);
        }
    }
    [_attributeDict setObject:indexPath forKey:NSStringFromCGRect(frame)];
}

- (NSArray *)indexPathsOfItem:(CGRect)rect{
    NSLog(@"indexPathsOfItem");
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *rectStr in _attributeDict) {
        CGRect cellRect = CGRectFromString(rectStr);
        if (CGRectIntersectsRect(cellRect, rect)) {
            NSIndexPath *indexPath = _attributeDict[rectStr];
            [array addObject:indexPath];
        }
    }
    return array;
}


- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSLog(@"layoutAttributesForElementsInRect");
    NSMutableArray *muArr = [NSMutableArray array];
    NSArray *indexPaths = [self indexPathsOfItem:rect];
    for (NSIndexPath *indexPath in indexPaths) {
        UICollectionViewLayoutAttributes *attribute = [self layoutAttributesForItemAtIndexPath:indexPath];
        [muArr addObject:attribute];
    }
    return muArr;
}

-(UICollectionViewLayoutAttributes*)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    for (NSString *rectStr in _attributeDict) {
        if (_attributeDict[rectStr]==indexPath) {
            attributes.frame = CGRectFromString(rectStr);
        }
    }
    return attributes;
}

- (CGSize)collectionViewContentSize{
    NSLog(@"collectionViewContentSize");
    CGSize size = self.collectionView.frame.size;
    size.height = 200;
    return size;
}
@end
