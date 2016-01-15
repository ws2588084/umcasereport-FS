//
//  RightViewController.h
//  umcasereport-FS
//
//  Created by WangShuai on 15/7/4.
//  Copyright (c) 2015年 Topevery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublicHelper.h"

@interface RightViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    CGSize viewSize;
    NSArray *aryOne;
    NSArray *aryTwo;
    NSString *updUrl;
}
@property (nonatomic, strong)UITableView *tableView;

@end
