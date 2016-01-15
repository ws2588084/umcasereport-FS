//
//  PublicHelper.m
//  TopeveryEO
//
//  Created by WangShuai on 14/11/22.
//  Copyright (c) 2014年 Topevery. All rights reserved.
//

#import "PublicHelper.h"

@implementation PublicHelper

///自适应字体高度
+ (CGFloat)getHeightWithString:(NSString *)aStr WithSize:(CGSize)aSize WithFont:(UIFont *)aFont
{
    CGRect rect;
    
    if ([[[UIDevice currentDevice] systemVersion]floatValue]>=7)//IOS 7.0 以上
    {
        NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:aFont, NSFontAttributeName,nil];
        
        rect = [aStr boundingRectWithSize:aSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:tdic context:nil];
    }
    else
    {
        rect.size = [aStr sizeWithFont:aFont constrainedToSize:aSize lineBreakMode:NSLineBreakByCharWrapping];
    }
    return rect.size.height;
}

+ (UIImage*)imageWithColor:(UIColor *)color frame:(CGRect)aFrame
{
    aFrame = CGRectMake(0, 0, aFrame.size.width, aFrame.size.height);
    UIGraphicsBeginImageContext(aFrame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, aFrame);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (NSString *)getWeek:(NSInteger)week
{
    switch (week) {
        case 1:
            return @"星期一";
        case 2:
            return @"星期二";
        case 3:
            return @"星期三";
        case 4:
            return @"星期四";
        case 5:
            return @"星期五";
        case 6:
            return @"星期六";
        case 7:
            return @"星期日";
            
        default:
            return @"";
    }
}

+ (NSString*)checkUpdateWithAPPID
{
    if(![self networkStateChange])
        return nil;
    //获取当前应用版本号
    NSDictionary *appInfo = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [appInfo objectForKey:@"CFBundleVersion"];
    //在app story 中的应用ID 测试id:896337163
    NSString *AppleId = @"1031840589";
    if(AppleId.length<1)
        return nil;
    NSString *updateUrlString = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",AppleId];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:updateUrlString]];
    
    [request setHTTPMethod:@"GET"];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:returnData options:0 error:nil];
    NSArray *ary = [jsonData objectForKey:@"results"];
    if(ary.count > 0)
    {
    NSDictionary *releaseInfo = ary[0];
    NSString *latestVersion = [releaseInfo objectForKey:@"version"];//版本号
    
    NSString *trackViewUrl1 = [releaseInfo objectForKey:@"trackViewUrl"];//地址trackViewUrl
    
    //    NSString *trackName = [releaseInfo objectForKey:@"trackName"];//应用程序名称
    if([currentVersion doubleValue]<[latestVersion doubleValue])
    {
        return trackViewUrl1;
    }
    }
    return nil;
}

+ (void)CreateSetting
{
    //获取路径对象
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //获取完整路径
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"Setting.plist"];
    
    NSMutableDictionary *dictplist = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
    if(dictplist == nil)
    {
        dictplist= [NSMutableDictionary new];
    //设置属性值
//        [dictplist setObject:@"192.168.3.21/FoShan.WebService" forKey:@"HttpIP"];
        [dictplist setObject:@"119.145.135.251/fsum" forKey:@"HttpIP"];
    [dictplist setObject:@"" forKey:@"UserName"];
    [dictplist setObject:@"" forKey:@"UserPhone"];
    //写入文件
    [dictplist writeToFile:plistPath atomically:YES];
    }
}
+ (NSString*)GetSettingValue:(NSString *)key
{
//    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Setting" ofType:@"plist"];
    
    //获取路径对象
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //获取完整路径
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"Setting.plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
    NSString *value = [data valueForKey:key];
    return value;
}
+ (void)UpdateSettingValue:(NSString *)key value:(NSString *)value
{
//    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Setting" ofType:@"plist"];
    //获取路径对象
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    //获取完整路径
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"Setting.plist"];
//    NSMutableDictionary *data = [[[NSMutableDictionary alloc]initWithContentsOfFile:plistPath] mutableCopy];
////    NSString *val = [data valueForKey:key];
////    val = value;
//    [data setObject:value forKey:key];
//    [data writeToFile:plistPath atomically:YES];
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)       objectAtIndex:0]stringByAppendingPathComponent:@"Setting.plist"];
    NSMutableDictionary *applist = [
                                    [NSMutableDictionary alloc]initWithContentsOfFile:path];
