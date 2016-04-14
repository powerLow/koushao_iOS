//
//  RichEditTableViewCellImage.h
//  RichiEditDemo
//
//  Created by 陈奇 on 15/10/16.
//  Copyright © 2015年 陈奇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RichEditTableViewCellImage : UITableViewCell
-(void)setImage:(NSString *)imagePath imageWidth:(int) imageWidth imageHeight:(int)imageHeight;
-(void)showCover;
-(void)hideCover;
-(void)setPercent:(float)percent;
@property(nonatomic,copy) void (^imageDelete)(void);
@property(nonatomic,copy) void (^coverTouched)(void);
@property(nonatomic,assign) int imageHeight;
@property(nonatomic,assign) int imageWidth;
@property(nonatomic,assign)BOOL isCoverShow;
@end
