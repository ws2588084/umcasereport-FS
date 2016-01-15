//
//  WebViewController.h
//  smfwt
//
//  Created by EightLong on 14-10-21.
//  Copyright (c) 2014年 topevery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

@interface WebViewController : UIViewController<CLLocationManagerDelegate,UIWebViewDelegate,UIAlertViewDelegate,BMKGeoCodeSearchDelegate,BMKLocationServiceDelegate>
{
    
    IBOutlet UIWebView *web;
    IBOutlet UIActivityIndicatorView *indictor;
    BMKGeoCodeSearch *search;
    BMKLocationService *_locService;
}

@property (nonatomic,readwrite) NSURL *url;
@property (nonatomic,nonatomic) CLLocationManager *locationManager;

@end
