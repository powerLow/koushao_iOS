//
//  MapSelectViewController.m
//  koushao_iOS
//
//  Created by 陈奇 on 15/10/31.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//
#import "MapSelectViewController.h"
#import "KSActivityCreatManager.h"
#import "Masonry.h"

@interface MapSelectViewController ()
@property (nonatomic, strong) UISearchBar*mSearchBar;
@property (nonatomic, strong)UISearchDisplayController *searchController;
@property (nonatomic, strong) MAMapView *_mapView;
@property (nonatomic, strong) UIView* mapContainerView;
@property (nonatomic,strong)  AMapSearchAPI* _search;
@property(nonatomic,assign) BOOL hasLocated;
@property(nonnull,strong)UIView* userLocationAnnotationView;
@property(nonatomic,strong)UITableView* nearbyPOITableView;
@property(nonatomic,copy)NSMutableArray* POIArray;
@property(nonatomic,copy)NSArray* keyWordPOIArray;
@property(nonnull,copy)NSString* city;
@property(nonatomic,strong)MAUserLocation* userLocation;
@property(nonatomic,strong)UIImageView* centerCoorIcon;
@property(nonatomic,strong)AMapPOI* selectedSearchResultPoi;
@property(nonatomic,assign)BOOL isFromSearch;
@end
@implementation MapSelectViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initTitleBar];
    [self initView];
}

/**
 *  初始化页面数据
 */
-(void)initData
{
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.hasLocated=false;
    self.POIArray=[[NSMutableArray alloc]init];
    _isFromSearch=NO;
}

/**
 *  初始化导航栏按钮
 */
-(void)initTitleBar
{
    UIImageView *backButton=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0 , 12.5, 20)];
    backButton.image=[UIImage imageNamed:@"back_arrow"];
    
    //返回上一步按钮
    UIButton* leftTitleButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0 , 12.5, 20)];
    [leftTitleButton addSubview:backButton];
    [leftTitleButton addTarget:self action:@selector(backToActivityList) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:leftTitleButton];
    
    //设置NavigationBar的相关属性
    self.navigationItem.leftBarButtonItem=leftBarButtonItem;
    
}
/**
 *  关闭当前ViewController
 */
-(void)backToActivityList
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  初始化页面的view
 */
-(void)initView
{
    self.view.backgroundColor=[UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initMapViewAndList];
    [self initSearchBarAndController];
}

/**
 *  初始化地图控件和列表
 */
-(void)initMapViewAndList
{
    //地图控件初始化与设定
    self._mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.view.bounds)/1.2)];
    self._mapView.delegate = self;
    self._mapView.showsUserLocation = YES;
    [self._mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES];
    [self._mapView setZoomLevel:16.5 animated:YES];
    self._mapView.showsCompass=NO;
    
    //地图控件容器初始化与设定
    self.mapContainerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.view.bounds)/1.2)];
    [self.mapContainerView addSubview:self._mapView];
    self.mapContainerView.clipsToBounds=YES;
    
    //我的位置按钮
    UIButton* myLocationButton=[[UIButton alloc]init];
    [self.mapContainerView addSubview:myLocationButton];
    [myLocationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
        make.left.mas_equalTo(_mapContainerView.mas_left).with.offset(20);
        make.bottom.mas_equalTo(_mapContainerView.mas_bottom).with.offset(-20);
    }];
    myLocationButton.backgroundColor=[UIColor whiteColor];
    [myLocationButton setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
    myLocationButton.contentEdgeInsets=UIEdgeInsetsMake(5, 5, 5, 5);
    myLocationButton.layer.shadowOffset=CGSizeMake(1, 1);
    myLocationButton.layer.shadowRadius=3.0;
    myLocationButton.layer.shadowColor=[UIColor grayColor].CGColor;
    myLocationButton.layer.shadowOpacity=.3f;
    myLocationButton.layer.borderColor=[UIColor grayColor].CGColor;
    myLocationButton.layer.borderWidth=0.2;
    myLocationButton.layer.cornerRadius=3.0;
    [[myLocationButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        if(_userLocation)
        {
            CLLocationCoordinate2D coord=CLLocationCoordinate2DMake(_userLocation.coordinate.latitude, _userLocation.coordinate.longitude);
            _selectedSearchResultPoi=nil;
            [self._mapView setCenterCoordinate:coord animated:YES];
            [self initSearch:_userLocation];
        }
    }];
    
    //地图中心位置坐标
    int coorIconwidth=60;
    int x=(self.mapContainerView.frame.size.width-coorIconwidth)/2+13;
    int y=(self.mapContainerView.frame.size.height-coorIconwidth)/2-8;
    _centerCoorIcon=[[UIImageView alloc]initWithFrame:CGRectMake(x, y, 40, 40)];
    _centerCoorIcon.image=[UIImage imageNamed:@"center_coor"];
    [self.mapContainerView addSubview:_centerCoorIcon];
    
    //列表初始化与设定
    self.nearbyPOITableView=[[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    self.nearbyPOITableView.dataSource=self;
    self.nearbyPOITableView.delegate=self;
    self.nearbyPOITableView.tableHeaderView=self.mapContainerView;
    self.nearbyPOITableView.showsVerticalScrollIndicator=NO;
    self.nearbyPOITableView.bounces=NO;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0, 0.0, 80.0, 0.0);
    [self.nearbyPOITableView setContentInset:contentInsets];
    
    [self.view addSubview:self.nearbyPOITableView];
}

- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    MAAnnotationView *view = views[0];
    
    if ([view.annotation isKindOfClass:[MAUserLocation class]])
    {
        MAUserLocationRepresentation *pre = [[MAUserLocationRepresentation alloc] init];
        pre.fillColor = [UIColor colorWithRed:0.9 green:0.1 blue:0.1 alpha:0.0];
        pre.strokeColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.9 alpha:0];
        pre.image = [UIImage imageNamed:@"userPosition"];
        pre.lineWidth = 3;
        //        pre.lineDashPattern = @[@6, @3];
        
        [self._mapView updateUserLocationRepresentation:pre];
        
        view.calloutOffset = CGPointMake(0, 0);
        view.canShowCallout = NO;
        self.userLocationAnnotationView = view;
    }
}


