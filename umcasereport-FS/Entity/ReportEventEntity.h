//
//  ReportEventEntity.h
//  umcasereport
//
//  Created by WangShuai on 15/2/4.
//  Copyright (c) 2015年 Topevery. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReportEventEntity : NSObject

@end
@interface ReportEvtInfo : NSObject

@property (nonatomic,strong) NSString *Linkman;
@property (nonatomic,strong) NSString *LinkPhone;
@property (nonatomic,strong) NSString *EvtPos;
@property (nonatomic,strong) NSString *EvtDesc;
@property (nonatomic,strong) NSNumber *AbsX;
@property (nonatomic,strong) NSNumber *AbsY;
@property (nonatomic,strong) NSNumber *GeoX;
@property (nonatomic,strong) NSNumber *GeoY;
@property (nonatomic,strong) NSMutableArray *Attachs;
@property (nonatomic,strong) NSString *EvtResult;
@property (nonatomic,strong) NSString *EvtCode;
@property (nonatomic,strong) NSNumber *HandleType;
@property (nonatomic,strong) NSString *ReportDate;
@property (nonatomic,strong) NSNumber *IsReceipt;
@property (nonatomic,strong) NSString *Summary;
@property (nonatomic,strong) NSString *DistrictID;
@property (nonatomic,strong) NSString *StreetID;
@property (nonatomic,strong) NSNumber *ReciveType;
@property (nonatomic,strong) NSNumber *PageIndex;

@end

@interface EvtRes : NSObject

@property (nonatomic,strong) NSNumber *IsSuccess;
@property (nonatomic,strong) NSString *ErrorMessage;
@property (nonatomic,strong) NSString *EvtCode;
@property (nonatomic,strong) ReportEvtInfo *EvtPara;
@property (nonatomic,strong) NSMutableArray *FlowInfos;
@property (nonatomic,strong) NSNumber *RecordCount;

@end

@interface EvtFile : NSObject

@property (nonatomic,strong) NSString *ID;
@property (nonatomic,strong) NSString *FileName;
@property (nonatomic,strong) NSData *fileData;
@property (nonatomic,strong) NSString *EvtId;
@property (nonatomic,strong) NSString *EvtCode;

@end