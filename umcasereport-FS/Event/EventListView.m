//
//  EventListView.m
//  CSGL
//
//  Created by WangShuai on 15/1/22.
//  Copyright (c) 2015年 topevery. All rights reserved.
//

#import "EventListView.h"
//#import "EventMapView.h"
#import "MapItem.h"
//#import "EventListMapView.h"
#import "EventDetailedView.h"
#import "EventCell.h"
#import "EventEntity.h"
#import "EventSql.h"
#import "MJRefresh.h"

@interface EventListView ()

@end

@implementation EventListView
-(void)viewWillAppear:(BOOL)animated
{
    //        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请点击案件信息获取案件的最新状态" preferredStyle:UIAlertControllerStyleAlert];
    //        [self presentViewController:alert animated:YES completion:^{
    //            [NSThread sleepForTimeInterval:2];
    //            [self.presentedViewController dismissViewControllerAnimated:NO completion:nil];
    //        }];
//    [alert dismissWithClickedButtonIndex:0 animated:YES];
    
    [super viewWillAppear:animated];
}
-(void)ale
{
    [alertTopView dismissWithClickedButtonIndex:0 animated:YES];
}
- (void)viewDidLoad {
    viewWidth = [[UIScreen mainScreen] bounds].size.width;
    //    _flows = [[NSMutableArray alloc]init];
    //    _flows = [EventSql selectAllEvent];
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    pageIndex = 1;
    [super viewDidLoad];
    
    self.title = @"历史记录";
//    self.tableView.bounces = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView addHeaderWithTarget:self action:@selector(GetEventList)];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backItem;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"设置" style:UIBarButtonItemStyleDone target:self action:@selector(itemBtnClick:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    NullTableView = [[UIView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    UILabel *lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, viewWidth, NullTableView.frame.size.height - 64)];
    lblTitle.text = @"暂时没有历史纪录";
    lblTitle.font = [UIFont systemFontOfSize:17];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.textColor = [UIColor lightGrayColor];
    
    NullTableView.hidden = YES;
    [NullTableView addSubview:lblTitle];
    [self.view addSubview:NullTableView];
    if (_flows.count <= 0) {
        NullTableView.hidden = NO;
    }
    [self.tableView headerBeginRefreshing];
}
-(void)showMap
{
    //22.53996
    //113.980667
    //    EventListMapView *map = [[EventListMapView alloc]init];
    ////    EventMapView *map = [[EventMapView alloc]init];
    //    map.title = @"地图";
    //    map.Events = [[NSMutableArray alloc]init];
    //    for (int i =0; i<10; i++) {
    //        MapItem *item = [[MapItem alloc]initX:22.53996 Y:113.980667 + ((float)i/1000)];
    //        [map.Events addObject:item];
    //    }
    //    [self.navigationController pushViewController:map animated:YES];
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
    return _flows.count;
}

