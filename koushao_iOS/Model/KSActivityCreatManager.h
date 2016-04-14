//
//  KSActivityCreatManager.h
//  koushao_iOS
//
//  Created by 陈奇 on 15/11/10.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSActivityCreatManager : NSObject<KSPersistenceProtocol>

#pragma mark 活动基本信息
@property(nonatomic,copy)NSString* hashCode; //活动的hashcode
@property(nonatomic,copy)NSString* sig;  //活动详情的sig

#pragma mark 时间地点
@property(nonatomic,copy)NSString* title; //活动标题
@property(nonatomic,copy)NSString* poster; //海报地址
@property(nonatomic,copy)NSString* detail; //活动详情
@property(nonatomic,assign)float longitude; //经度
@property(nonatomic,assign)float latitude; //纬度
@property(nonatomic,copy)NSString* location; //活动地址
@property(nonatomic,assign)NSInteger startTime; //开始时间戳
@property(nonatomic,assign)NSInteger endTime; //结束时间戳
@property(nonatomic,assign)NSInteger t; //当前时间戳
@property(nonatomic,assign)NSInteger allDay;//是否勾选全天 0 没 1 有
@property(nonatomic,assign)NSInteger hasEndTime;//是否有结束时间 0 有 1无

#pragma mark 活动详情
//活动详情的数组
@property(nonatomic,strong)NSMutableArray* detailItems;

//图片上传进度的hashmap
@property(nonatomic,strong)NSMutableDictionary* imageUploadProgressHashMap;

//本地图片到网络图片地址的映射
@property(nonatomic,strong)NSMutableDictionary* localImage2NetUrl;

//网络图片地址到本地图片的映射
@property(nonatomic,strong)NSMutableDictionary* NetUrl2localImage;

#pragma mark 详情版式与封面版式
//详情页样式序号
@property(nonatomic,assign)NSInteger detailStyle;

//封面页样式序号
@property(nonatomic,assign)NSInteger coverStyle;

//封面版式的图片图片路径
@property(nonatomic,copy)NSString* coverPosterPath;

//详情页图片的hashMap
@property(nonatomic,strong)NSMutableDictionary* detailPosterHashMap;

//详情页图片数组
@property(nonatomic,strong)NSMutableArray* detailPosterArray;

//封面页图片的HashMap
@property(nonatomic,strong)NSMutableDictionary* coverPosterHashMap;

//详情页版式图片到其原始尺寸图片的映射
@property(nonatomic,strong)NSMutableDictionary* detailPosterCroppedImage2OriginImageHashMap;

//封面页版式图片的实际尺寸图片的路径
@property(nonatomic,copy)NSString* coverPosterOriginalImagePath;

@property(nonatomic,assign)BOOL isTempleteSettingComplete;

#pragma mark 活动报名信息

//报名模块是否开启 0不启用 1启用
@property(nonatomic,assign)NSInteger enlist_isOpen;

//报名类型  0:实名制 1:非实名制
@property(nonatomic,assign)NSInteger enlist_type;

//活动购票限制
@property(nonatomic,assign)NSInteger enlist_limit;

//是否生成报名凭证 0不生成 1生成
@property(nonatomic,assign)NSInteger enlist_generate_enlist_certificate;

//活动报名表单信息数组
@property(nonatomic,strong)NSMutableArray* enlist_form_info_array;

//活动费用信息数组
@property(nonatomic,strong)NSMutableArray* enlist_fee_item_array;

-(void)deleteEnlistInfo;
-(void)clearInfo;

#pragma mark 活动咨询模块信息

@property(nonatomic,assign)NSInteger consult_isOpen;

#pragma mark 活动福利模块信息

//福利模块是否打开
@property(nonatomic,assign)NSInteger welfare_isOpen;

//大转盘不中奖概率
@property(nonatomic,assign)NSInteger welfare_Probability;

//福利类型（当前只有3 大转盘）
@property(nonatomic,assign)NSInteger welfare_Category;

//福利描述
@property(nonatomic,copy)NSString* welfare_description;

//所有的奖品类型
@property(nonatomic,strong)NSMutableArray* welfare_items;

-(void)deleteWelfareInfo;

#pragma mark 活动创建信息的全局单例
+ (KSActivityCreatManager *)sharedManager;
@end
