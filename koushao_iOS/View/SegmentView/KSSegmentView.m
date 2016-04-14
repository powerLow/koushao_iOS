//
//  KSSegmentView.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/26.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSSegmentView.h"

#define RGBA(r,g,b,a) ([UIColor colorWithRed:r/255 green:g/255 blue:b/255 alpha:a])
#define kDefaultTintColor   RGB(3, 116, 255)
#define kLeftRightMargin    15
#define kItemHeight         30
#define kBorderLineWidth    0.5
#define kTitleSize         ([UIFont systemFontOfSize:14])

@class KSSegmentItem;
@protocol KSSegmentItemDelegate

- (void)ItemStateChanged:(KSSegmentItem *)item index:(NSInteger)index isSelected:(BOOL)isSelected;
@end

#pragma mark - RFSegmentItem
@interface KSSegmentItem : UIView

@property (nonatomic, strong) UIColor   *norColor;
@property (nonatomic, strong) UIColor   *selColor;
@property (nonatomic, strong) UILabel   *titleLabel;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) BOOL      isSelected;
@property (nonatomic, assign) id        delegate;
@end

@implementation KSSegmentItem
- (id)initWithFrame:(CGRect)frame
              index:(NSInteger)index
              title:(NSString *)title
           norColor:(UIColor *)norColor
           selColor:(UIColor *)selColor
         isSelected:(BOOL)isSelected;
{
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel                 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _titleLabel.textAlignment   = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font            = kTitleSize;
        self.layer.borderWidth  = kBorderLineWidth;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        [self addSubview:_titleLabel];
        
        self.norColor        = norColor;
        self.selColor        = selColor;
        self.titleLabel.text = title;
        self.index           = index;
        self.isSelected      = isSelected;
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    self.titleLabel.frame = self.bounds;
}

- (void)setSelColor:(UIColor *)selColor
{
    if (_selColor != selColor) {
        _selColor = selColor;
        
        if (_isSelected) {
            self.titleLabel.textColor = self.norColor;
            self.backgroundColor = self.selColor;
        }else{
            self.titleLabel.textColor = self.selColor;
            self.backgroundColor = self.norColor;
        }
        
    }
}

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    if (_isSelected) {
        self.titleLabel.textColor = self.norColor;
        self.backgroundColor = self.selColor;
    }else{
        self.titleLabel.textColor = self.selColor;
        self.backgroundColor = self.norColor;
    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    self.isSelected = !_isSelected;
    
    if (_delegate) {
        [_delegate ItemStateChanged:self index:self.index isSelected:self.isSelected];
    }
}

@end

#pragma mark - RFSegmentView
@interface KSSegmentView()

@property (nonatomic, strong) UIView         *bgView;
@property (nonatomic, strong) NSArray        *titles;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) NSMutableArray *lines;
@end

@implementation KSSegmentView

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items backgroundColor:(UIColor*)color
{
    self = [super initWithFrame:frame];
    if (self) {
        
        NSAssert(items.count >= 2, @"items's cout at least 2!please check!");
        self.titles           = items;
        self.selectedIndex    = 0;
        self.backgroundColor  = [UIColor clearColor];
        
        //
        self.bgView = [[UIView alloc] init];
        self.bgView.backgroundColor    = BASE_COLOR;
        self.bgView.clipsToBounds      = YES;
        self.bgView.layer.cornerRadius = 5;
        self.bgView.layer.borderWidth  = kBorderLineWidth;
        self.bgView.layer.borderColor  = kDefaultTintColor.CGColor;
        
        [self addSubview:self.bgView];
        
        
        NSInteger count = self.titles.count;
        for (NSInteger i = 0; i < count; i++) {
            KSSegmentItem *item = [[KSSegmentItem alloc] initWithFrame:CGRectZero
                                                                 index:i
                                                                 title:items[i]
                                                              norColor:BASE_COLOR
                                                              selColor:BASE_COLOR
                                                            isSelected:(i == 0)? YES: NO];
            [self.bgView addSubview:item];
            item.delegate = self;
            
            //save all items
            if (!self.items) {
                self.items = [[NSMutableArray alloc] initWithCapacity:count];
            }
            [self.items addObject:item];
        }
        
        //add Ver lines
        for (NSInteger i = 0; i < count - 1; i++) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
            lineView.backgroundColor = kDefaultTintColor;
            
            [self.bgView addSubview:lineView];
            
            //save all lines
            if (!self.lines) {
                self.lines = [[NSMutableArray alloc] initWithCapacity:count];
            }
            [self.lines addObject:lineView];
        }
        
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat viewWidth     = CGRectGetWidth(self.frame);
    CGFloat viewHeight    = CGRectGetHeight(self.frame);
    __block CGFloat initX = 0;
    CGFloat initY         = 0;
    
    NSInteger count         = self.titles.count;
    CGFloat itemWidth       = CGRectGetWidth(self.bgView.frame)/count;
    CGFloat itemHeight      = CGRectGetHeight(self.bgView.frame);
    CGFloat leftRightMargin = self.leftRightMargin?:kLeftRightMargin;
    
    //configure bgView
    self.bgView.frame = CGRectMake(leftRightMargin, (viewHeight - self.itemHeight?:kItemHeight)/2, viewWidth - 2*kLeftRightMargin, self.itemHeight?:kItemHeight);
//    self.bgView.frame = CGRectMake(0, 0, viewWidth, viewHeight);
    //configure items
    [self.items enumerateObjectsUsingBlock:^(KSSegmentItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        item.frame = CGRectMake(initX, initY, itemWidth, itemHeight);
        initX += itemWidth;
    }];
    
    initX = 0;
    //configure lines
    [self.lines enumerateObjectsUsingBlock:^(UIView *  _Nonnull lineView, NSUInteger idx, BOOL * _Nonnull stop) {
        initX += itemWidth;
        lineView.frame = CGRectMake(initX, 0, kBorderLineWidth, itemHeight);
    }];
    
}

- (void)setTintColor:(UIColor *)tintColor{
    
    if (_tintColor != tintColor) {
        _tintColor = tintColor;
        
        self.bgView.layer.borderColor  = tintColor.CGColor;
        
        for (NSInteger i = 0; i<self.items.count; i++) {
            KSSegmentItem *item = self.items[i];
            item.selColor = tintColor;
        }
        
        for (NSInteger i = 0; i<self.lines.count; i++) {
            UIView *lineView = self.lines[i];
            lineView.backgroundColor = tintColor;
        }
        
        [self setNeedsLayout];
    }
}

- (void)setSelectedIndex:(NSUInteger)index
{
    _selectedIndex = index;
    
    if (index<self.items.count) {
        for (int i = 0; i<self.items.count; i++) {
            KSSegmentItem *item=self.items[i];
            
            if (i==index) {
                [item setIsSelected:YES];
            }else {
                [item setIsSelected:NO];
            }
        }
    }
}

#pragma mark - RFSegmentItemDelegate
- (void)ItemStateChanged:(KSSegmentItem *)currentItem index:(NSInteger)index isSelected:(BOOL)isSelected{
    
    for (int i = 0; i < self.items.count; i++) {
        KSSegmentItem *item = self.items[i];
        item.isSelected = NO;
    }
    currentItem.isSelected = YES;
    
    if (_delegate && [_delegate respondsToSelector:@selector(segmentViewDidSelected:)]){
        [_delegate segmentViewDidSelected:index];
    }
}

@end