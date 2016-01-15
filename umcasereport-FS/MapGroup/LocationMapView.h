//
//  LocationView.h
//  CSGL
//
//  Created by WangShuai on 15/1/24.
//  Copyright (c) 2015年 topevery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QMapKit/QMapKit.h>

@interface LocationMapView : UIViewController<QMapViewDelegate>
{
    QPinAnnotationView *pin;
}
@property (nonatomic,strong) QMapView *mapView;;

@end
