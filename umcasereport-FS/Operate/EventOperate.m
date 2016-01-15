//
//  ReportEventOperate.m
//  CSGL
//
//  Created by WangShuai on 15/1/30.
//  Copyright (c) 2015年 topevery. All rights reserved.
//

#import "EventOperate.h"
#import "EntityHelper.h"

@implementation EventOperate

+(void)ReportEvent:(ReportEventPara *)Event successBlock:(result)invokeSuccessBlock failedBlock:(MethodInvokeFailedBlock)invokeFailedBlock
{
    WebServiveInteraction *inter = [[WebServiveInteraction alloc]init];
    inter.methodName = @"ReportEvtInfo";
    inter.entityName = @"ReportEvtInfoResult";
    [inter invoke:30 successBlock:^(NSArray *output) {
        ReportEventResult *evt = [[ReportEventResult alloc]init];
        
        NSMutableDictionary *Entity = output[0];
        [EntityHelper dictionaryToEntity:Entity entity:evt];
        invokeSuccessBlock(evt);
    } failedBlock:^(NSString *errMsg) {
        invokeFailedBlock(errMsg);
    }];
}

+(void)GetEvtDetail:(GetEvtDetailPara*)Para successBlock:(resultGetEvtDetailResult)invokeSuccessBlock  failedBlock:(MethodInvokeFailedBlock)invokeFailedBlock
{
    WebServiveInteraction *inter = [[WebServiveInteraction alloc]init];
    inter.methodName = @"GetEvtDetail";
    inter.entityName = @"GetEvtDetailResult";
    [inter invoke:30 successBlock:^(NSArray *output) {
        GetEvtDetailResult *result = [[GetEvtDetailResult alloc]init];
        
        NSMutableDictionary *Entity = output[0];
        [EntityHelper dictionaryToEntity:Entity entity:result];
        invokeSuccessBlock(result);
    } failedBlock:^(NSString *errMsg) {
        invokeFailedBlock(errMsg);
    }];
}

+(void)GetEvtFiles:(NSInteger)EvtId successBlock:(files)invokeSuccessBlock  failedBlock:(MethodInvokeFailedBlock)invokeFailedBlock
{
    WebServiveInteraction *inter = [[WebServiveInteraction alloc]init];
    inter.para = [NSString stringWithFormat:@"<evtId>%ld</evtId>",(long)EvtId];
    inter.methodName = @"GetEvtFiles";
    inter.entityName = @"GetEvtFilesResult";
    
    [inter invoke:30 successBlock:^(NSArray *output) {
        NSMutableArray *result = [[NSMutableArray alloc]init];
        
        NSLog(@"%ld",(unsigned long)output.count);
        NSMutableDictionary *Entity = output[0];
        [EntityHelper dictionaryToEntity:Entity entity:result];
        invokeSuccessBlock(result);
    } failedBlock:^(NSString *errMsg) {
        invokeFailedBlock(errMsg);
    }];
}
+(void)ReportEvtInfo:(ReportEvtInfo*)Event successBlock:(evtRes)invokeSuccessBlock  failedBlock:(MethodInvokeFailedBlock)invokeFailedBlock
{
//    NSDictionary *dic = [EntityHelper getObjectData:Event];
    
    NSData *data = [EntityHelper getJSON:Event options:0 error:nil];
    
    WebServiveInteraction *inter = [[WebServiveInteraction alloc]init];
    inter.para = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    inter.para = [NSString stringWithFormat:@"<s>%@</s>",inter.para];
    inter.methodName = @"ReportEvtInfo";
    inter.entityName = @"ReportEvtInfoResult";
    [inter invoke:30 successBlock:^(NSArray *output) {
        EvtRes *evt = [[EvtRes alloc]init];
        
        NSMutableDictionary *Entity = output[0];
        [EntityHelper dictionaryToEntity:Entity entity:evt];
        //        evt.EvtPara = [ReportEventEntity new];
        
//        ReportEvtInfo *evtInfo = [ReportEvtInfo new];
//        NSDictionary *evtPara = [Entity objectForKey:@"EvtPara"];
//        [EntityHelper dictionaryToEntity:evtPara entity:evtInfo];
//        evt.EvtPara = evtInfo;
        
        NSString *IsSuccess = [Entity objectForKey:@"IsSuccess"];
        
        if([IsSuccess boolValue])
        {
            evt.EvtCode = [Entity objectForKey:@"EvtCode"];
            invokeSuccessBlock(evt);
        }
        else
        {
            NSString *ErrorMessage = [Entity objectForKey:@"ErrorMessage"];
            invokeFailedBlock(ErrorMessage);
        }
    } failedBlock:^(NSString *errMsg) {
        invokeFailedBlock(errMsg);
    }];
}
+(void)GetSSPEvtDetail:(ReportEvtInfo*)Event successBlock:(evtRes)invokeSuccessBlock  failedBlock:(MethodInvokeFailedBlock)invokeFailedBlock
{
    NSData *data = [EntityHelper getJSON:Event options:0 error:nil];
    WebServiveInteraction *inter = [[WebServiveInteraction alloc]init];
    inter.para = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    inter.para = [NSString stringWithFormat:@"<s>%@</s>",inter.para];
    inter.methodName = @"GetEvtInfo";
    inter.entityName = @"GetEvtInfoResult";
    [inter invoke:30 successBlock:^(NSArray *output) {
        EvtRes *evt = [[EvtRes alloc]init];
        ReportEvtInfo *evtInfo = [ReportEvtInfo new];
        
        NSMutableDictionary *Entity = output[0];
        [EntityHelper dictionaryToEntity:Entity entity:evt];
        NSDictionary *evtPara = [Entity objectForKey:@"EvtPara"];
        [EntityHelper dictionaryToEntity:evtPara entity:evtInfo];
        evt.EvtPara = evtInfo;
        invokeSuccessBlock(evt);
    } failedBlock:^(NSString *errMsg) {
        invokeFailedBlock(errMsg);
    }];

}

/*获得案件历史记录
 Para 查询条件
 invokeSuccessBlock 查询返回结果
 invokeFailedBlock 查询失败
 */
+(void)GetReportHistry:(ReportEvtInfo*)Event successBlock:(entitys)invokeSuccessBlock  failedBlock:(MethodInvokeFailedBlock)invokeFailedBlock
{
    NSData *data = [EntityHelper getJSON:Event options:0 error:nil];
    
    WebServiveInteraction *inter = [[WebServiveInteraction alloc]init];
    inter.para = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    inter.para = [NSString stringWithFormat:@"<s>%@</s>",inter.para];
    inter.methodName = @"GetReportHistry";
    inter.entityName = @"GetReportHistryResult";
    [inter invoke:30 successBlock:^(NSArray *output) {
        NSMutableArray *ary = [NSMutableArray new];
        NSMutableDictionary *dic = output[0];
        NSArray *list = [dic objectForKey:@"evtParaCol"];
        for (int i = 0; i<list.count; i++) {
            
            ReportEvtInfo *evt = [[ReportEvtInfo alloc]init];
            NSMutableDictionary *Entity = list[i];
            [EntityHelper dictionaryToEntity:Entity entity:evt];
            [ary addObject:evt];
        }
        
        invokeSuccessBlock(ary);
    } failedBlock:^(NSString *errMsg) {
        invokeFailedBlock(errMsg);
    }];
}

@end
