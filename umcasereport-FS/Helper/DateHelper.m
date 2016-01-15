//
//  DateHelper.m
//  TopeveryEO
//
//  Created by WangShuai on 14/11/22.
//  Copyright (c) 2014年 Topevery. All rights reserved.
//

#import "DateHelper.h"

@implementation DateHelper

+(NSString*)GetStringForDate:(NSDate *)Date type:(NSString *)typeString
{
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    df.dateFormat=typeString;
    return [df stringFromDate:Date];
}
+(NSDate*)GetDateForString:(NSString *)DateString type:(NSString *)typeString
{
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    df.dateFormat=typeString;
    return [df dateFromString:DateString];
}

@end
