//
//  KSActivityCreatManager.m
//  koushao_iOS
//
//  Created by 陈奇 on 15/11/10.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSActivityCreatManager.h"
#import "RichEditContentItem.h"
#import "MJExtension.h"
#import "EnlistFeeItem.h"
#import "WelfareItem.h"

@implementation KSActivityCreatManager
+(NSDictionary *)objectClassInArray
{
    return
    @{
      @"detailItems":[RichEditContentItem class],
      @"detailPosterArray":[NSString class],
      @"enlist_fee_item_array":[EnlistFeeItem class],
      @"enlist_form_info_array":[NSString class],
      @"welfare_items":[WelfareItem class]
      };
}

+ (KSActivityCreatManager *)sharedManager
{
    static KSActivityCreatManager *ManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        YTKKeyValueStore *store = [KSUtil getDatabase];
        NSDictionary *dict = [store getObjectById:DB_ID_KS_ACTIVITY_CREAT_MANAGER fromTable:KS_DATABASE_TABLENAME_ACTIVITY_CREAT_MANAGER];
        ManagerInstance=[KSActivityCreatManager mj_objectWithKeyValues:dict];
        if(!ManagerInstance)
        {
            ManagerInstance = [[self alloc] init];
            ManagerInstance.localImage2NetUrl=[[NSMutableDictionary alloc]init];
            ManagerInstance.NetUrl2localImage=[[NSMutableDictionary alloc]init];
            ManagerInstance.detailItems=[[NSMutableArray alloc]init];
            ManagerInstance.imageUploadProgressHashMap=[[NSMutableDictionary alloc]init];
            ManagerInstance.detailPosterArray=[[NSMutableArray alloc]init];
            ManagerInstance.coverPosterHashMap=[[NSMutableDictionary alloc]init];
            ManagerInstance.detailPosterHashMap=[[NSMutableDictionary alloc]init];
            ManagerInstance.detailPosterCroppedImage2OriginImageHashMap=[[NSMutableDictionary alloc]init];
            ManagerInstance.enlist_fee_item_array=[[NSMutableArray alloc]init];
            ManagerInstance.enlist_form_info_array=[[NSMutableArray alloc]init];
            ManagerInstance.welfare_items=[[NSMutableArray alloc]init];
            [ManagerInstance ks_saveOrUpdate];
        }
        if(!ManagerInstance.localImage2NetUrl)
        {
            ManagerInstance.localImage2NetUrl=[[NSMutableDictionary alloc]init];
        }
        if(!ManagerInstance.NetUrl2localImage)
        {
            ManagerInstance.NetUrl2localImage=[[NSMutableDictionary alloc]init];
        }
        if(!ManagerInstance.detailItems)
        {
            ManagerInstance.detailItems=[[NSMutableArray alloc]init];
        }
        if(!ManagerInstance.imageUploadProgressHashMap)
        {
            ManagerInstance.imageUploadProgressHashMap=[[NSMutableDictionary alloc]init];
        }
        if(!ManagerInstance.detailPosterArray)
        {
            ManagerInstance.detailPosterArray=[[NSMutableArray alloc]init];
        }
        if(!ManagerInstance.coverPosterHashMap)
        {
            ManagerInstance.coverPosterHashMap=[[NSMutableDictionary alloc]init];
        }
        if(!ManagerInstance.detailPosterHashMap)
        {
            ManagerInstance.detailPosterHashMap=[[NSMutableDictionary alloc]init];
        }
        if(!ManagerInstance.enlist_form_info_array)
        {
            ManagerInstance.enlist_form_info_array=[[NSMutableArray alloc]init];
        }
        if(!ManagerInstance.enlist_fee_item_array)
        {
            ManagerInstance.enlist_fee_item_array=[[NSMutableArray alloc]init];
        }
        if(!ManagerInstance.welfare_items)
        {
            ManagerInstance.welfare_items=[[NSMutableArray alloc]init];
        }
        
        if(!ManagerInstance.detailPosterCroppedImage2OriginImageHashMap)
            ManagerInstance.detailPosterCroppedImage2OriginImageHashMap=[[NSMutableDictionary alloc]init];
        
        //Dictionary还原成NSMutableDictionary
        ManagerInstance.localImage2NetUrl=[[NSMutableDictionary alloc]initWithDictionary:ManagerInstance.localImage2NetUrl];
        
        ManagerInstance.NetUrl2localImage=[[NSMutableDictionary alloc]initWithDictionary:ManagerInstance.NetUrl2localImage];
        
        ManagerInstance.detailPosterCroppedImage2OriginImageHashMap=[[NSMutableDictionary alloc]initWithDictionary:ManagerInstance.detailPosterCroppedImage2OriginImageHashMap];
        
        ManagerInstance.detailPosterHashMap=[[NSMutableDictionary alloc]initWithDictionary:ManagerInstance.detailPosterHashMap];
        
        ManagerInstance.coverPosterHashMap=[[NSMutableDictionary alloc]initWithDictionary:ManagerInstance.coverPosterHashMap];
        
        ManagerInstance.imageUploadProgressHashMap=[[NSMutableDictionary alloc]initWithDictionary:ManagerInstance.imageUploadProgressHashMap];
        
    });
    return ManagerInstance;
}
-(void)deleteEnlistInfo
{
    self.enlist_isOpen=0;
    self.enlist_limit=0;
    self.enlist_type=0;
    self.enlist_form_info_array=[[NSMutableArray alloc]init];
    self.enlist_fee_item_array=[[NSMutableArray alloc]init];
    self.enlist_generate_enlist_certificate=0;
    [self deleteWelfareInfo];
}

