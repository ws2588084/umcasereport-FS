//
//  EventSql.h
//  umcasereport
//
//  Created by WangShuai on 15/2/3.
//  Copyright (c) 2015年 Topevery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "EventEntity.h"
#import "ReportEventEntity.h"
#import "FMDatabase.h"
#import "EntityHelper.h"

@interface EventSql : NSObject

+(void)insertEvent:(ReportEvtInfo*)Event;
+(NSMutableArray*)selectAllEvent;
+(void)deleteEvent:(NSString*)evtId;

+(void)insertFile:(EvtFile*)file;
+(NSMutableArray*)selectFileList:(NSString *)EvtId fileType:(NSNumber*)fileType;
+(void)deleteFile:(NSString*)evtId;

@end
