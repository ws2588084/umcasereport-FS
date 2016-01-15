//
//  PublicInfoViewController.m
//  umcasereport-FS
//
//  Created by WangShuai on 15/9/21.
//  Copyright © 2015年 Topevery. All rights reserved.
//

#import "PublicInfoViewController.h"

@interface PublicInfoViewController ()

@end

@implementation PublicInfoViewController

- (void)viewDidLoad {
    viewWidth = [[UIScreen mainScreen]bounds].size.width;
    viewHeight = [[UIScreen mainScreen]bounds].size.height;
    UIImageView *backImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    backImg.image = [UIImage imageNamed:@"背景2.jpg"];
    
    
    names = [[NSArray alloc]initWithObjects:@"机构简介",@"数字城管概述",@"信息公告",@"工作动态",@"曝光台", nil];
    imgs = [[NSArray alloc]initWithObjects:@"机构简介",@"数字城管概述",@"信息公告",@"工作动态",@"曝光台", nil];
    urls = [[NSArray alloc]initWithObjects:
            @"/Pages/SSP/Introduction.aspx",
            @"/Pages/SSP/SZCGDesc.aspx",
            @"/Pages/SSP/InformationButtetn.aspx",
            @"/Pages/NewIndex.aspx",
            @"/Pages/NewIndex.aspx?category_id=2",
            nil];
    dic = [[NSMutableDictionary alloc]initWithObjects:imgs forKeys:names];
    urlDic = [[NSMutableDictionary alloc]initWithObjects:urls forKeys:names];
    
    table = [[UITableView alloc]initWithFrame:CGRectMake(10, 64, viewWidth-20, viewHeight - 64) style:UITableViewStyleGrouped];
    table.backgroundColor = [UIColor clearColor];
    table.delegate = self;
    table.dataSource = self;
    
    [self.view addSubview:backImg];
    [self.view addSubview:table];
    
    [super viewDidLoad];
    
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
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return names.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellName = @"cellName";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellName"];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        cell.textLabel.text = names[indexPath.row];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.imageView.image = [UIImage imageNamed:[dic objectForKey:names[indexPath.row]]];
    }
    
    // Configure the cell...
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *name = [self tableView:tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    WebViewController *webView = [[WebViewController alloc]init];
    webView.title = name;
    NSString *url = [urlDic objectForKey:name];
    url = [NSString stringWithFormat:@"http://%@%@",[PublicHelper GetSettingValue:@"HttpIP"],url];
    webView.url = [[NSURL alloc]initWithString:url];
    
    webView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webView animated:YES];
    
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
