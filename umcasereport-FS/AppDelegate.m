//
//  AppDelegate.m
//  umcasereport-FS
//
//  Created by WangShuai on 15/7/2.
//  Copyright (c) 2015年 Topevery. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    SqlHelper *sql = [[SqlHelper alloc]init];
    [sql createTable];
    
    //GYYKRwnRQoyIUwwmb6L989Rd
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:@"GYYKRwnRQoyIUwwmb6L989Rd"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
//    RightViewController *rightView = [RightViewController new];
//    RootViewController* rootViewController = [RootViewController new];
//    SlideNavigationController *nav = [[SlideNavigationController alloc]initWithRootViewController:rootViewController];
//    nav.navigationBar.barTintColor = [[UIColor alloc]initWithRed:0.355469 green:0.692694 blue:0.944596 alpha:1];
//    rootViewController.title = @"全民城管";
//    [SlideNavigationController sharedInstance].rightMenu = rightView;
    //    nav.title = @"全民城管";
    
    CityManagemantViewController *cityView = [CityManagemantViewController new];
    cityView.title = @"全民城管";
    UINavigationController *nav= [[UINavigationController alloc]initWithRootViewController:cityView];
    nav.title = @"全民城管";
    nav.tabBarItem.image = [UIImage imageNamed:@"iconfont-gangtie"];
    
    PublicInfoViewController *info = [PublicInfoViewController new];
    info.title = @"信息公开";
    UINavigationController *nav2= [[UINavigationController alloc]initWithRootViewController:info];
    nav2.title = @"信息公开";
    nav2.tabBarItem.image = [UIImage imageNamed:@"iconfont-dingdanxinxi"];
    
    AboutViewController *about = [AboutViewController new];
    about.title = @"系统";
    UINavigationController *nav3 = [[UINavigationController alloc]initWithRootViewController:about];
    nav3.title = @"系统";
    nav3.tabBarItem.image = [UIImage imageNamed:@"iconfont-gerenxinxi"];
    
    UITabBarController *tabBar = [UITabBarController new];
    tabBar.viewControllers = [NSArray arrayWithObjects:nav,nav2,nav3, nil];
    self.window.rootViewController = tabBar;
    
    [PublicHelper CreateSetting];
    
//        [PublicHelper UpdateSettingValue:@"HttpIP" value:@"192.168.3.21/FoShan.WebService"];
    [PublicHelper UpdateSettingValue:@"HttpIP" value:@"119.145.135.251/fsum"];
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
