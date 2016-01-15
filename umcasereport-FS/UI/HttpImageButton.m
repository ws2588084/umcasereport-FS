//
//  HttpImageButton.m
//  umcasereport
//
//  Created by WangShuai on 15/2/3.
//  Copyright (c) 2015年 Topevery. All rights reserved.
//

#import "HttpImageButton.h"

@implementation HttpImageButton

-(void)LoadBtnImage:(NSString *)ImageIp
{
    _data = [[NSMutableData alloc] init];
    //服务地址
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@%@",[PublicHelper GetSettingValue:@"HttpIP"],ImageIp]];
    if(ImageIp.length>0)
    {
        NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
        
        // 创建连接
        self.conn = [[NSURLConnection alloc] initWithRequest:req delegate:self startImmediately:YES];
        if (self.conn)
        {
            webData = [NSMutableData data];
        }
    }
}

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response{
    NSLog(@"111111111111111");
    //可以在显示图片前先用本地的一个loading.gif来占位。
    UIImage *img = [[UIImage alloc] initWithContentsOfFile:@"post_image_loding"];
    [self setImage:img forState:UIControlStateNormal];
    
    //保存接收到的响应对象，以便响应完毕后的状态。
    _response = response;
}
- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data {
    NSLog(@"22222222222222");
    //_data为NSMutableData类型的私有属性，用于保存从网络上接收到的数据。
    //也可以从此委托中获取到图片加载的进度。
    [_data appendData:data];
    NSLog(@"%lld%%", data.length/_response.expectedContentLength * 100);
}
- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error{
    //请求异常，在此可以进行出错后的操作，如给UIImageView设置一张默认的图片等。
    NSLog(@"33333333333333");
}
- (void)connectionDidFinishLoading:(NSURLConnection*)connection{
    NSLog(@"444444444444444");
    //加载成功，在此的加载成功并不代表图片加载成功，需要判断HTTP返回状态。
    NSHTTPURLResponse*response=(NSHTTPURLResponse*)_response;
    if(response.statusCode == 200){
        //请求成功
        UIImage *img=[UIImage imageWithData:_data];
        [self setImage:img forState:UIControlStateNormal];
    }
    [_httpToDataDelegate finishImgData:_data];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
