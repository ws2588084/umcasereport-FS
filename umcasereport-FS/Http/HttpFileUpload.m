//
//  HttpFileUpload.m
//  umclient
//
//  Created by Alex.Wang on 14-3-28.
//  Copyright (c) 2014年 Alex.Wang. All rights reserved.
//

#import "HttpFileUpload.h"

@implementation FileDetail
+(FileDetail *)fileWithName:(NSString *)name data:(NSData *)data {
    FileDetail *file = [[self alloc] init];
    file.name = name;
    file.data = data;
    return file;
}
@end

@implementation HttpFileUpload

#define BOUNDARY @"----------cH2gL6ei4Ef1KM7cH2KM7ae0ei4gL6"

+(id)upload:(NSString *)url widthParams:(NSDictionary *)params {
    
    NSError *err = nil;
//    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Setting" ofType:@"plist"];
//    NSMutableDictionary *data = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
    NSString *IP = [PublicHelper GetSettingValue:@"HttpIP"];
    //服务地址
    if(url.length<=0)
        url = [NSString stringWithFormat:@"http://%@/ashx/AttachUpload.ashx",IP];
    
    NSMutableURLRequest *httpRequest = [ [NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:0];
    [httpRequest setHTTPMethod:@"POST"];
    [httpRequest setValue:[@"multipart/form-data; boundary=" stringByAppendingString:BOUNDARY] forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    NSTimeInterval timeInterval = 0;
    
    for(NSString *key in params) {
        id content = [params objectForKey:key];
        if ([content isKindOfClass:[NSString class]] || [content isKindOfClass:[NSNumber class]]) {
            NSString *param = [NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n%@\r\n",BOUNDARY,key,content,nil];
            [body appendData:[param dataUsingEncoding:NSUTF8StringEncoding]];
        } else if([content isKindOfClass:[FileDetail class]]) {
            FileDetail *file = (FileDetail *)content;
            NSString *param = [NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\";filename=\"%@\"\r\nContent-Type: application/octet-stream\r\n\r\n",BOUNDARY,key,file.name,nil];
            [body appendData:[param dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:file.data];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            timeInterval += 10;
        }
    }
    NSString *endString = [NSString stringWithFormat:@"--%@--",BOUNDARY];
    [body appendData:[endString dataUsingEncoding:NSUTF8StringEncoding]];
    [httpRequest setHTTPBody:body];
    [httpRequest setTimeoutInterval:timeInterval];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:httpRequest returningResponse:nil error:&err];
    return returnData;
    
    /*id jsonObj = [NSJSONSerialization JSONObjectWithData:returnData options:noErr error:nil];
    return jsonObj*/;
}

@end