/**
 *  初始化searchBar与UISearchDisplayController
 */
-(void)initSearchBarAndController
{
    //初始化saerchbar
    self.mSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,44)];
    self.mSearchBar.placeholder = @"输入关键词搜索地点";
    self.mSearchBar.backgroundColor=[UIColor colorWithRed:250 green:250 blue:250 alpha:0.7];
    self.mSearchBar.backgroundImage = [self imageWithColor:[UIColor clearColor] size:self.mSearchBar.bounds.size];
    self.mSearchBar.delegate=self;
    
    //初始化UISearchDisplayController
    self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.mSearchBar contentsController:self];
    //    self.searchController.searchResultsTableView.dataSource=self;
    //    self.searchController.searchResultsTableView.delegate=self;
    self.searchController.searchResultsDataSource = self;
    // searchResultsDelegate 就是 UITableViewDelegate
    self.searchController.searchResultsDelegate = self;
    self.searchController.delegate=self;
    self.searchController.searchResultsTableView.keyboardDismissMode=UIScrollViewKeyboardDismissModeInteractive;
    self.searchController.searchResultsTableView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:self.mSearchBar];
    
    //这里修复搜索结果列表不响应点击事件的Bug
    UITapGestureRecognizer*  tapper = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self action:nil];
    tapper.cancelsTouchesInView = NO;
    [self.searchController.searchResultsTableView addGestureRecognizer:tapper];
}


