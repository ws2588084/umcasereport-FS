//
//  GGViewController.m
//  TopeveryEO
//
//  Created by WangShuai on 14/11/11.
//  Copyright (c) 2014年 Topevery. All rights reserved.
//

#import "GGViewController.h"

@interface GGViewController ()

@end

@implementation GGViewController

- (void)viewDidLoad {
    ary = [NSMutableArray arrayWithObjects:@"市城管局召开“三严三实”专题教育暨纪检工作会议",@"綦文生副局长率队参加民心桥节目",@"綦文生副局长主持召开坝光银叶树湿地园项目移交现场会",@"市城管局叶果副局长主持召开清水河环境园周边环境整治提升工作第三次协调会",@"梅林山公园安全生产大检查",@"宝安区三月份清扫保洁服务企业检查监督考评结果排名情况通报",@"松岗“一把手”进社区现场办公",@"推进公园建设 加强治安管理", nil];
    urlAry = [[NSMutableArray alloc]initWithObjects:@"http://www.szum.gov.cn/html/zwdt/201563/61201563194222834.htm",@"http://www.szum.gov.cn/html/zwdt/201562/69201562173926858.htm",@"http://www.szum.gov.cn/html/zwdt/2015529/612015529122716428.htm",@"http://www.szum.gov.cn/html/zwdt/2015528/612015528172620878.htm",@"http://www.szum.gov.cn/html/SZCG/201564/7020156411343531.htm",@"http://www.szum.gov.cn/html/SZCG/201564/69201564103630219.htm",@"http://www.szum.gov.cn/html/SZCG/201564/1257201564103313260.htm",@"http://www.szum.gov.cn/html/SZCG/201564/6820156410302125.htm", nil];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(EditClick:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ary.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellName = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
    }
    cell.textLabel.text = ary[indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    cell.detailTextLabel.text = @"2014-12-12";
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    cell.accessoryType = UITableViewCellAccessoryDetailButton;
//    [cell setEditingAccessoryType:UITableViewCellAccessoryDetailButton]; 
    
//    [tableView setEditing:YES animated:YES];
    
//    cell.backgroundColor = [UIColor redColor];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}
-(IBAction)EditClick:(id)sender
{
    UIBarButtonItem *item = (UIBarButtonItem*)sender;
    if([item.title isEqual: @"编辑"])
    {
        item.title = @"取消";
        [TableGG setEditing:YES animated:YES];
    }else
    {
        item.title = @"编辑";
        [TableGG setEditing:NO animated:YES];
    }
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle==UITableViewCellEditingStyleDelete)
    {
        [ary removeObjectAtIndex:indexPath.row];
        [TableGG deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WebViewController *webView = [WebViewController new];
//    view.view.backgroundColor = [UIColor whiteColor];
    webView.title = @"内容详情";
    webView.url = [[NSURL alloc]initWithString:urlAry[indexPath.row]];
    [self.navigationController pushViewController:webView animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
