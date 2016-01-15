//
//  LocationBaiDuMapView.h
//  umcasereport
//
//  Created by WangShuai on 15/2/1.
//  Copyright (c) 2015年 Topevery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

@interface LocationBaiDuMapView : UIViewController<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKPoiSearchDelegate,BMKGeoCodeSearchDelegate,UITableViewDataSource,UITableViewDelegate>
{
    float viewWidth;
//    BMKMapView *_mapView;
    BMKLocationService *_locService;
    BMKGeoCodeSearch *_searcher;
    UITableView *listAddress;
    NSMutableArray *addressListPoi;
    BMKPoiInfo *myPoi;
    BMKPointAnnotation *pointAnnotation;
    UIView *LoadView;
    UIActivityIndicatorView *load;
    BMKAddressComponent *myAddressComponent;
}
@property (nonatomic,strong)BMKMapView *mapView;

@end
