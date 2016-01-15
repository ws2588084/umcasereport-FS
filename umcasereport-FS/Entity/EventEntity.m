//
//  EventEntity.m
//  CSGL
//
//  Created by WangShuai on 15/1/27.
//  Copyright (c) 2015年 topevery. All rights reserved.
//

#import "EventEntity.h"
#import "EntityHelper.h"
#import "MethodOut.h"

@implementation EventEntity

@end

@implementation GetEvtDetailPara : MethodInput

@end

@implementation GetEvtDetailResult:MethodOut

-(void)setAttachs:(NSMutableArray *)Attachs
{
    _Attachs = [[NSMutableArray alloc]init];
    for (int i =0; i<Attachs.count; i++) {
        AttachInfo *attach = [[AttachInfo alloc]init];
        NSMutableDictionary *Entity = Attachs[i];
        [EntityHelper dictionaryToEntity:Entity entity:attach];
        [_Attachs addObject:attach];
    }
//    _Attachs = Attachs;
}

@end

@implementation AttachInfo

-(id)init
{
    self = [super init];
    if(self != nil)
    {
        self.MethodName = @"AttchInfo";
    }
    return self;
}
-(NSString*)toAttachInfo
{
    NSMutableString *ModelString = [[NSMutableString alloc]init];
    [ModelString appendString:[EntityHelper modelToPara:@"Id" paraValue: _Id ]];
    [ModelString appendString:[EntityHelper modelToPara:@"Name" paraValue:_Name]];
    [ModelString appendString:[EntityHelper modelToParaNumber:@"Type" paraValue:_Type]];
    [ModelString appendString:[EntityHelper modelToParaNumber:@"UsageType" paraValue:_UsageType]];
    [ModelString appendString:[EntityHelper modelToPara:@"Uri" paraValue:_Uri]];
//    [ModelString appendString:[EntityHelper modelToPara:@"CreateDate" paraValue:_CreateDate]];
    [ModelString appendString:[EntityHelper modelToPara:@"IsChecked" paraValue:_IsChecked]];
    [ModelString appendString:[EntityHelper modelToPara:@"Uploaded" paraValue:_Uploaded]];
    [ModelString appendString:[EntityHelper modelToParaNumber:@"GeoX" paraValue:_GeoX]];
    [ModelString appendString:[EntityHelper modelToParaNumber:@"GeoY" paraValue:_GeoY]];
    [ModelString appendString:[EntityHelper modelToParaNumber:@"AbsX" paraValue:_AbsX]];
    [ModelString appendString:[EntityHelper modelToParaNumber:@"AbsY" paraValue:_AbsY]];

    NSString *para = [NSString stringWithFormat:
                      @"<AttachInfo>%@</AttachInfo>",ModelString];
    return para;
}

@end
@implementation ReportEventResult:MethodOut
-(void)setEventId:(NSString*)EventId
{
    _EventId = EventId;
}
-(void)setEventTitle:(NSString *)EventTitle
{
    _EventTitle = EventTitle;
}
@end