//-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return @"请点击案件信息获取案件的最新状态";
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellName = @"EventCell";
//    EventCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
//    if(cell == nil)
//    {
//        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellName owner:[EventCell class] options:nil];
//        cell = (EventCell *)[nib objectAtIndex:0];
//        ReportEvtInfo *evt = _flows[indexPath.row];
//        cell.contentView.backgroundColor = [UIColor clearColor];
//        cell.address = evt.EvtPos;
//        cell.index = indexPath.row;
//        cell.title = evt.EvtCode;
//        cell.content = evt.EvtDesc;
//        cell.todoName = evt.EvtResult;
////        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
////        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
////        NSString *strDate = [dateFormatter stringFromDate:evt.ReportDate];
////        NSLog(@"%@",evt.acceptTime);
//        cell.dateTime = evt.ReportDate;
////        cell.todoName = @"[处理中]";
//        [cell loadCell];
//    }
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
//    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.frame = CGRectMake(0, 0, viewWidth, 0);
    ReportEvtInfo *evt = _flows[indexPath.row];
    //受理号
    //    UILabel *lblCodeName = [self CreateLbl:@"受理好：" y:0];
    [self CreateLbl:@"受理号：" value:evt.EvtCode y:0 cell:cell];
    //地址
    [self CreateLbl:@"地址：" value:evt.EvtPos y:cell.frame.size.height cell:cell];
    //问题
    [self CreateLbl:@"问题：" value:evt.EvtDesc y:cell.frame.size.height cell:cell];
    //案件状态
    [self CreateLbl:@"案件状态：" value:evt.EvtResult y:cell.frame.size.height cell:cell];
    //案件号
    [self CreateLbl:@"案件号：" value:evt.Summary y:cell.frame.size.height cell:cell];
    //上报时间
    [self CreateLbl:@"上报时间：" value:evt.ReportDate y:cell.frame.size.height cell:cell];
    //编号
    UILabel *lblIndex = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 25, cell.frame.size.height)];
    
    //0.355469 0.692694 0.944596 1
    //0.407996 0.810045 1 1
    if(indexPath.row % 2 == 0)
    {
        lblIndex.backgroundColor = [UIColor colorWithRed:0.355469 green:0.692694 blue:0.944596 alpha:1];//[UIColor lightGrayColor];
        cell.backgroundColor = [UIColor colorWithRed:0.355469 green:0.692694 blue:0.944596 alpha:0.3];
        //0.334448 0.965216 1 1 浅蓝
        //0.927065 0.924662 0.966632 1 蓝灰
    }
    else
    {
        lblIndex.backgroundColor = [UIColor colorWithRed:0.407996 green:0.810045 blue:1 alpha:1];
        cell.backgroundColor = [UIColor colorWithRed:0.74902 green:0.94902 blue:1 alpha:1];//0.74902 0.94902 1 1
    }
    lblIndex.font = [UIFont systemFontOfSize:14 weight:bold];
    lblIndex.textAlignment = NSTextAlignmentCenter;
    lblIndex.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
    lblIndex.layer.masksToBounds = YES;
    lblIndex.textColor = [UIColor whiteColor];
//    [lblIndex.layer setCornerRadius:CGRectGetHeight([lblIndex bounds]) / 2];
    lblIndex.layer.borderWidth = 1;
    lblIndex.layer.borderColor = [UIColor clearColor].CGColor;
    [cell addSubview:lblIndex];
    return cell;
}
-(void)CreateLbl:(NSString*)title value:(NSString*)value y:(CGFloat)y cell:(UITableViewCell*)cell
{
    UIFont *nameFont = [UIFont systemFontOfSize:14];
    UILabel *lblName = [[UILabel alloc]initWithFrame:CGRectMake(30, y, 70, 25)];
    lblName.text = title;
    lblName.font = nameFont;
    lblName.textColor = [UIColor blackColor];
    lblName.textAlignment = NSTextAlignmentLeft;
    
    
    UILabel *lblValue = [[UILabel alloc]initWithFrame:CGRectMake(100, y, viewWidth - 108, 25)];
    
    lblValue.numberOfLines = 0;
    lblValue.textColor = [UIColor darkGrayColor];
    lblValue.font =nameFont;//[UIFont systemFontOfSize:13];
    lblValue.text = value;
    lblValue.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size = [lblValue sizeThatFits:CGSizeMake(lblValue.frame.size.width, MAXFLOAT)];
    if(size.height<25)
        size.height = 25;
    else
        size.height += 5;
    lblValue.frame = CGRectMake(100, y, lblValue.frame.size.width, size.height);
    
    [cell addSubview: lblName];
    [cell addSubview: lblValue];
    cell.frame = CGRectMake(0, 0, viewWidth, lblValue.frame.origin.y + lblValue.frame.size.height);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    ReportEvtInfo *evt = _flows[indexPath.row];
    NSLog(@"%li",(long)indexPath.row);
    if(evt.EvtCode.length < 1)
    evt.EvtCode = @"0";
    [EventOperate GetSSPEvtDetail:evt successBlock:^(EvtRes *evtRes) {
//        NSString *msg = @"";
//        if([evtRes.IsSuccess boolValue])
//        {
//            msg = evtRes.EvtPara.EvtResult;
//        }
//        else
//        {
//            msg = evtRes.ErrorMessage;
//        }
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"关闭" otherButtonTitles: nil];
//        alert.tag = 11;
//        [alert show];
        evt.Summary = evtRes.EvtPara.Summary;
        evt.EvtResult = evtRes.EvtPara.EvtResult;
        [self.tableView reloadData];
    } failedBlock:^(NSString *errMsg) {
        
    }];
    //    EventDetailedView *map = [[EventDetailedView alloc]init];