-(void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardWillHide:(NSNotification*)notification {
    CGFloat height = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    UITableView *tableView = [[self searchDisplayController] searchResultsTableView];
    UIEdgeInsets inset;
    [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? (inset = UIEdgeInsetsMake(0, 0, height, 0)) : (inset = UIEdgeInsetsZero);
    [tableView setContentInset:inset];
    [tableView setScrollIndicatorInsets:inset];
}

#pragma mark 列表的委托方法
/**
 *  列表单个cell的数据源
 *
 *  @param tableView 调用方法的列表
 *  @param indexPath 所请求的indexPath
 *
 *  @return 返回cell
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    AMapPOI *poi;
    if([tableView isEqual:self.nearbyPOITableView])
    {
        if((_selectedSearchResultPoi&&indexPath.section==1)||(!_selectedSearchResultPoi))
        {
            
            
            
            poi=[self.POIArray objectAtIndex:indexPath.row];
            if(poi)
            {
                cell.textLabel.text=poi.name;
                cell.textLabel.textColor=[UIColor blackColor];
                cell.detailTextLabel.text=poi.address;
                cell.detailTextLabel.textColor=[UIColor grayColor];
            }
            
            
        }
        else if(_selectedSearchResultPoi&&indexPath.section==0)
        {
            
            cell.textLabel.text=_selectedSearchResultPoi.name;
            cell.textLabel.textColor=BASE_COLOR;
            cell.detailTextLabel.text=_selectedSearchResultPoi.address;
            cell.detailTextLabel.textColor=[UIColor grayColor];
            
        }
    }
    else if([tableView isEqual:self.searchController.searchResultsTableView])
    {
        poi=[self.keyWordPOIArray objectAtIndex:indexPath.row];
        if(poi)
        {
            cell.textLabel.textColor=[UIColor blackColor];
            cell.textLabel.text=poi.name;
            cell.detailTextLabel.text=poi.address;
            cell.detailTextLabel.textColor=[UIColor grayColor];
        }
        
    }
    
    
    return cell;
}

/**
 *  这个方法实现了地图所在列表的动画效果
 *
 *  @param scrollView <#scrollView description#>
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if([scrollView isEqual:self.nearbyPOITableView])
    {
        CGPoint offset = self.nearbyPOITableView.contentOffset;
        if(offset.y>=0)
        {
            self.mapContainerView.clipsToBounds=YES;
            
            self._mapView.frame=CGRectMake(0, offset.y/2, CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.view.bounds)/1.2);
            int coorIconwidth=60;
            int x1=(self.mapContainerView.frame.size.width-coorIconwidth)/2+12;
            int y1=(self.mapContainerView.frame.size.height-coorIconwidth)/2-8;
            self.centerCoorIcon.frame=CGRectMake(x1, y1+offset.y/2, 40, 40);
        }
        else{
            self.mapContainerView.clipsToBounds=NO;
            float scale=(CGRectGetWidth(self.view.bounds)-offset.y)/CGRectGetWidth(self.view.bounds);
            self._mapView.frame=CGRectMake(0, offset.y, CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.view.bounds)/1.2-offset.y);
            
            
            self._mapView.transform=CGAffineTransformMakeScale(scale, scale);
            
            int coorIconwidth=60;
            int x1=(self.mapContainerView.frame.size.width-coorIconwidth)/2+12;
            int y1=(self.mapContainerView.frame.size.height-coorIconwidth)/2;
            self.centerCoorIcon.frame=CGRectMake(x1, y1+offset.y/2, 40, 40);
            self.centerCoorIcon.transform=CGAffineTransformMakeScale(scale, scale);
        }
    }
}

/**
 *  列表cell的高度
 *
 *  @param tableView 调用该方法的列表
 *  @param indexPath 所请求的indexPath
 *
 *  @return 高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

/**
 *  返回列表每个section的cell的个数
 *
 *  @param tableView 列表
 *  @param section   secion
 *
 *  @return 个数
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([tableView isEqual:self.nearbyPOITableView])
    {
        if(_selectedSearchResultPoi)
        {
            if(section==0)return 1;
            else return self.POIArray.count;
        }else
            return self.POIArray.count;
    }
    
    else
        return self.keyWordPOIArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if([tableView isEqual:self.nearbyPOITableView])
    {
        if(_selectedSearchResultPoi)
        {
            return 2;
        }else
            return 1;
    }
    else
        return 1;
}

/**
 *  TableView中的row被选中时所调用的代理方法
 *
 *  @param tableView 调用该方法的tableView
 *  @param indexPath 所选中的indexPath
 */

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    //如果是周边区域结果的列表
    if([tableView isEqual:self.nearbyPOITableView])
    {
        AMapPOI *poi;
        if(!_selectedSearchResultPoi)
        {
            poi=[self.POIArray objectAtIndex:indexPath.row];
        }
        else
        {
            if(indexPath.section==0)poi=_selectedSearchResultPoi;
            else   poi=[self.POIArray objectAtIndex:indexPath.row];
        }
        
        if(poi)
        {
            KSActivityCreatManager* activityManager=[KSActivityCreatManager sharedManager];
            activityManager.location=[NSString stringWithFormat:@"%@ %@",poi.name,poi.address];
            activityManager.latitude=poi.location.latitude;
            activityManager.longitude=poi.location.longitude;
            [activityManager ks_saveOrUpdate];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    //如果是搜索结果的列表
    else
    {
        _isFromSearch=YES;
        AMapPOI *poi=[self.keyWordPOIArray objectAtIndex:indexPath.row];
        if(poi)
        {
            [self.searchController setActive:NO animated:YES];
            _selectedSearchResultPoi=poi;
            CLLocationCoordinate2D coord=CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
            [self._mapView setCenterCoordinate:coord animated:YES];
            MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
            pointAnnotation.coordinate = coord;
            pointAnnotation.title=poi.name;
            pointAnnotation.subtitle=poi.address;
            AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
            request.location = [AMapGeoPoint locationWithLatitude:coord.latitude longitude:coord.longitude];
            request.sortrule = 0;
            request.radius=100000;
            request.requireExtension = YES;
            [ self._search AMapPOIAroundSearch: request];
            [self._mapView addAnnotation:pointAnnotation];
            [self._mapView selectAnnotation:pointAnnotation animated:YES];
        }
        
    }
}


-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if([tableView isEqual:self.nearbyPOITableView])
    {
        if(!_selectedSearchResultPoi)
        {
            return @"";
        }
        else
        {
            if(section==0)
            {
                return @"选中的地点";
            }
            else
            {
                return @"附近的地点";
            }
        }
    }
    else return @"";
}
#pragma mark 搜索的相关方法
/**
 *  根据关键词发起关键词搜索
 *
 *  @param keyWord 关键词
 */
-(void)searchPOIByKeyWord:(NSString*)keyWord
{
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    request.keywords=keyWord;
    request.sortrule = 0;
    request.requireExtension = YES;
    request.city=self.city;
    
    [ self._search AMapPOIKeywordsSearch: request];
}


#pragma mark 地图控件的相关回调
/**
 *  地图获取用户位置完毕的回调
 *
 *  @param mapView          地图控件
 *  @param userLocation     用户位置
 *  @param updatingLocation 是否在更新用户位置
 */
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        if(!self.hasLocated)
        {
            [self initSearch:userLocation];
            CLLocationCoordinate2D coord=CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
            [self._mapView setCenterCoordinate:coord animated:YES];
            self.hasLocated=YES;
            //构造AMapReGeocodeSearchRequest对象
            AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
            regeo.location = [AMapGeoPoint locationWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
            regeo.radius = 10000;
            regeo.requireExtension = YES;
            _userLocation=userLocation;
            //发起逆地理编码
            [self._search AMapReGoecodeSearch: regeo];
        }
    }
}

-(void)mapView:(MAMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    
}
- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if(_isFromSearch)
        _isFromSearch=NO;
    else
        self.selectedSearchResultPoi=nil;
    NSLog(@"呵呵");
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:self._mapView.centerCoordinate.latitude longitude:self._mapView.centerCoordinate.longitude];
    request.sortrule = 0;
    request.radius=100000;
    request.requireExtension = YES;
    [self._search AMapPOIAroundSearch: request];
}
//实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if(response.regeocode != nil)
    {
        //通过AMapReGeocodeSearchResponse对象处理搜索结果
        if(response.regeocode.addressComponent.city)
        {
            self.city=response.regeocode.addressComponent.city;
        }
        else
        {
            self.city=response.regeocode.addressComponent.province;
        }
        NSString *result = [NSString stringWithFormat:@"ReGeocode: %@", response.regeocode];
        NSLog(@"ReGeo: %@", result);
    }
}


