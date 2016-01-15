//
//  GGViewController.h
//  TopeveryEO
//
//  Created by WangShuai on 14/11/11.
//  Copyright (c) 2014年 Topevery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewController.h"

@interface GGViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UILabel *lblNo;
    
    IBOutlet UITableView *TableGG;
    
    IBOutlet NSMutableArray *ary;
    NSMutableArray *urlAry;
}
-(IBAction)EditClick:(id)sender;

@end