//    map.Events = [[NSMutableArray alloc]init];
//    EventEntity *evt = _flows[indexPath.row];
//    if(evt.AbsX<=0&&evt.AbsY<=0)
//    {
//        evt.AbsX = 22.53996;
//        evt.AbsX = 113.980667;
//    }
//    map.evt = evt;
////    MapItem *item = [[MapItem alloc]initX:22.53996 Y:113.980667 + (float)indexPath.row/1000];
////    [map.Events addObject:item];
//    [self.navigationController pushViewController:map animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)itemBtnClick:(UIBarButtonItem*)item
{
    
    NSString *UserPhone = [PublicHelper GetSettingValue:@"UserPhone"];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入默认举报电话，根据默认举报电话会获取到相关的举报信息！" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"确定", nil];
    alert.tag = 1;
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert textFieldAtIndex:0].text = UserPhone;
    [alert textFieldAtIndex:0].keyboardType = UIKeyboardTypePhonePad;
    [alert show];
}

-(void)GetEventList
{
    NSString *UserPhone = [PublicHelper GetSettingValue:@"UserPhone"];
    if(UserPhone.length>0)
    {
//    UserPhone = @"22222";
    if(UserPhone.length > 0)
    {
        pageIndex = 1;
        ReportEvtInfo *evt = [ReportEvtInfo new];
        evt.LinkPhone = UserPhone;
        evt.PageIndex = [NSNumber numberWithInteger:pageIndex];
        
        [EventOperate GetReportHistry:evt successBlock:^(NSMutableArray *entitys) {
            [self.tableView headerEndRefreshing];
            alertTopView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"已获取所有案件的最新案件状态，请查看" delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
            [alertTopView show];
            
            //    [NSThread sleepForTimeInterval:2];
            [self performSelector:@selector(ale) withObject:self afterDelay:2];
            _flows = entitys;
            [self.tableView reloadData];
            if(_flows.count>0)
                NullTableView.hidden = YES;
            if(entitys.count == 5)
            {
                [self.tableView addFooterWithTarget:self action:@selector(NextPageEvemtList)];
            }
        } failedBlock:^(NSString *errMsg) {
            [self.tableView headerEndRefreshing];
        }];
    }
    }
    else
    {
        [self.tableView headerEndRefreshing];
        [self searchMessage];
    }
}
-(void)NextPageEvemtList
{
    NSString *UserPhone = [PublicHelper GetSettingValue:@"UserPhone"];
    if(UserPhone.length>0)
    {
        //    UserPhone = @"22222";
        if(UserPhone.length > 0)
        {
            pageIndex ++;
            ReportEvtInfo *evt = [ReportEvtInfo new];
            evt.LinkPhone = UserPhone;
            evt.PageIndex = [NSNumber numberWithInteger:pageIndex];
            
            [EventOperate GetReportHistry:evt successBlock:^(NSMutableArray *entitys) {
                [self.tableView footerEndRefreshing];
                _flows = entitys;
                [self.tableView reloadData];
                if(_flows.count>0)
                    NullTableView.hidden = YES;
                if(entitys.count < 5)
                {
                    [self.tableView removeFooter];
                }
            } failedBlock:^(NSString *errMsg) {
                [self.tableView footerEndRefreshing];
            }];
        }
    }
    else
    {
        [self searchMessage];
    }
}
-(void)searchMessage
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入默认举报电话，以便查询相关举报信息！" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"确定", nil];
    alert.tag = 1;
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert textFieldAtIndex:0].text = @"";
    [alert textFieldAtIndex:0].keyboardType = UIKeyboardTypePhonePad;
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    UITextField *txt = [alertView textFieldAtIndex:0];
    
    if(alertView.tag == 1&& buttonIndex == 1)
    {
        if(txt.text.length > 0)
        {
            [PublicHelper UpdateSettingValue:@"UserPhone" value:txt.text];
            //            [self GetEventList];
            [self.tableView headerBeginRefreshing];
        }
    }
    
}
-(BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    if(alertView.tag == 1)
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
