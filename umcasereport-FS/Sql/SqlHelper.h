//
//  SqlHelper.h
//  umcasereport
//
//  Created by WangShuai on 15/2/3.
//  Copyright (c) 2015年 Topevery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "ReportEventEntity.h"
#import "FMDatabase.h"

@interface SqlHelper : NSObject
{
    sqlite3 *db;
    FMDatabase *fdb;
}

-(void)CreateDB;
-(void)execSql:(NSString *)sql;
-(void)execSql:(NSString *)sql Binds:(NSMutableArray*)Binds;
-(void)execFileSql:(EvtFile *)file;
-(FMResultSet*)prepareSql:(NSString *)sql;
-(void)createTable;
-(void)dbClose;

@end
