//
//  SqlHelper.m
//  umcasereport
//
//  Created by WangShuai on 15/2/3.
//  Copyright (c) 2015年 Topevery. All rights reserved.
//

#import "SqlHelper.h"
#define DBNAME    @"personinfo.sqlite"
#define NAME      @"name"
#define AGE       @"age"
#define ADDRESS   @"address"
#define TABLENAME @"PERSONINFO"

@implementation SqlHelper

-(void)CreateDB
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *database_path = [documents stringByAppendingPathComponent:DBNAME];
    fdb = [FMDatabase databaseWithPath:database_path];
    if(![fdb open])
    {
        NSLog(@"数据库打开失败");
        return;
    }
    
    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documents = [paths objectAtIndex:0];
//    NSString *database_path = [documents stringByAppendingPathComponent:DBNAME];
//    
//    if (sqlite3_open([database_path UTF8String], &db) != SQLITE_OK) {
//        sqlite3_close(db);
//        NSLog(@"数据库打开失败");
//    }
//    else
//    {
//        [self createTable];
//        sqlite3_close(db);
//    }
}
-(void)execSql:(NSString *)sql
{
    [self CreateDB];
    if(![fdb executeUpdate:sql])
    {
        NSLog(@"%@",[fdb lastErrorMessage]);
    }
    [fdb close];
//    char *err;
//    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
////        NSString *str= [NSString stringWithUTF8String:err];
//        sqlite3_close(db);
//        NSLog(@"%@",sql);
//        NSLog(@"数据库操作数据失败!");
//    }
//    sqlite3_close(db);
}
-(void)execSql:(NSString *)sql Binds:(NSMutableArray*)Binds
{
    [self CreateDB];
    
    if(![fdb executeUpdate:sql withArgumentsInArray:Binds])
    {
        NSLog(@"%@",[fdb lastErrorMessage]);
    }
    [fdb close];
//    [self CreateDB];
//    sqlite3_stmt * stmt;
//    if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, NULL) == SQLITE_OK)
//    {
//        for (int i = 1; i<=Binds.count; i++) {
//            sqlite3_bind_text(stmt, i, [Binds[i-1] UTF8String], -1, NULL);
//        }
//        if( sqlite3_step(stmt) == SQLITE_DONE)
//        {
//            NSLog(@"已经写入数据");
//        }
//        sqlite3_finalize(stmt);
//    }
}
-(void)execFileSql:(EvtFile *)file
{
    [self CreateDB];
//    const  char * sequel = "insert into test_table(name,image) values(?,?)";
    NSString *insertSql = [NSString stringWithFormat:@"insert into T_EVENT_FILE"
                           @"(FID,NAME,FDATA,EvtCode)"
                           @"values('%@','%@',?,'%@')",file.ID,file.FileName,file.EvtCode];
    if(![fdb executeUpdate:insertSql,file.fileData])
    {
        NSLog(@"%@",[fdb lastErrorMessage]);
    }
    [fdb close];
//    const char * sequel = "nsert into T_EVENT_FILE(FID,NAME,FDATA,EvtCode) values(?,?,?,?)";
//    sqlite3_stmt * update;
//    if (sqlite3_prepare_v2(db, [insertSql UTF8String], -1, &update, NULL) == SQLITE_OK)
//    {
//        sqlite3_bind_blob(update, 1, [file.fileData bytes], (int)[file.fileData length], NULL);
//        if( sqlite3_step(update) == SQLITE_DONE)
//        {
//            NSLog(@"已经写入数据");
//        }
//        sqlite3_finalize(update);
//    }
}
-(FMResultSet*)prepareSql:(NSString *)sql
{
    [self CreateDB];
    
    FMResultSet *res = [fdb executeQuery:sql];
//    [fdb close];
    return res;
//    sqlite3_stmt * statement;
//    if(sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, nil) == SQLITE_OK)
//    {
//        return statement;
//    }
//    return nil;
}

-(void)createTable
{
    
//    sqlite3_stmt * statement;
    [self CreateDB];
    NSString *sqlTableName = @"select count(*) from sqlite_master where type='table' and name='T_EVENT'";
    FMResultSet *res = [fdb executeQuery:sqlTableName];
    int count = 0;
    if([res next])
    {
        count = [res intForColumnIndex:0];
        if(count <= 0)
        {
            NSString *sqlCreateTable = @"CREATE TABLE T_EVENT (id INTEGER PRIMARY KEY AUTOINCREMENT, Title TEXT, EvtPos TEXT, EvtDesc TEXT, ReportDate TEXT, AbsX FLOAT, AbsY FLOAT, EvtResult TEXT,EvtId TEXT,EvtCode TEXT,Linkman TEXT,LinkPhone TEXT)";
            if(![fdb executeUpdate:sqlCreateTable])
            {
                NSLog(@"%@",[fdb lastErrorMessage]);
            }
        }
    }

    sqlTableName = @"select count(*) from sqlite_master where type='table' and name='T_EVENT_FILE'";
    res = [fdb executeQuery:sqlTableName];
    count = 0;
    if([res next])
    {
        count = [res intForColumnIndex:0];
        if(count <= 0)
        {
            NSString *sqlCreateTable = @"CREATE TABLE T_EVENT_FILE (id INTEGER PRIMARY KEY AUTOINCREMENT, FID TEXT, NAME TEXT, FDATA TEXT, EvtID TEXT, EvtCode TEXT)";
            if(![fdb executeUpdate:sqlCreateTable])
            {
                NSLog(@"%@",[fdb lastErrorMessage]);
            }
        }
    }
    
    [fdb close];
}
-(void)dbClose
{
    [fdb close];
}

@end
