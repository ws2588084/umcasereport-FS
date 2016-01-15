//
//  EventEntity.h
//  CSGL
//
//  Created by WangShuai on 15/1/27.
//  Copyright (c) 2015年 topevery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MethodInput.h"
#import "MethodOut.h"

@interface EventEntity : NSObject

@property (nonatomic,strong) NSString *EvtId;
@property (nonatomic,strong) NSString *Title;
@property (nonatomic,strong) NSString *typeName;
@property (nonatomic,strong) NSString *regionName;
@property (nonatomic,strong) NSDate *acceptTime;
@property (nonatomic,strong) NSString *srcName;
@property (nonatomic,strong) NSString *levelName;
@property (nonatomic,strong) NSString *reportName;
@property (nonatomic,strong) NSString *reportPhone;
@property (nonatomic,strong) NSString *Position;
@property (nonatomic) double AbsX;
@property (nonatomic) double AbsY;
@property (nonatomic,strong) NSString *EventDesc;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSMutableArray *Attachs;
@property (nonatomic,strong) NSString *EventStatus;
@property (nonatomic,strong) NSString *EvtCode;

@end

@interface ReportEventPara : NSObject

@property (nonatomic,strong) NSUUID *ID;
@property (nonatomic,strong) NSUUID *PartID;
@property (nonatomic,strong) NSString *PartCode;
@property (nonatomic,strong) NSNumber *ProbSource;
@property (nonatomic,strong) NSNumber *ClassTypeId;
@property (nonatomic,strong) NSNumber *ClassBigId;
@property (nonatomic,strong) NSNumber *ClassSmallId;
@property (nonatomic,strong) NSString *Position;
@property (nonatomic,strong) NSString *Description;
@property (nonatomic,strong) NSNumber *GeoX;
@property (nonatomic,strong) NSNumber *GeoY;
@property (nonatomic,strong) NSNumber *AbsX;
@property (nonatomic,strong) NSNumber *AbsY;
@property (nonatomic,strong) NSMutableArray *Attachs;
@property (nonatomic,strong) NSString *DeptName;
@property (nonatomic,strong) NSString *GridCode;
@property (nonatomic,strong) NSNumber *MapId;
@property (nonatomic,strong) NSString *RoadLevel;

@end

@interface GetEvtDetailPara : MethodInput

@property (nonatomic,strong) NSNumber *ID;
@property (nonatomic,strong) NSNumber *ActInstId;
@property (nonatomic,strong) NSNumber *TaskType;

@end

@interface GetEvtDetailResult : MethodOut
@property (nonatomic,strong) NSMutableArray *Attachs;

@end

@interface AttachInfo : MethodInput

@property (nonatomic,strong) NSString *Id;
@property (nonatomic,strong) NSString *Name;
@property (nonatomic,strong) NSNumber *Type;
@property (nonatomic,strong) NSNumber *UsageType;
@property (nonatomic,strong) NSString *Uri;
@property (nonatomic,strong) NSString *CreateDate;
@property (nonatomic,strong) NSString *IsChecked;
@property (nonatomic,strong) NSString *Uploaded;
@property (nonatomic,strong) NSNumber *GeoX;
@property (nonatomic,strong) NSNumber *GeoY;
@property (nonatomic,strong) NSNumber *AbsX;
@property (nonatomic,strong) NSNumber *AbsY;
-(NSString*)toAttachInfo;

@end

@interface ReportEventResult : MethodOut

@property (nonatomic,strong) NSString *EventId;
@property (nonatomic,strong) NSString *EventTitle;

@end



