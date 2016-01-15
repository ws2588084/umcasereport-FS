//
//  HttpFileUpload.h
//  umclient
//
//  Created by Alex.Wang on 14-3-28.
//  Copyright (c) 2014年 Alex.Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface FileDetail : NSObject

@property(strong,nonatomic) NSString *name;
@property(strong,nonatomic) NSData *data;

+(FileDetail *)fileWithName:(NSString *)name data:(NSData *)data;

@end

@interface HttpFileUpload : NSObject

+(id)upload:(NSString *)url widthParams:(NSDictionary *)params;

@end

