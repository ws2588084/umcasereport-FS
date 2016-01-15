//
//  EnumView.h
//  CSGL
//
//  Created by WangShuai on 15/1/27.
//  Copyright (c) 2015年 topevery. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, EventListType) {
    //上报历史案件
    ReproEvent = 1,
    //全部待办案件
    AllToDoEvent = 0
};

@interface EnumView : NSObject

@end
