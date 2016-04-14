//
//  KSExpressListViewController.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/12/8.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "SWTableViewCell.h"
#import "Express.h"
@class KSExpressListViewController;
enum {
    SWTableCellIndexTelTag = 0,
    SWTableCellIndexURlTag = 1
};
enum {
    CellImageTag = 1,
    CellLabelTag
};
@protocol ExpressListViewDelgate <NSObject>

@optional
- (void)ExpressListView:(KSExpressListViewController*)controller didSelectWithobject:(Express*)express;
- (void)ExpressListViewDidCanceld:(KSExpressListViewController*)controller;

@end

@interface KSExpressListViewController : UITableViewController<UISearchControllerDelegate,UISearchBarDelegate,UISearchResultsUpdating,SWTableViewCellDelegate>

@property (weak,nonatomic) id<ExpressListViewDelgate>delegate;

@property (nonatomic) BOOL isPresent;

@end
