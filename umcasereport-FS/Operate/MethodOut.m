//
//  MethodOut.m
//  TopeveryEO
//
//  Created by WangShuai on 14/11/13.
//  Copyright (c) 2014年 Topevery. All rights reserved.
//

#import "MethodOut.h"

@implementation MethodOut
-(void)setIsSucess:(NSString *)IsSucess
{
    _Error = [IsSucess boolValue];
    _IsSucess = IsSucess;
}
@end
