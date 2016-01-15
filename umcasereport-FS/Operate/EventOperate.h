//
//  ReportEventOperate.h
//  CSGL
//
//  Created by WangShuai on 15/1/30.
//  Copyright (c) 2015年 topevery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventEntity.h"
#import "WebServiveInteraction.h"
#import "EntityHelper.h"
#import "ReportEventEntity.h"

typedef void (^result)(ReportEventResult* result);
typedef void (^resultGetEvtDetailResult)(GetEvtDetailResult* resultGetEvtDetailResult);
typedef void (^files)(NSMutableArray *files);
typedef void (^evtRes)(EvtRes *evtRes);
typedef void (^entitys)(NSMutableArray *entitys);

@interface EventOperate : NSObject

/*案件上报
 Event 案件信息
 invokeSuccessBlock 上报返回结果
 invokeFailedBlock 上报失败
 */
+(void)ReportEvent:(ReportEventPara*)Event successBlock:(result)invokeSuccessBlock  failedBlock:(MethodInvokeFailedBlock)invokeFailedBlock;

/*获得案件详情
 Para 查询条件
 invokeSuccessBlock 查询返回结果
 invokeFailedBlock 查询失败
 */
+(void)GetEvtDetail:(GetEvtDetailPara*)Para successBlock:(resultGetEvtDetailResult)invokeSuccessBlock  failedBlock:(MethodInvokeFailedBlock)invokeFailedBlock;

/*获取案件附件信息
 EvtId 案件id
 invokeSuccessBlock 上报返回结果
 invokeFailedBlock 上报失败
 */
+(void)GetEvtFiles:(NSInteger)EvtId successBlock:(files)invokeSuccessBlock  failedBlock:(MethodInvokeFailedBlock)invokeFailedBlock;

/*随手拍案件上报
 evtRes 案件信息
 invokeSuccessBlock 上报返回结果
 invokeFailedBlock 上报失败
 */
+(void)ReportEvtInfo:(ReportEvtInfo*)Event successBlock:(evtRes)invokeSuccessBlock  failedBlock:(MethodInvokeFailedBlock)invokeFailedBlock;

/*获得案件详情
 Para 查询条件
 invokeSuccessBlock 查询返回结果
 invokeFailedBlock 查询失败
 */
+(void)GetSSPEvtDetail:(ReportEvtInfo*)Event successBlock:(evtRes)invokeSuccessBlock  failedBlock:(MethodInvokeFailedBlock)invokeFailedBlock;

/*获得案件历史记录
 Para 查询条件
 invokeSuccessBlock 查询返回结果
 invokeFailedBlock 查询失败
 */
+(void)GetReportHistry:(ReportEvtInfo*)Event successBlock:(entitys)invokeSuccessBlock  failedBlock:(MethodInvokeFailedBlock)invokeFailedBlock;

@end
