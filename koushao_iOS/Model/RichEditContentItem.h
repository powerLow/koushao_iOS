//
//  RichEditContentItem.h
//  RichiEditDemo
//
//  Created by 陈奇 on 15/10/16.
//  Copyright © 2015年 陈奇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RichEditContentItem : NSObject
@property(nonatomic,copy) NSString * contentString;
@property(nonatomic,assign) int contentType;
@property(nonatomic,assign) int Width;
@property(nonatomic,assign) int Height;
@end