//    NSString *name = [applist objectForKey:key];
//    name = @"山山";
    [applist setObject:value forKey:key];
    [applist writeToFile:path atomically:YES];
    
}
+ (id)GetAddress:(NSString *)key type:(NSInteger)type
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Address" ofType:@"plist"];
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
    //获得区名称集合
    if(type == 0)
    {
        NSArray *value = [data valueForKey:@"districtNames"];
        return value;
    }
    //获得区districtNames
    if(type == 1)
    {
        NSMutableDictionary *value = [data valueForKey:@"district"];
        return value;
    }
    //获得街道
    if(type == 2)
    {
        NSDictionary *streetDic = [data valueForKey:@"street"];
        NSMutableDictionary *value = [streetDic valueForKey:key];
        return value;
    }
    return nil;
}
#pragma mark 包大小转换工具类（将包大小转换成合适单位）
+(NSString *)getDataSizeString:(int) nSize
{
    NSString *string = nil;
    if (nSize<1024)
    {
        string = [NSString stringWithFormat:@"%dB", nSize];
    }
    else if (nSize<1048576)
    {
        string = [NSString stringWithFormat:@"%dK", (nSize/1024)];
    }
    else if (nSize<1073741824)
    {
        if ((nSize%1048576)== 0 )
        {
            string = [NSString stringWithFormat:@"%dM", nSize/1048576];
        }
        else
        {
            int decimal = 0; //小数
            NSString* decimalStr = nil;
            decimal = (nSize%1048576);
            decimal /= 1024;
            
            if (decimal < 10)
            {
                decimalStr = [NSString stringWithFormat:@"%d", 0];
            }
            else if (decimal >= 10 && decimal < 100)
            {
                int i = decimal / 10;
                if (i >= 5)
                {
                    decimalStr = [NSString stringWithFormat:@"%d", 1];
                }
                else
                {
                    decimalStr = [NSString stringWithFormat:@"%d", 0];
                }
                
            }
            else if (decimal >= 100 && decimal < 1024)
            {
                int i = decimal / 100;
                if (i >= 5)
                {
                    decimal = i + 1;
                    
                    if (decimal >= 10)
                    {
                        decimal = 9;
                    }
                    
                    decimalStr = [NSString stringWithFormat:@"%d", decimal];
                }
                else
                {
                    decimalStr = [NSString stringWithFormat:@"%d", i];
                }
            }
            
            if (decimalStr == nil || [decimalStr isEqualToString:@""])
            {
                string = [NSString stringWithFormat:@"%dMss", nSize/1048576];
            }
            else
            {
                string = [NSString stringWithFormat:@"%d.%@M", nSize/1048576, decimalStr];
            }
        }
    }
    else	// >1G
    {
        string = [NSString stringWithFormat:@"%dG", nSize/1073741824];
    }
    
    return string;
}

+(BOOL)IsNetwork:(NSString *)url
{
//    Reachability *rech = [Reachability reachabilityWithHostName:url];
//    NSLog(@"%ld",(long)rech.currentReachabilityStatus);
//    [rech startNotifier];
//    return rech.startNotifier;
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStateChange) name:kReachabilityChangedNotification object:nil];
//    Reachability *conn = [Reachability reachabilityForInternetConnection];
//    [conn startNotifier];
    return [self networkStateChange];
}
+(BOOL)networkStateChange
{
    // 1.检测wifi状态
    Reachability *wifi = [Reachability reachabilityForLocalWiFi];
    // 2.检测手机是否能上网络(WIFI\3G\2.5G)
    Reachability *conn = [Reachability reachabilityForInternetConnection];
    if([wifi currentReachabilityStatus] != NotReachable)
    {
        NSLog(@"wifi");
        return YES;
    }else if([conn currentReachabilityStatus]!= NotReachable)
    {
        NSLog(@"手机网络");
        return YES;
    }
    else
    {
        NSLog(@"没有网络");
    }
    return NO;
}

@end
