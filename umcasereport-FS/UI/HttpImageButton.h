//
//  HttpImageButton.h
//  umcasereport
//
//  Created by WangShuai on 15/2/3.
//  Copyright (c) 2015年 Topevery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ImagesFroScroll.h"
#import "PublicHelper.h"

@interface HttpImageButton : UIButton<NSURLConnectionDelegate>
{
    NSMutableData *webData;
}

@property (nonatomic,strong) NSURLConnection *conn;
@property (nonatomic,strong)NSMutableData *data;
@property (nonatomic,strong)NSURLResponse *response;
@property (nonatomic,strong)UIView *LoadView;
@property (nonatomic,strong) id<HttpToDataDelegate>httpToDataDelegate;
-(void)LoadBtnImage:(NSString *)ImageIp;

@end