/**
 *  地图标注行为的回调，用于设定地图上出现标注点时的行为
 *
 *  @param mapView    地图控件
 *  @param annotation 标注控件
 *
 *  @return 地图标注
 */
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorPurple;
        return annotationView;
    }
    return nil;
}


/**
 *  首次获取到用户位置之后根据用户的经纬度坐标进行周边搜索
 *
 *  @param userLocation 用户的位置信息
 */
-(void)initSearch:(MAUserLocation*)userLocation
{
    self._search = [[AMapSearchAPI alloc] init];
    self._search.delegate = self;
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
    request.sortrule = 0;
    request.radius=100000;
    request.requireExtension = YES;
    [ self._search AMapPOIAroundSearch: request];
}
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error{
    NSLog(@"AMap search error!");
}

/**
 *  高德地图sdk搜索服务调用完毕的回调
 *
 *  @param request  request
 *  @param response respone
 */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if([request isKindOfClass:[AMapPOIAroundSearchRequest class]])
    {
        if(response.pois.count == 0)
        {
            return;
        }
        self.POIArray=[[NSMutableArray alloc]initWithArray:response.pois];
        [self.nearbyPOITableView reloadData];
    }
    else if ([request isKindOfClass:[AMapPOIKeywordsSearchRequest class]])
    {
        for(int i=0;i<response.suggestion.cities.count;i++)
        {
            AMapCity* city=[response.suggestion.cities objectAtIndex:i];
            NSLog(city.city,nil);
        }
        self.keyWordPOIArray=response.pois;
        [self.searchController.searchResultsTableView reloadData];
    }
    
}
#pragma mark 搜索框的代理方法
/**
 *  搜索框获取焦点的方法，用于改变文字颜色
 *
 *  @param searchBar 搜索框
 */
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{// 修改UISearchBar右侧的取消按钮文字颜色及背景图片
    for (UIView *searchbuttons in [searchBar subviews]){
        if ([searchbuttons isKindOfClass:[UIButton class]]) {
            UIButton *cancelButton = (UIButton*)searchbuttons;			// 修改文字颜色
            [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [cancelButton setBackgroundImage:nil forState:UIControlStateHighlighted];
        }
    }
}

/**
 *  搜索框文字改变的回调，文字改变时进行搜索
 *
 *  @param searchBar  搜索框
 *  @param searchText 搜索框的文字
 */
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self searchPOIByKeyWord:searchText];
}



//取消searchbar背景色
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
