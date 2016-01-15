//
//  ReprotRecordList.h
//  CSGL
//
//  Created by WangShuai on 15/1/22.
//  Copyright (c) 2015年 topevery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnumView.h"
#import "EventOperate.h"
#import "ReportEventEntity.h"
#import "PublicHelper.h"

@interface EventListView : UITableViewController
{
    float viewWidth;
    UIView *NullTableView;
    UIAlertView *alertTopView;
    
    NSInteger pageIndex;
    NSInteger recordCount;
}
//@property (nonatomic) EventListType type;
@property(strong,nonatomic) NSMutableArray *flows;
-(void)GetEventList;

@end
