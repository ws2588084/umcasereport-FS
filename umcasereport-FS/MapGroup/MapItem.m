//
//  MapItem.m
//  CSGL
//
//  Created by WangShuai on 15/1/22.
//  Copyright (c) 2015年 topevery. All rights reserved.
//

#import "MapItem.h"

@implementation MapItem
-(instancetype)initX:(double)X Y:(double)Y
{
    self = [super self];
    if(self)
    {
        _x = X;
        _y = Y;
    }
    return self;
}

@end
