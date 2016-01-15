//
//  WebViewController.m
//  smfwt
//
//  Created by EightLong on 14-10-21.
//  Copyright (c) 2014年 topevery. All rights reserved.
//

#import "WebViewController.h"
#import "PublicHelper.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    
    indictor.hidden = YES;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
//    self.locationManager.distanceFilter = 1600;
    [self.locationManager startUpdatingLocation];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backItem;
    
//    search = [[BMKGeoCodeSearch alloc]init];
//    _locService = [[BMKLocationService alloc]init];
//    _locService.delegate = self;
//    [_locService startUserLocationService];
//    search.delegate = self;
    NSLog(@"%@",self.url);
    if([PublicHelper IsNetwork:self.url.absoluteString])
    {
    NSURLRequest *rep= [NSURLRequest requestWithURL:self.url];
    [web loadRequest:rep];
    }
    else
    {
        [self errorAlert];
    }
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    [_locService stopUserLocationService];
//    BMKReverseGeoCodeOption *option = [[BMKReverseGeoCodeOption alloc]init];
//    
//    option.reverseGeoPoint = userLocation.location.coordinate;
//    [search reverseGeoCode:option];
    NSLog(@"%f,%f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [indictor stopAnimating];
    indictor.hidden = YES;
    if([error code] != NSURLErrorCancelled)
    {
        [self errorAlert];
    }
}
-(void)errorAlert
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"内容有误，请检查网络连接，或者复制内容使用浏览器打开！" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"复制", nil];
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"复制"])
    {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.url.path;
//        NSLog(@"%@",self.url.path);
    }
    [self back];
}
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [indictor startAnimating];
    indictor.hidden = NO;
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [indictor stopAnimating];
    indictor.hidden = YES;
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
//-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
//{
//    NSLog(@"123");
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
