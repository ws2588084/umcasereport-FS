//
//  AboutViewController.m
//  umcasereport-FS
//
//  Created by WangShuai on 15/9/7.
//  Copyright (c) 2015年 Topevery. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    viewWidth = [[UIScreen mainScreen]bounds].size.width;
    viewHeight = [[UIScreen mainScreen]bounds].size.height;
    UIImageView *backImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    backImg.image = [UIImage imageNamed:@"背景2.jpg"];
    [self.view addSubview:backImg];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 64, viewWidth-20, viewHeight - 108) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [super viewDidLoad];
    [self.tableView setShowsHorizontalScrollIndicator:NO];
    [self.tableView setShowsVerticalScrollIndicator:NO];
    
    cellTestList = [NSMutableArray arrayWithObjects:@"个人设置",@"去评分",@"帮助", nil];
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 140)];
//    headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIImageView *logoImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo"]];
//    logoImg.frame = CGRectMake(0, 0, 120, 110);
    logoImg.center = headerView.center;
    
    UILabel *headerLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, headerView.frame.size.height - 30, viewWidth, 30)];
    headerLbl.text = [NSString stringWithFormat:@"佛山随手拍"];
    headerLbl.textColor = [UIColor lightGrayColor];
    headerLbl.font = [UIFont systemFontOfSize:15 weight:bold];
    headerLbl.textAlignment = NSTextAlignmentCenter;
    
    [headerView addSubview:headerLbl];
    
    
    [headerView addSubview:logoImg];
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, viewWidth, self.tableView.frame.size.height - 140 - 40 * cellTestList.count - 44)];
//    footerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UILabel *footerLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, footerView.frame.size.height - 40, viewWidth, 30)];
    NSDictionary *appInfo = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [appInfo objectForKey:@"CFBundleVersion"];
    footerLbl.text = [NSString stringWithFormat:@"版本 %@",currentVersion];
    footerLbl.textColor = [UIColor grayColor];
    footerLbl.font = [UIFont systemFontOfSize:15 weight:bold];
    footerLbl.textAlignment = NSTextAlignmentCenter;
    [footerView addSubview:footerLbl];
    
    self.tableView.tableHeaderView = headerView;
    self.tableView.tableFooterView = footerView;
//    self.tableView.backgroundColor = [UIColor lightGrayColor];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return cellTestList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellName = @"cellName";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        cell.textLabel.text = cellTestList[indexPath.row];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
//    return cell.frame.size.height;
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSString  * nsStringToOpen = [NSString  stringWithFormat: @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8",@"919097638"  ];
    
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    NSString *name =cell.textLabel.text;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if([name isEqualToString:@"个人设置"])
    {
        RightViewController *view = [RightViewController new];
        view.title = @"个人设置";
        view.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:view animated:YES];
    }
    if([name isEqualToString:@"去评分"])
    {
        NSString *str = @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1031840589&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8";
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
    if([name isEqualToString:@"帮助"])
    {
        
        WebViewController *webView = [[WebViewController alloc]init];
        webView.title = name;
        NSString *url = @"/Pages/SSP/help.aspx";
        webView.url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"http://%@%@",[PublicHelper GetSettingValue:@"HttpIP"],url]];
        webView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webView animated:YES];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
