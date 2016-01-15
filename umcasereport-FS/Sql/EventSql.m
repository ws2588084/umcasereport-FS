//
//  EventSql.m
//  umcasereport
//
//  Created by WangShuai on 15/2/3.
//  Copyright (c) 2015年 Topevery. All rights reserved.
//

#import "EventSql.h"
#import "SqlHelper.h"
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

@implementation EventSql

+(void)insertEvent:(ReportEvtInfo *)evt
{
    [self deleteEvent:evt.EvtCode];

    SqlHelper *sqlHelper = [[SqlHelper alloc]init];
//    [sqlHelper execSql:insertSql Binds:binds];
    NSString *insertSql = [NSString stringWithFormat:@"insert into T_EVENT(Title,EvtPos,EvtDesc,CreateTime,AbsX,AbsY,EvtResult,Linkman,LinkPhone)values('%@','%@','%@','%@','%@' ,'%@' ,'%@','%@','%@')",@"",evt.EvtPos,evt.EvtDesc,evt.ReportDate,evt.AbsX,evt.AbsY,@"正在受理",evt.Linkman,evt.LinkPhone];
    [sqlHelper execSql:insertSql];
}

+(NSMutableArray*)selectAllEvent
{
    NSMutableArray *list = [[NSMutableArray alloc]init];
    NSString *selectSql = [NSString stringWithFormat:@"select EvtTitle,EvtPosition,EvtDesc,ReportDate,AbsX,AbsY,EvtTypeId,EvtBigClassId,EvtSmallClassId,SmallClassBZ,EvtStatus,EvtId,ReportStauts,ReportType from T_EVENT ORDER BY id desc"];
    SqlHelper *sqlHelper = [[SqlHelper alloc]init];
//    [sqlHelper execSql:insertSql];
    FMResultSet *res =[sqlHelper prepareSql:selectSql];
//    while ([res next]) {
//        NSDictionary *dic = res.columnNameToIndexMap;
    list = [self GetEventList:res];
//    }
    
    [sqlHelper dbClose];
//    sqlite3_stmt *stmt = [sqlHelper prepareSql:selectSql];
//    if(stmt!=nil)
//    {
//        while (sqlite3_step(stmt) == SQLITE_ROW) {
//            
//            [list addObject:[self GetEventList:stmt]];
//        }
//        return list;
//    }
    return list;
}
+(void)deleteEvent:(NSString*)evtId
{
    NSString *deleteSql = [NSString stringWithFormat:@"delete from T_EVENT where EvtCode='%@'",evtId];
    SqlHelper *sqlHelper = [[SqlHelper alloc]init];
    [sqlHelper execSql:deleteSql];
}
+(NSMutableArray*)GetEventList:(FMResultSet*)res
{
    NSMutableArray *list = [NSMutableArray new];
    while ([res next])
    {
    EventEntity *entity = [EventEntity new];
    NSDictionary *dic = [EntityHelper entityToDictionary:entity];
    for (int i = 0; i < dic.allKeys.count; i++) {
//        char* strColumnName = (char*)sqlite3_column_name(stmt, i);
        NSString *columnName =dic.allKeys[i];
//        //                NSLog(@"%@",[NSString stringWithUTF8String:strColumnName]);
//        
//        //        NSString *destMethodName = [NSString stringWithFormat:@"set%@:",[columnName capitalizedString]]; //capitalizedString返回每个单词首字母大写的字符串（每个单词的其余字母转换为小写）
        NSString *destMethodName = [NSString stringWithFormat:@"set%@:",columnName];
        SEL destMethodSelector = NSSelectorFromString(destMethodName);
//
        if ([entity respondsToSelector:destMethodSelector]) {
//            NSInteger index = (NSInteger)[res.columnNameToIndexMap valueForKey:res.columnNameToIndexMap.allKeys[i]];
            if(![res columnIsNull:columnName])
            {
            NSString *value = [res stringForColumn:columnName];
//            char* strValue = (char*)sqlite3_column_text(stmt, i);
//            NSString* value = @"";
//            if(strValue!=NULL)
//                value = [NSString stringWithUTF8String:strValue];
            if(![value isEqual: @"(null)"])
            {
                [entity performSelector:destMethodSelector withObject:value];
            }else
            {
                [entity performSelector:destMethodSelector withObject:nil];
            }}
        }
    }
        [list addObject:entity];
    }
    return list;
}
//+(EventEntity*)GetEventList:(sqlite3_stmt*)stmt
//{
//    EventEntity *entity = [EventEntity new];
//    for (int i = 0; i < sqlite3_column_count(stmt); i++) {
//        char* strColumnName = (char*)sqlite3_column_name(stmt, i);
//        NSString *columnName =[NSString stringWithUTF8String:strColumnName];
//        //                NSLog(@"%@",[NSString stringWithUTF8String:strColumnName]);
//        
////        NSString *destMethodName = [NSString stringWithFormat:@"set%@:",[columnName capitalizedString]]; //capitalizedString返回每个单词首字母大写的字符串（每个单词的其余字母转换为小写）
//        NSString *destMethodName = [NSString stringWithFormat:@"set%@:",columnName];
//        SEL destMethodSelector = NSSelectorFromString(destMethodName);
//        
//        if ([entity respondsToSelector:destMethodSelector]) {
//            char* strValue = (char*)sqlite3_column_text(stmt, i);
//            NSString* value = @"";
//            if(strValue!=NULL)
//            value = [NSString stringWithUTF8String:strValue];
//            if(![value isEqual: @"(null)"])
//            {
//                [entity performSelector:destMethodSelector withObject:value];
//            }else
//            {
//                [entity performSelector:destMethodSelector withObject:nil];
//            }
//        }
//    }
//    return entity;
//}

