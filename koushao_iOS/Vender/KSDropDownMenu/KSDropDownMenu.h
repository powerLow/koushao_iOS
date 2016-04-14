//
//  KSDropDownMenu.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/14.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UIKit/UIKit.h>

@interface KSIndexPath : NSObject

@property (nonatomic, assign) NSInteger column;
// 0 左边   1 右边
@property (nonatomic, assign) NSInteger leftOrRight;
// 左边行
@property (nonatomic, assign) NSInteger leftRow;
// 右边行
@property (nonatomic, assign) NSInteger row;

- (instancetype)initWithColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow row:(NSInteger)row;
+ (instancetype)indexPathWithCol:(NSInteger)col leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow row:(NSInteger)row;

@end

#pragma mark - data source protocol
@class KSDropDownMenu;

@protocol KSDropDownMenuDataSource <NSObject>

@required
- (NSInteger)menu:(KSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow;
- (NSString *)menu:(KSDropDownMenu *)menu titleForRowAtIndexPath:(KSIndexPath *)indexPath;
- (NSString *)menu:(KSDropDownMenu *)menu titleForColumn:(NSInteger)column;
/**
 * 表视图显示时，左边表显示比例
 */
- (CGFloat)widthRatioOfLeftColumn:(NSInteger)column;
/**
 * 表视图显示时，是否需要两个表显示
 */
- (BOOL)haveRightTableViewInColumn:(NSInteger)column;

/**
 * 返回当前菜单左边表选中行
 */
- (NSInteger)currentLeftSelectedRow:(NSInteger)column;

@optional
//default value is 1
- (NSInteger)numberOfColumnsInMenu:(KSDropDownMenu *)menu;

/**
 * 是否需要显示为UICollectionView 默认为否
 */
- (BOOL)displayByCollectionViewInColumn:(NSInteger)column;

@end

#pragma mark - delegate
@protocol KSDropDownMenuDelegate <NSObject>
@optional
- (void)menu:(KSDropDownMenu *)menu didSelectRowAtIndexPath:(KSIndexPath *)indexPath;
@end

#pragma mark - interface
@interface KSDropDownMenu : UIView <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) id <KSDropDownMenuDataSource> dataSource;
@property (nonatomic, weak) id <KSDropDownMenuDelegate> delegate;

@property (nonatomic, strong) UIColor *indicatorColor;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *separatorColor;
/**
 *  the width of menu will be set to screen width defaultly
 *
 *  @param origin the origin of this view's frame
 *  @param height menu's height
 *
 *  @return menu
 */
- (instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height;
- (NSString *)titleForRowAtIndexPath:(KSIndexPath *)indexPath;

@end
