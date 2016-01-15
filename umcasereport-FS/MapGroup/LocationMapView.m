//
//  LocationView.m
//  CSGL
//
//  Created by WangShuai on 15/1/24.
//  Copyright (c) 2015年 topevery. All rights reserved.
//

#import "LocationMapView.h"
#import "ReprotView.h"

@interface LocationMapView ()

@end

@implementation LocationMapView

- (void)viewDidLoad {
    self.title = @"定位";
    float viewWidth = [[UIScreen mainScreen]bounds].size.width;
    _mapView = [[QMapView alloc]initWithFrame:CGRectMake(0, 0, viewWidth, self.view.frame.size.height)];
    _mapView.delegate = self;
    _mapView.zoomLevel = 13;
    [_mapView setUserTrackingMode:QUserTrackingModeFollow];
    [_mapView setShowsUserLocation:YES];
    //    [self.view addSubview:_mapView];
    self.view = _mapView;
    
    UIImageView *pinImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"iconfont-pin"]];
    pinImg.frame = CGRectMake(viewWidth/2-15, _mapView.frame.size.height/2-64, 30, 30);
//    pinImg.center = self.navigationController.view.center;
    [self.view addSubview:pinImg];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"选择" style:UIBarButtonItemStyleDone target:self action:@selector(selected)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)mapView:(QMapView *)mapView didUpdateUserLocation:(QUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
//    [_mapView setShowsUserLocation:NO];
    NSLog(@"%f,%F -- %f,%f",_mapView.userLocation.location.coordinate.latitude,userLocation.coordinate.longitude,_mapView.centerCoordinate.latitude,_mapView.centerCoordinate.longitude);
}
-(void)mapViewDidStopLocatingUser:(QMapView *)mapView
{
}
-(void)selected
{
//    TabBarView *tabBarView = (TabBarView*)[self.navigationController.viewControllers objectAtIndex:0];
//    ReprotView *view = [tabBarView.viewControllers objectAtIndex:0];
//    [view selectGps:_mapView.userLocation.coordinate];
    [self.navigationController popViewControllerAnimated:YES];
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
