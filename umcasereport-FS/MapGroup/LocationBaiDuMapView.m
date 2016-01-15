//
//  LocationBaiDuMapView.m
//  umcasereport
//
//  Created by WangShuai on 15/2/1.
//  Copyright (c) 2015年 Topevery. All rights reserved.
//

#import "LocationBaiDuMapView.h"
#import "ReprotView.h"
#import "CLLocation+YCLocation.h"

@interface LocationBaiDuMapView ()

@end

@implementation LocationBaiDuMapView

-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _searcher.delegate = nil;
}
- (void)viewDidLoad {
    self.title = @"我的位置";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    viewWidth = [[UIScreen mainScreen]bounds].size.width;
//    self.view = _mapView;
    [self defaultView];
    //定位
//    //设置定位精确度，默认：kCLLocationAccuracyBest
//    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
//    //指定最小距离更新(米)，默认：kCLDistanceFilterNone
//    [BMKLocationService setLocationDistanceFilter:100.f];
    
    
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    //设置定位精确度，默认：kCLLocationAccuracyBest
    _locService.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    //指定最小距离更新(米)，默认：kCLDistanceFilterNone
    _locService.distanceFilter = 100.0f;
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"选择" style:UIBarButtonItemStyleDone target:self action:@selector(selGps)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

-(void)defaultView
{
    float mapHeight = 240;
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 64, viewWidth, mapHeight)];
    _mapView.centerCoordinate = CLLocationCoordinate2DMake(22.536379,114.066518);
    _mapView.delegate = self;
    [_mapView setZoomLevel:14];
    [self.view addSubview:_mapView];
    
    listAddress = [[UITableView alloc]initWithFrame:CGRectMake(0, 64 + mapHeight, viewWidth, self.view.frame.size.height - 64 - mapHeight)];
    listAddress.delegate = self;
    listAddress.dataSource = self;
    [self.view addSubview:listAddress];
    
    UIImageView *pinImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"iconfont-pin"]];
    pinImg.frame = CGRectMake(viewWidth/2-15, _mapView.frame.size.height/2+32, 30, 30);
    //    pinImg.center = self.navigationController.view.center;
    [self.view addSubview:pinImg];
    LoadView  = [[UIView alloc]initWithFrame:listAddress.frame];
    LoadView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    load = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(viewWidth/2-20, LoadView.frame.size.height/2-20, 40,40)];
    load.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    
    load.color = [UIColor orangeColor];
    [load startAnimating];
//    lblLoad.center = LoadView.center;
    [LoadView addSubview:load];
    [self.view addSubview:LoadView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //NSLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    _mapView.showsUserLocation = YES;//显示定位图层
    
    [_mapView updateLocationData:userLocation];
    [_mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    
    //初始化检索对象
    _searcher =[[BMKGeoCodeSearch alloc]init];
    _searcher.delegate = self;
    //发起反向地理编码检索
    CLLocationCoordinate2D pt = userLocation.location.coordinate;
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[
    BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_searcher reverseGeoCode:reverseGeoCodeSearchOption];
    
    if(flag)
    {
      NSLog(@"反geo检索发送成功");
    }
    else
    {
      NSLog(@"反geo检索发送失败");
    }
    [_locService stopUserLocationService];

//    NSLog(@"123");
    //NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
}

-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
      if (error == BMK_SEARCH_NO_ERROR) {
          for (int i = 0; i<result.poiList.count; i++) {
//              BMKPoiInfo *poi = result.poiList[i];
//              NSLog(@"poi-%@",poi.name);
          }
//          NSLog(@"result.address%@",result.address);
          myPoi = [[BMKPoiInfo alloc]init];
          myPoi.address = result.address;
          myPoi.name = @"[我的位置]";
          myPoi.pt = result.location;
          myPoi.city = result.addressDetail.city;
          addressListPoi = [[NSMutableArray alloc]initWithArray:result.poiList];
          myAddressComponent = result.addressDetail;
//          addressListPoi = result.poiList;
          [addressListPoi setObject:myPoi atIndexedSubscript:0];
          
          [listAddress reloadData];
          [UIView animateWithDuration:0.3 animations:^{
              LoadView.alpha = 0;
          } completion:^(BOOL finished) {
              LoadView.hidden = YES;
          }];
      }
      else {
          NSLog(@"抱歉，未找到结果");
      }
}
-(void)didStopLocatingUser
{
//    NSLog(@"结束");
}
-(void)willStartLocatingUser
{
//    NSLog(@"开始");
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return addressListPoi.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellName = @"";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    
    if(cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
    }
    BMKPoiInfo *poi = addressListPoi[indexPath.row];
    cell.textLabel.text = poi.name;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.text = poi.address;
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BMKPoiInfo *poi = addressListPoi[indexPath.row];
    pointAnnotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor = poi.pt;
    pointAnnotation.coordinate = coor;
    pointAnnotation.title = @"选择的内容点";
    pointAnnotation.subtitle = @"点";
    myPoi = poi;
    
    [_mapView removeAnnotations:_mapView.annotations];
    [_mapView addAnnotation:pointAnnotation];

    [_mapView setCenterCoordinate:poi.pt animated:YES];
}
-(BMKAnnotationView*)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    //普通annotation
    NSString *AnnotationViewID = @"renameMark";
    BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        // 设置颜色
//        annotationView.pinColor = BMKPinAnnotationColorPurple;
        // 从天上掉下效果
        annotationView.animatesDrop = NO;
        // 设置可拖拽
        annotationView.draggable = NO;
        annotationView.image = [UIImage imageNamed:@"iconfont-dian"];
        annotationView.centerOffset = CGPointMake(0.9, 0.9);
    }
    return annotationView;
}
-(void)selGps
{
    ReprotView *view = [self.navigationController.viewControllers objectAtIndex:0];
    if(myPoi==nil)
        [view selectGps:_mapView.centerCoordinate address:nil pose:@""];
    else
        [view selectGps:myPoi.pt address:myAddressComponent pose:myPoi.address];
    [self.navigationController popToViewController:view animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
