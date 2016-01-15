//
//  ReprotTableViewController.m
//  umcasereport-FS
//
//  Created by WangShuai on 15/9/25.
//  Copyright © 2015年 Topevery. All rights reserved.
//

#import "ReprotTableViewController.h"

@interface ReprotTableViewController ()

@end

@implementation ReprotTableViewController

- (void)viewDidLoad {
    viewWidth = [[UIScreen mainScreen]bounds].size.width;
    viewHeight = [[UIScreen mainScreen]bounds].size.height;
    titles= [NSMutableArray arrayWithObjects:@"事发区域",@"事发镇(街)",@"问题描述",@"详细地址",@"相关图片",@"备注",@"是否回复",@"姓名",@"联系电话",@"受理主体", nil];
    values = [NSMutableArray arrayWithObjects:@"请选择",@"请选择",@"",@"",@"",@"",@"",@"",@"",@"属地受理属地受理属地受理属地受理属地受理属地受理属地受理属地受理属地受理属地受理属地受理属地受理", nil];
    
    UIImageView *backImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    backImg.image = [UIImage imageNamed:@"背景2.jpg"];
    [self.view addSubview:backImg];
    
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, viewWidth, viewHeight-64) style:UITableViewStylePlain];
    table.backgroundColor = [UIColor clearColor];
    table.delegate = self;
    table.dataSource = self;
    table.tableFooterView = [UIView new];
    
    [self.view addSubview:table];
    
    [self addNavigatItems];
    [super viewDidLoad];
}

#pragma - mark - 添加默认加载内容
-(void)addNavigatItems
{
    //    UIBarButtonItem *itemLeft=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"xj"] style:UIBarButtonItemStyleDone target:self action:@selector(pickBtn:)];
//    UIBarButtonItem *itemLeft = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(backBtn:)];
//    
//    UIBarButtonItem *itemRight = [[UIBarButtonItem alloc]initWithTitle:@"上报" style:UIBarButtonItemStyleDone target:self action:@selector(reportBtn:)];
//    
//    [self.navigationItem setLeftBarButtonItem:itemLeft];
//    [self.navigationItem setRightBarButtonItem:itemRight];
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
    
    return titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellName = @"cellName";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    UILabel *txtTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 40)];
    txtTitle.font = [UIFont systemFontOfSize:15];
    txtTitle.textColor = [UIColor grayColor];
    
    txtTitle.text = titles[indexPath.row];
    txtTitle.textAlignment = NSTextAlignmentLeft;
    
    //内容
    NSString *s = values[indexPath.row];
    
    UILabel *txtValue = [[UILabel alloc]initWithFrame:CGRectMake(90, 0, viewWidth - 100, 40)];
    txtValue.textColor = [UIColor lightGrayColor];
    
    UIFont *font = [UIFont fontWithName:@"Arial" size:14];
    txtValue.text = values[indexPath.row];
    txtValue.font = font;
    
    //设置自动行数与字符换行
    [txtValue setNumberOfLines:0];
    txtValue.lineBreakMode = 0;
    txtValue.textAlignment = NSTextAlignmentRight;
    //设置一个行高上限
    CGSize size = CGSizeMake(txtValue.frame.size.width,CGFLOAT_MAX);
    CGRect rect = [s boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] context:nil];
    
//    CGRect txtRect = txtTitle.frame;
//    txtRect.size.height = rect.size.height;
    //计算实际frame大小，并将label的frame变成实际大小
    if(rect.size.height > 40)
    {
        rect.origin = txtValue.frame.origin;
        [txtValue setFrame: rect];
        txtValue.textAlignment = NSTextAlignmentLeft;
    }
    
    if(txtValue.frame.size.height>40)
        cell.frame = CGRectMake(0, 0, viewWidth, txtValue.frame.size.height+10);
    [cell.contentView addSubview:txtTitle];
    [cell.contentView addSubview:txtValue];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self tableView:tableView cellForRowAtIndexPath:indexPath].frame.size.height;
}


#pragma -mark - 自定义事件
-(void)pickBtn:(id)sender
{}
-(void)reportBtn:(id)sender
{}
-(void)selectGps:(CLLocationCoordinate2D)coordinate address:(BMKAddressComponent *)address pose:(NSString *)pose
{}

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
