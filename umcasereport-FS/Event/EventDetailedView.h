//
//  EventDetailedView.h
//  FSGZT
//
//  Created by WangShuai on 15/6/3.
//  Copyright (c) 2015年 Topevery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventEntity.h"

@interface EventDetailedView : UITableViewController
{
    CGFloat viewWidth;
}
@property (nonatomic,strong) EventEntity *EventDetail;

@end
