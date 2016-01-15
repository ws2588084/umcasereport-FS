//
//  EventListMapView.h
//  CSGL
//
//  Created by WangShuai on 15/1/27.
//  Copyright (c) 2015年 topevery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QMapKit/QMapKit.h>
#import "EnumView.h"

@interface EventListMapView : UIViewController<UITableViewDataSource,UITableViewDelegate,QMapViewDelegate>
{
    CGFloat viewWidth;
    QMapView *_topView;
}
@property (nonatomic) EventListType type;
@property (nonatomic,strong) NSMutableArray *Events;

@end
