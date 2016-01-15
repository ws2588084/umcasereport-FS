//
//  AboutViewController.h
//  umcasereport-FS
//
//  Created by WangShuai on 15/9/7.
//  Copyright (c) 2015年 Topevery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RightViewController.h"
#import "WebViewController.h"

@interface AboutViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *cellTestList;
    CGFloat viewWidth;
    CGFloat viewHeight;
}
@property (nonatomic,strong) UITableView *tableView;
@end
