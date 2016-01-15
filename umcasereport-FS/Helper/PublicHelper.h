//
//  PublicHelper.h
//  TopeveryEO
//
//  Created by WangShuai on 14/11/22.
//  Copyright (c) 2014年 Topevery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface PublicHelper : NSObject


+ (CGFloat)getHeightWithString:(NSString *)aStr WithSize:(CGSize)aSize WithFont:(UIFont *)aFont;

+ (UIImage*)imageWithColor:(UIColor*)color frame:(CGRect)aFrame;

+ (NSString*)getWeek:(NSInteger)week;
//检查版本更新,如果有新版本，则返回下载地址
+ (NSString*)checkUpdateWithAPPID;

+ (void)CreateSetting;

//根据key获得setting配置文件中的内容
+ (NSString*)GetSettingValue:(NSString*)key;

//根据key修改setting配置文件中的值
+ (void)UpdateSettingValue:(NSString*)key value:(NSString*)value;

+ (id)GetAddress:(NSString *)key type:(NSInteger)type;
//将db值大小转换为合适的单位 以1024为一个单位基础
+(NSString *)getDataSizeString:(int) nSize;

+(BOOL)IsNetwork:(NSString *)url;
@end
