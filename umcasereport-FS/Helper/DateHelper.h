//
//  DateHelper.h
//  TopeveryEO
//
//  Created by WangShuai on 14/11/22.
//  Copyright (c) 2014年 Topevery. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateHelper : NSData

+(NSString*)GetStringForDate:(NSDate *)Date type:(NSString *)typeString;
+(NSDate*)GetDateForString:(NSString *)DateString type:(NSString *)typeString;

@end
