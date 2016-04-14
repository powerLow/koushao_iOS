//
//  RichEditTableViewCellImage.m
//  RichiEditDemo
//
//  Created by 陈奇 on 15/10/16.
//  Copyright © 2015年 陈奇. All rights reserved.
//

#import "RichEditTableViewCellImage.h"
#import <Photos/Photos.h>
#import "KSUtil.h"
#import <YYWebImage.h>
#import "Masonry.h"
#import <AssetsLibrary/AssetsLibrary.h>
#define IMAGE_COVER_CONTAINER 1
#define IMAGE_UPLOAD_PROGRESS_LABEL 2
@interface RichEditTableViewCellImage ()
@property(nonatomic,strong)  ALAssetsLibrary *assetsLibrary;
@end
@implementation RichEditTableViewCellImage
PHImageRequestOptions *requestOptions;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubView];
    }
    return self;
}
-(void) initSubView
{
    requestOptions = [[PHImageRequestOptions alloc] init];
    requestOptions.resizeMode   = PHImageRequestOptionsResizeModeExact;
    requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    self.assetsLibrary= [[ALAssetsLibrary alloc]init];
}


-(void)setImage:(NSString *)imagePath imageWidth:(int) imageWidth imageHeight:(int)imageHeight
{
    while ([self.contentView.subviews lastObject] != nil) {
        [(UIView*)[self.contentView.subviews lastObject] removeFromSuperview];  //删除并进行重新分配
    }
    self.isCoverShow=NO;
    self.imageHeight=imageHeight;
    self.imageWidth=imageWidth;
    
    UIImageView*  imageView=[[UIImageView alloc]init];
    
    imageView.frame=CGRectMake(0, 0, imageWidth, imageHeight);
    UIButton *imageButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, imageWidth, imageHeight)];
    [imageButton addSubview:imageView];
    [self.contentView addSubview:imageButton];
    
    UILabel* percentLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, imageWidth, imageHeight)];
    percentLabel.tag=IMAGE_UPLOAD_PROGRESS_LABEL;
    percentLabel.textColor=[UIColor whiteColor];
    percentLabel.font=[UIFont fontWithName:@"Arial" size:30];
    percentLabel.textAlignment=NSTextAlignmentCenter;
    percentLabel.backgroundColor=[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.7];
    percentLabel.alpha=0;
    [self.contentView addSubview:percentLabel];
    
    
    //关闭按钮的图片
    UIImageView *closedImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    closedImage.image=[UIImage imageNamed:@"cross_gray.png"];
    
    //关闭按钮
    UIButton*  closedButton=[[UIButton alloc]initWithFrame:CGRectMake(10, 10, 25, 25)];
    [closedButton addSubview:closedImage];
    [closedButton addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
    UIButton* container=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, imageWidth, imageHeight)];
    container.tag=IMAGE_COVER_CONTAINER;
    container.backgroundColor=[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.7];
    
    [container addTarget:self action:@selector(touchedArea:) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:closedButton];
    [self.contentView addSubview:container];
    self.isCoverShow=NO;
    [self InitAnimation];
    
    
    
    NSURL *url=[[NSURL alloc]initWithString:imagePath];
    NSLog(imagePath,nil);
    if([imagePath containsString:@"http://"]) //网络图片
    {
        [imageView yy_setImageWithURL:url placeholder:nil];
    }
    else //本地图片
    {
        
        [KSUtil loadItem:url withSuccessBlock:^(ALAsset *asset) {
            imageView.image=[UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage] ];
        } andFailureBlock:^{
            
        }];
    }
}

-(UIButton *)getContainer
{
    for(UIView *subview in self.contentView.subviews)
    {
        if(subview.tag==IMAGE_COVER_CONTAINER)
        {
            return (UIButton *)subview;
            break;
        }
    }
    return nil;
}
-(UILabel *)getPercentLabel
{
    for(UIView *subview in self.contentView.subviews)
    {
        if(subview.tag==IMAGE_UPLOAD_PROGRESS_LABEL)
        {
            return (UILabel*)subview;
            break;
        }
    }
    return nil;
}
-(void)setPercent:(float)percent
{
    UILabel* label=[self getPercentLabel];
    if(label)
    {
        CFLocaleRef currentLocale = CFLocaleCopyCurrent();
        CFNumberFormatterRef numberFormatter = CFNumberFormatterCreate(NULL, currentLocale, kCFNumberFormatterPercentStyle);
        CFNumberRef number = CFNumberCreate(NULL, kCFNumberFloatType, &percent);
        CFStringRef numberString = CFNumberFormatterCreateStringWithNumber(NULL, numberFormatter, number);
        dispatch_async(dispatch_get_main_queue(), ^{
            label.text=[NSString stringWithFormat:@"%@",numberString];
            if(percent==1)
            {
                label.alpha=0;
            }
            else if(percent==0)
            {
                label.alpha=0;
            }
            else label.alpha=1;
        });
    }
    
}
-(void)touchedArea:(UIButton *)sender
{
    if(self.isCoverShow)
    {
        [self hideCover];
    }
    else
    {
        [self showCover];
    }
}
-(void)InitAnimation
{
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.fromValue = [NSNumber numberWithFloat:0];
    alphaAnimation.toValue = [NSNumber numberWithFloat:0];
    alphaAnimation.autoreverses = NO;
    alphaAnimation.fillMode = kCAFillModeBoth;
    alphaAnimation.removedOnCompletion=NO;
    alphaAnimation.duration = 0.1;
    [[self getContainer].layer addAnimation:alphaAnimation forKey:nil];
}
-(void)hideCover
{
    UIButton *cover=[self getContainer];
    if(cover)
    {
        if(self.isCoverShow)
        {
            self.isCoverShow=NO;
            CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
            alphaAnimation.fromValue = [NSNumber numberWithFloat:1];
            alphaAnimation.toValue = [NSNumber numberWithFloat:0];
            alphaAnimation.autoreverses = NO;
            alphaAnimation.fillMode = kCAFillModeBoth;
            alphaAnimation.removedOnCompletion=NO;
            alphaAnimation.duration = 0.1;
            [cover.layer addAnimation:alphaAnimation forKey:nil];
        }
    }
}

-(void)showCover
{
    UIButton *cover=[self getContainer];
    if(cover)
    {
        if(!self.isCoverShow)
        {
            if(self.coverTouched)
            {
                self.coverTouched();
            }
            self.isCoverShow=YES;
            CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
            alphaAnimation.fromValue = [NSNumber numberWithFloat:0];
            alphaAnimation.toValue = [NSNumber numberWithFloat:1];
            alphaAnimation.autoreverses = NO;
            alphaAnimation.fillMode = kCAFillModeBoth;
            alphaAnimation.removedOnCompletion=NO;
            alphaAnimation.duration = 0.1;
            [cover.layer addAnimation:alphaAnimation forKey:nil];
        }
    }
}

-(void) deleteImage:(UIButton*)button
{
    if(self.isCoverShow)
        if(self.imageDelete)
        {
            self.imageDelete();
        }
}

- (UITableView *)tableView
{
    UIView *tableView = self.superview;
    while (![tableView isKindOfClass:[UITableView class]] && tableView) {
        tableView = tableView.superview;
    }
    return (UITableView *)tableView;
}
@end