-(void)deleteWelfareInfo
{
    self.welfare_Category=0;
    self.welfare_description=@"";
    self.welfare_isOpen=0;
    self.welfare_items=[[NSMutableArray alloc]init];
    self.welfare_Probability=0;
}
-(void)clearInfo
{
    _hashCode=@""; //活动的hashcode
    _sig=@"";  //活动详情的sig
    _title=@""; //活动标题
    _poster=@""; //海报地址
    _detail=@""; //活动详情
    _longitude=0; //经度
    _latitude=0; //纬度
    _location=@""; //活动地址
    _startTime=0; //开始时间戳
    _endTime=0; //结束时间戳
    _t=0; //当前时间戳
    _allDay=0;//是否勾选全天 0 没 1 有
    _hasEndTime=0;//是否有结束时间 0 有 1无
    _detailStyle=0;
    //封面页样式序号
    _coverStyle=0;
    //封面版式的图片图片路径
    _coverPosterPath=@"";
    _isTempleteSettingComplete=NO;
    
    _coverPosterOriginalImagePath=@"";
    _localImage2NetUrl=[[NSMutableDictionary alloc]init];
    _NetUrl2localImage=[[NSMutableDictionary alloc]init];
    _detailItems=[[NSMutableArray alloc]init];
    _imageUploadProgressHashMap=[[NSMutableDictionary alloc]init];
    _detailPosterArray=[[NSMutableArray alloc]init];
    _coverPosterHashMap=[[NSMutableDictionary alloc]init];
    _detailPosterHashMap=[[NSMutableDictionary alloc]init];
    _detailPosterCroppedImage2OriginImageHashMap=[[NSMutableDictionary alloc]init];
    
    _consult_isOpen=0;
    [self deleteEnlistInfo];
    
}
- (BOOL)ks_saveOrUpdate{
    NSDictionary *dict = self.mj_keyValues;
    YTKKeyValueStore *store = [KSUtil getDatabase];
    [store putObject:dict withId:DB_ID_KS_ACTIVITY_CREAT_MANAGER intoTable:KS_DATABASE_TABLENAME_ACTIVITY_CREAT_MANAGER];
    return YES;
}
- (BOOL)ks_delete {
    YTKKeyValueStore *store = [KSUtil getDatabase];
    [store deleteObjectById:DB_ID_KS_ACTIVITY_CREAT_MANAGER fromTable:KS_DATABASE_TABLENAME_ACTIVITY_CREAT_MANAGER];
    return YES;
}
+ (instancetype)ks_fetchById:(NSString *)key {
    YTKKeyValueStore *store = [KSUtil getDatabase];
    NSDictionary *dict = [store getObjectById:DB_ID_KS_ACTIVITY_CREAT_MANAGER fromTable:KS_DATABASE_TABLENAME_ACTIVITY_CREAT_MANAGER];
    return [KSActivityCreatManager mj_objectWithKeyValues:dict];
}
@end