+(void)insertFile:(EvtFile*)file
{
//    NSString *insertSql = [NSString stringWithFormat:@"insert into T_EVENT_FILE"
//                           @"(FID,NAME,FDATA,EvtCode)"
//                           @"values('%@','%@',?,'%@')",file.ID,file.FileName,file.EvtCode];
    SqlHelper *sqlHelper = [[SqlHelper alloc]init];
    [sqlHelper execFileSql:file];
}

+(NSMutableArray*)selectFileList:(NSString *)EvtId fileType:(NSNumber*)fileType
{
    NSMutableArray *list = [[NSMutableArray alloc]init];
    NSString *selectSql = [NSString stringWithFormat:@"select FDATA from T_EVENT_FILE where EvtId = '%@'",EvtId];
    SqlHelper *sqlHelper = [[SqlHelper alloc]init];
    //    [sqlHelper execSql:insertSql];
    if(fileType!=nil)
    {
        selectSql = [NSString stringWithFormat:@"%@ and FileType='%@'",selectSql,fileType];
    }
    FMResultSet *res= [sqlHelper prepareSql:selectSql];
    while ([res next]) {
        [list addObject:[res dataForColumnIndex:0]];
    }
    [sqlHelper dbClose];
    
//    sqlite3_stmt *stmt = [sqlHelper prepareSql:selectSql];
//    if(stmt!=nil)
//    {
//        while (sqlite3_step(stmt) == SQLITE_ROW) {
////            EvtFile *file= [[EvtFile alloc]init];
////            char* fileId   = (char*)sqlite3_column_text(stmt, 0);
////            file.ID = [NSString stringWithUTF8String:fileId];
////            char* fileName   = (char*)sqlite3_column_text(stmt, 1);
////            file.FileName = [NSString stringWithUTF8String:fileName];
////            char* fileData   = (char*)sqlite3_column_database_name(stmt, 2);
////            Byte * value = (Byte*)sqlite3_column_blob(getimg, 2);
////            file.fileData = [NSData alloc]initw;
////            [list addObject:file];
//            int bytes = sqlite3_column_bytes(stmt, 0);
//            Byte * value = (Byte*)sqlite3_column_blob(stmt, 0);
//            if (bytes !=0 && value != NULL)
//            {
//                NSData * data = [NSData dataWithBytes:value length:bytes];
//                [list addObject:data];
//            }
//        }
//    }
    return list;
}
+(void)deleteFile:(NSString*)evtId
{
    NSString *deleteSql = [NSString stringWithFormat:@"delete from T_EVENT_FILE where EvtId='%@'",evtId];
    SqlHelper *sqlHelper = [[SqlHelper alloc]init];
    [sqlHelper execSql:deleteSql];
}

@end
