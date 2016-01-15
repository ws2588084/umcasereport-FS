//
//  EventListMapView.m
//  CSGL
//
//  Created by WangShuai on 15/1/27.
//  Copyright (c) 2015年 topevery. All rights reserved.
//

#import "EventListMapView.h"
//#import "EventMapView.h"
#import "MapItem.h"
#import "EventDetailedView.h"

@interface EventListMapView ()

@end

@implementation EventListMapView

- (void)viewDidLoad {
    viewWidth = [[UIScreen mainScreen] bounds].size.width;
    _Events = [[NSMutableArray alloc]init];
    for (int i =0; i<10; i++) {
        MapItem *item = [[MapItem alloc]initX:22.53996 Y:113.980667 + ((float)i/1000)];
        [_Events addObject:item];
    }
    
    _topView = [[QMapView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, self.view.frame.size.height)];
    _topView.delegate = self;
    [_topView setUserTrackingMode:QUserTrackingModeFollow animated:YES];
//    [_topView setZoomLevel:12];
    [_topView setShowsUserLocation:YES];
//    [self.view addSubview:_topView];
    self.view = _topView;
    [self createPoint];
    
    /*案件列表信息，暂时不使用
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 200 - 64, viewWidth, self.view.frame.size.height - 200)];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    */
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backItem;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)createPoint
{
    NSMutableArray *annotations = [NSMutableArray array];
    //22.53996
    //113.980667
    double x = 0;
    double y = 0;
    for (int i = 0; i<_Events.count; i++) {
        MapItem *item = _Events[i];
        QPointAnnotation *Point = [[QPointAnnotation alloc]init];
        if(item.x > x)
        {
            x = item.x;
        }
        if(item.y > y)
        {
            y = item.y;
        }
        Point.coordinate = CLLocationCoordinate2DMake(item.x, item.y);
        Point.title = [NSString stringWithFormat:@"龙华案件第20150101号%d",i];
        Point.subtitle = [NSString stringWithFormat:@"{%f, %f}", Point.coordinate.latitude, Point.coordinate.longitude];
        
        if(QMapRectContainsPoint(_topView.visibleMapRect, QMapPointForCoordinate(Point.coordinate)))
        {
            //            NSLog(@"%d",i);
            [annotations addObject:Point];
            [_topView addAnnotation:Point];
        }
        //        NSLog(@"%f",item.y);
    }
    //    [self.mapView addAnnotations:annotations];
}
-(QAnnotationView*)mapView:(QMapView *)mapView viewForAnnotation:(id<QAnnotation>)annotation
{
    if ([annotation isKindOfClass:[QPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        QPinAnnotationView *annotationView = (QPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        
        if (annotationView == nil)
        {
            annotationView = [[QPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        annotationView.animatesDrop     = NO;
        annotationView.draggable        = NO;
        annotationView.canShowCallout   = YES;
        annotationView.selected = YES;
        //        annotationView.rightCalloutAccessoryView = nil;
        //        annotationView.highlighted = NO;
        
        annotationView.pinColor =QPinAnnotationColorRed;
        
        //        [self.mapView.annotations indexOfObject:annotation];
        //        annotationView.image = [UIImage imageNamed:@"greenPin_lift"];
//        annotationView.leftCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
//        [leftBtn setTitle:@"详情" forState:UIControlStateNormal];
//        leftBtn.backgroundColor = [UIColor redColor];
        [leftBtn setImage:[UIImage imageNamed:@"iconfont-xiangxi"] forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(showDetail) forControlEvents:UIControlEventTouchUpInside];
        annotationView.leftCalloutAccessoryView = leftBtn;
        
        return annotationView;
    }
    
    return nil;
}

-(void)showDetail
{
    EventDetailedView *map = [[EventDetailedView alloc]init];
    map.Events = [[NSMutableArray alloc]init];
    MapItem *item = [[MapItem alloc]initX:22.53996 Y:113.980667];
    [map.Events addObject:item];
    [self.navigationController pushViewController:map animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellName = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        //案件标题
        UILabel *lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(8, 8, viewWidth - 16, 20)];
        lblTitle.text = @"龙华案件第20150813号";
        lblTitle.font = [UIFont systemFontOfSize:15];
        lblTitle.textColor = [UIColor blueColor];
        [cell addSubview:lblTitle];
        
        //案件信息
        UILabel *lblContent = [[UILabel alloc]initWithFrame:CGRectMake(8, 32, viewWidth - 16, 50)];
        
        lblContent.numberOfLines = 0;
        lblContent.font = [UIFont fontWithName:@"Chalkboard SE" size:14];//[UIFont systemFontOfSize:13];
        lblContent.text = @"晚上6、7点到凌晨5、6点有人从长排村三排二栋推车子到二排九栋楼下摆卖炒田螺炒米粉深夜扰民，请责任单位尽快处理。";
        lblContent.lineBreakMode = NSLineBreakByWordWrapping;
        CGSize size = [lblContent sizeThatFits:CGSizeMake(lblContent.frame.size.width, MAXFLOAT)];
        lblContent.frame = CGRectMake(lblContent.frame.origin.x, lblContent.frame.origin.y, lblContent.frame.size.width, size.height);
        
        [cell addSubview:lblContent];
        
        //案件时间
        UILabel *rightTitle = [[UILabel alloc]initWithFrame:CGRectMake(8, size.height + 8 + lblContent.frame.origin.y, viewWidth - 16, 20)];
        rightTitle.text = @"2015.01.20 12:14:22";
        
        rightTitle.font = [UIFont systemFontOfSize:13];
        rightTitle.textColor = [UIColor lightGrayColor];
        [cell addSubview:rightTitle];
        
        cell.frame = CGRectMake(0, 0, viewWidth, rightTitle.frame.origin.y + rightTitle.frame.size.height);
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EventDetailedView *map = [[EventDetailedView alloc]init];
    map.Events = [[NSMutableArray alloc]init];
    MapItem *item = [[MapItem alloc]initX:22.53996 Y:113.980667 + (float)indexPath.row/1000];
    [map.Events addObject:item];
    [self.navigationController pushViewController:map animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)mapView:(QMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
}
-(void)mapView:(QMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    //    NSLog(@"%f",mapView.centerCoordinate.latitude);
    //
    //    NSLog(@"%f,%f - %f,%f",mapView.region.center.latitude,mapView.region.center.longitude,mapView.region.span.latitudeDelta,mapView.region.span.longitudeDelta);
    [self createPoint];
    //    mapView.annotations.count
    if(_Events.count>1)
    {
        for(QPointAnnotation *point in mapView.annotations)
        {
            if(!QMapRectContainsPoint(_topView.visibleMapRect, QMapPointForCoordinate(point.coordinate)))
            {
                [mapView viewForAnnotation:point].hidden = YES;
            }
            else
            {
                [mapView viewForAnnotation:point].hidden = NO;
            }
        }
    }
    //    NSLog(@"%@",mapView.annotations);
    //    NSMutableArray *points = [[NSMutableArray alloc]initWithArray:mapView.annotations];
    //    for (int i = 0; i<_Events.count; i++) {
    //        MapItem *item = _Events[i];
    //        QPointAnnotation *Point = [[QPointAnnotation alloc]init];
    //
    //        Point.coordinate = CLLocationCoordinate2DMake(item.x, item.y);
    //        Point.title = [NSString stringWithFormat:@"龙华案件第20150101号%d",i];
    //        Point.subtitle = [NSString stringWithFormat:@"{%f, %f}", Point.coordinate.latitude, Point.coordinate.longitude];
    //
    //        [self.mapView addAnnotation:Point];
    //    }
    
    //    mapView.visibleMapRect
    //    [mapView.region QMapRectContainsPoint:mapView.visibleMapRect ]
    //    [mapView.region.span]
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
