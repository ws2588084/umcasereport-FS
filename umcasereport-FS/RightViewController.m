//
//  RightViewController.m
//  umcasereport-FS
//
//  Created by WangShuai on 15/7/4.
//  Copyright (c) 2015年 Topevery. All rights reserved.
//

#import "RightViewController.h"

@interface RightViewController ()

@end

@implementation RightViewController

- (void)viewDidLoad {
    
    viewSize = [[UIScreen mainScreen]bounds].size;
    
//    aryOne = [NSArray arrayWithObjects:@"默认服务地址",@"默认举报人",@"默认举报电话", nil];
    aryOne = [NSArray arrayWithObjects:@"默认举报人",@"默认举报手机号码", nil];
    
    
//    NSLog(@"%f",viewSize.width / 7.0f);
//    CGFloat y = viewSize.width / 7.0f;
    
    CGFloat y = 0;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(y,0,viewSize.width - y,viewSize.height) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setScrollEnabled:NO];
    
    [self.view addSubview:_tableView];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView相关内容
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return aryOne.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellName = @"cellName";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellName];
    }
    
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.textLabel.frame = CGRectMake(0, 0, viewSize.width, 30);
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont systemFontOfSize:15
                                            weight:bold];
    cell.textLabel.text = aryOne[indexPath.row];
    NSString *key = @"";
    if([aryOne[indexPath.row] isEqualToString:@"默认服务地址"])
        key = @"HttpIP";
    if([aryOne[indexPath.row] isEqualToString:@"默认举报人"])
        key = @"UserName";
    if([aryOne[indexPath.row] isEqualToString:@"默认举报手机号码"])
        key = @"UserPhone";
    cell.detailTextLabel.text = [PublicHelper GetSettingValue:key];
    return cell;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
        return @"常用设置";
    if(section == 1)
        return @"操作";
    return @"";
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, viewSize.width, 80)];
    if(section == 0)
    {
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(8, 0, viewSize.width-16, 80)];
        lbl.text = @"为了便于必要时与您核实、补充情况，以及反馈处理情况，请填写本人的联系手机，我中心会保护个人隐私，防止资料外泄。如提供的手机号码不是投诉人本人的，为保护机主权益，我们将不予受理。";
        lbl.font = [UIFont systemFontOfSize:13];
        lbl.textColor = [UIColor redColor];
        lbl.numberOfLines = 0;
        [view addSubview:lbl];
    }
    
    
    
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self szClick:indexPath];
}

#pragma mark - 设置服务接口地址
- (void)szClick:(NSIndexPath*)indexPath {
    NSInteger tag = 0;
    NSString *msg = [NSString stringWithFormat:@"请设置%@",aryOne[indexPath.row]];
    NSString *key = @"";
    NSString *lblText = @"";
    if([aryOne[indexPath.row] isEqualToString:@"默认服务地址"])
    {
        tag = 1;
        key = @"HttpIP";
    }
    if([aryOne[indexPath.row] isEqualToString:@"默认举报人"])
    {
        tag = 2;
        key = @"UserName";
    }
    if([aryOne[indexPath.row] isEqualToString:@"默认举报手机号码"])
    {
        tag = 3;
        key = @"UserPhone";
        msg = @"请出入正确的手机号码";
    }
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"确定", nil];
    
    lblText = [PublicHelper GetSettingValue:key];
    
    alert.tag = tag;
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert textFieldAtIndex:0].text = lblText;
    if(tag == 3)
    [alert textFieldAtIndex:0].keyboardType = UIKeyboardTypePhonePad;
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    UITextField *txt = [alertView textFieldAtIndex:0];
//    NSString *path = [[NSBundle mainBundle]pathForResource:@"Setting" ofType:@"plist"];
//    NSMutableDictionary *data = [[NSMutableDictionary alloc]initWithContentsOfFile:path];
    if(buttonIndex !=0 )
    {
        NSString *key = @"";
        if(alertView.tag == 1)
        {
            key = @"HttpIP";
        }
        else if(alertView.tag == 2)
        {
            key = @"UserName";
        }
        else if(alertView.tag == 3)
        {
            key = @"UserPhone";
        }
        
        if(txt.text.length > 0)
        {
            [PublicHelper UpdateSettingValue:key value:txt.text];
            //        [data setValue:txt.text forKey:key];
            //        [data writeToFile:path atomically:YES];
        }
        [self.tableView reloadData];
    }
}
-(BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    if(alertView.tag == 3)
    {
        UITextField *txt = [alertView textFieldAtIndex:0];
        if(txt.text.length == 11)
        {
            if([[txt.text substringToIndex:1] isEqualToString:@"1"])
                return true;
        }
    }
    return false;
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
