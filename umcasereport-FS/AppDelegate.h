//
//  AppDelegate.h
//  umcasereport-FS
//
//  Created by WangShuai on 15/7/2.
//  Copyright (c) 2015年 Topevery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
//#import <BaiduMapAPI/BMapKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "SqlHelper.h"
#import "SlideNavigationController.h"
#import "RightViewController.h"
#import "PublicInfoViewController.h"
#import "AboutViewController.h"
#import "CityManagemantViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    BMKMapManager* _mapManager;
}

@property (strong, nonatomic) UIWindow *window;


@end

