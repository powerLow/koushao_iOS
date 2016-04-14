//
//  CTIconButtonBottomPoper.m
//  koushao_iOS
//
//  Created by 陈奇 on 15/12/24.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "CTIconButtonBottomPoper.h"
#import "CTConst.h"
#import "CTIconButton.h"
#define DEFAULT_BUTTON_SIZE CGSizeMake(80, 90)
#define DEFAULT_BUTTONAREA_MARGINTOP 50
#define DEFAULT_BUTTON_MARGINTOP 15

#define DEFAULT_TITLE_MARGINLEFT 16
#define DEFAULT_TITLE_FONTSIZE 18

#define DEFAULT_CANCELBUTTON_HEIGHT 50
#define DEFAULT_CANCELBUTTON_FONTSIZE 18

@interface CTIconButtonBottomPoper()
@property(nonatomic,strong)NSMutableArray* scrollViewArray;
@property(nonatomic,strong)UILabel* titleLabel;
@property(nonatomic,strong)UIButton* cancelButton;
@end

@implementation CTIconButtonBottomPoper
-(id)initWithButtons:(NSArray *)buttonsArray
{
    if(self=[super init])
    {
        _scrollViewArray=[[NSMutableArray alloc]init];
        if(buttonsArray)
            if(buttonsArray.count>=1)
            {
                if([[buttonsArray objectAtIndex:0] isKindOfClass:[CTIconButtonModel class]])
                {
                    [self addButtonsWithModelArray:buttonsArray];
                }
                else if([[buttonsArray objectAtIndex:0] isKindOfClass:[NSArray class]])
                {
                    [self addButtonsWithArrayOfModelArray:buttonsArray];
                }
            }
        
        _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(DEFAULT_TITLE_MARGINLEFT, 0, CT_SCREEN_WIDTH, DEFAULT_BUTTONAREA_MARGINTOP)];
        _titleLabel.font=[UIFont systemFontOfSize:DEFAULT_TITLE_FONTSIZE];
        _titleLabel.textColor=[UIColor grayColor];
        [self addSubview:_titleLabel];
        
        _cancelButton=[[UIButton alloc]initWithFrame:CGRectMake(0, DEFAULT_BUTTONAREA_MARGINTOP+DEFAULT_BUTTON_SIZE.height*_scrollViewArray.count, CT_SCREEN_WIDTH, DEFAULT_CANCELBUTTON_HEIGHT)];
        [self addSubview:_cancelButton];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _cancelButton.titleLabel.font=[UIFont systemFontOfSize:DEFAULT_CANCELBUTTON_FONTSIZE];
        [self addSubview:_cancelButton];
        [_cancelButton addTarget:self action:@selector(_cancelButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)_cancelButtonTouched
{
    [self dismiss];
}

-(void)setTitle:(NSString *)title
{
    _title=title;
    _titleLabel.text=title;
}

-(void)setShowCancelButton:(BOOL)showCancelButton
{
    _showCancelButton=showCancelButton;
    self.poperHeight=DEFAULT_BUTTONAREA_MARGINTOP+DEFAULT_BUTTON_SIZE.height*_scrollViewArray.count+(_showCancelButton?DEFAULT_CANCELBUTTON_HEIGHT:0);
}

-(void)addButtonsWithModelArray:(NSArray *)buttonsModelArray
{
    int buttonsCount=0;
    UIScrollView* scrollView=[[UIScrollView alloc]init];
    scrollView.frame=CGRectMake(0, DEFAULT_BUTTONAREA_MARGINTOP+_scrollViewArray.count*DEFAULT_BUTTON_SIZE.height,CT_SCREEN_WIDTH , DEFAULT_BUTTON_SIZE.height);
    [self addSubview:scrollView];
    [_scrollViewArray addObject:scrollView];
    
    NSInteger scrollViewPosition=[_scrollViewArray indexOfObject:scrollView]+1;
    
    for(id buttonObject in buttonsModelArray)
    {
        if([buttonObject isKindOfClass:[CTIconButtonModel class]])
        {
            CTIconButton* button=[[CTIconButton alloc]initWithButtonModel:buttonObject];
            button.frame=CGRectMake(buttonsCount*DEFAULT_BUTTON_SIZE.width, DEFAULT_BUTTON_MARGINTOP, DEFAULT_BUTTON_SIZE.width, DEFAULT_BUTTON_SIZE.height);
            [scrollView addSubview:button];
            button.indexPath=[NSIndexPath indexPathForRow:buttonsCount inSection:scrollViewPosition-1];
            buttonsCount++;
            [button addTarget:self action:@selector(ButtonItemCliecked:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    scrollView.contentSize=CGSizeMake(buttonsCount*DEFAULT_BUTTON_SIZE.width<CT_SCREEN_WIDTH?CT_SCREEN_WIDTH:buttonsCount*DEFAULT_BUTTON_SIZE.width, DEFAULT_BUTTON_SIZE.height);
    scrollView.showsHorizontalScrollIndicator=NO;
    
    UIView* line=[[UIView alloc]initWithFrame:CGRectMake(0, DEFAULT_BUTTON_SIZE.height*scrollViewPosition+DEFAULT_BUTTONAREA_MARGINTOP-1, scrollView.contentSize.width, 0.6f)];
    line.backgroundColor=[UIColor grayColor];
    line.alpha=0.3f;
    
    [self addSubview:line];
    self.poperHeight=DEFAULT_BUTTONAREA_MARGINTOP+DEFAULT_BUTTON_SIZE.height*_scrollViewArray.count+(_showCancelButton?DEFAULT_CANCELBUTTON_HEIGHT:0);
}
-(void)ButtonItemCliecked:(CTIconButton*)sender
{
    NSLog(@"section:%li row:%li",sender.indexPath.section,sender.indexPath.row);
    if(self.onButtonItemClicked)
        self.onButtonItemClicked(sender.indexPath);
}
-(void)addButtonsWithArrayOfModelArray:(NSArray *)arrayOfModelArray
{
    for(id array in arrayOfModelArray)
    {
        if([array isKindOfClass:[NSArray class]])
        {
            [self addButtonsWithModelArray:array];
        }
    }
}
@end
