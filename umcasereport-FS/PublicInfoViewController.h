//
//  PublicInfoViewController.h
//  umcasereport-FS
//
//  Created by WangShuai on 15/9/21.
//  Copyright © 2015年 Topevery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewController.h"
#import "PublicHelper.h"

@interface PublicInfoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    CGFloat viewWidth;
    CGFloat viewHeight;
    UITableView *table;
    NSArray *names;
    NSArray *imgs;
    NSArray *urls;
    NSMutableDictionary *dic;
    NSMutableDictionary *urlDic;
}


@end
