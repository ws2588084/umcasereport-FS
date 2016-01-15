//
//  CityManagemantViewController.m
//  umcasereport-FS
//
//  Created by WangShuai on 15/9/21.
//  Copyright © 2015年 Topevery. All rights reserved.
//

#import "CityManagemantViewController.h"

@interface CityManagemantViewController ()

@end

@implementation CityManagemantViewController

- (void)viewDidLoad {
//    NSLog(@"%@",self.view.backgroundColor);
    viewWidth = [[UIScreen mainScreen]bounds].size.width;
    viewHeight = [[UIScreen mainScreen]bounds].size.height;
    UIImageView *backImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    backImg.image = [UIImage imageNamed:@"背景2.jpg"];
    [self.view addSubview:backImg];
    
    NSArray *names = [[NSArray alloc]initWithObjects:@"问题投诉",@"电话投诉",@"微信投诉",@"投诉查询", nil];
    NSArray *imgs = [[NSArray alloc]initWithObjects:@"问题投诉",@"电话投诉",@"微信投诉",@"投诉查询", nil];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithObjects:imgs forKeys:names];
    
    CGFloat btnWidth = viewWidth/3;
    for (int i = 0;i < names.count;i++) {
        ButtonView *btn=[[ButtonView alloc]initWithFrame:CGRectMake(i%3 * btnWidth, 64 + i/3 * btnWidth, btnWidth, btnWidth)];
        [btn setTitle:names[i] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:[dic objectForKey:names[i]]] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        btn.imgHeight = btnWidth-60;
        [btn layoutSubviews];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)btnClick:(UIButton*)btn
{
    NSString *btnName = btn.titleLabel.text;
    if([btnName isEqualToString:@"电话投诉"])
    {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:12319"];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
        //        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://10086"]];
        
    }
    if([btnName isEqualToString:@"短信上报"])
    {
        //系统自带短信发送功能，简单，但不能主动返回到app
        //        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"sms://10000"]];
        //导入messageUI 实现app内发送短信
        if (![MFMessageComposeViewController canSendText]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"设备不支持发送短信" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles: nil];
            [alert show];
            return;
        }
        MFMessageComposeViewController *message = [[MFMessageComposeViewController alloc]init];
        message.messageComposeDelegate = self;
        message.body = @"上报";
        message.recipients = [NSArray arrayWithObject:@"12319"];
        [self performSelector:@selector(dontSeelp) onThread:[NSThread mainThread] withObject:nil waitUntilDone:NO];
        [self presentViewController:message animated:YES completion:nil];
        
        //        [self presentViewController:item animated:YES completion:nil];
    }
    if([btnName isEqualToString:@"投诉查询"])
    {
        //        ReprotRecordList *view = [[ReprotRecordList alloc]initWithStyle:UITableViewStylePlain];
        //案件列表信息
        EventListView *view = [[EventListView alloc]initWithStyle:UITableViewStylePlain];
        //带地图的案件列表
        //        EventListMapView *view =[[EventListMapView alloc]init];
        view.hidesBottomBarWhenPushed = YES;
        view.title = @"投诉查询";
        [self.navigationController pushViewController:view animated:YES];
    }
    if([btnName isEqual:@"问题投诉"])
    {
//        UIImagePickerController *picker=[[UIImagePickerController alloc]init];
//        
//        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
//        {
//            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"请选择" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"相机",@"手机相册", nil];
//            [alert show];
//        }
//        else
//        {
//            [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
//            [self presentViewController:picker animated:YES completion:nil];
//        }
//        [picker setDelegate:self];
        [self showReportView];
    }
    if([btnName isEqualToString:@"微信投诉"])
    {
        WeiXinViewController *weixin = [[WeiXinViewController alloc]init];
        weixin.title = btnName;
        weixin.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:weixin animated:YES];
    }
    if([btnName isEqualToString:@"系统公告"])
    {
        GGViewController *notic = [[GGViewController alloc]init];
        notic.title = btnName;
        [self.navigationController pushViewController:notic animated:YES];
    }
    WebViewController *webView = [[WebViewController alloc]init];
    webView.title = btnName;
    if([btnName isEqualToString:@"城管新闻"])
    {
        //        GGViewController *gg= [GGViewController new];
        //        gg.title = btnName;
        //        [self.navigationController pushViewController:gg animated:YES];
        
        webView.url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"http://%@/Pages/NewIndex.aspx",[PublicHelper GetSettingValue:@"HttpIP"]]];
        [self.navigationController pushViewController:webView animated:YES];
    }
    if([btnName isEqualToString:@"周边信息"])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"此功能正在开发" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles: nil];
        [alert show];
        //        webView.url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"http://%@/PublicServer/mobile/xcum/index.aspx",appDelegate.Http_IP]];
        //        [self.navigationController pushViewController:webView animated:YES];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    if(alertView.tag == 66)
//    {
//        if(buttonIndex == 1)
//        {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updUrl]];
//            //            [[PgyManager sharedPgyManager] updateLocalBuildNumber];
//        }
//    }
//    else
//    {
        UIImagePickerController *picker=[[UIImagePickerController alloc]init];
        [picker setDelegate:self];
        if(buttonIndex == 0)
        {
            if(alertView.tag == 88 || alertView.tag == 89)
            {
                [updAlertView dismissWithClickedButtonIndex:0 animated:YES];
            }
            [alertView dismissWithClickedButtonIndex:0 animated:NO];
        }
        else
        {
            if(alertView.tag == 88)
            {
                [updAlertView dismissWithClickedButtonIndex:0 animated:YES];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updUrl]];
            }
            if(buttonIndex == 1)
            {
                [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
            }
            if(buttonIndex == 2)
            {
                [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            }
            [self presentViewController:picker animated:YES completion:nil];
        }
//    }
}
-(void)didPresentAlertView:(UIAlertView *)alertView
{
    if(alertView.tag == 99)
        [self CheckUpdate];
}
#pragma mark - 案件上报相关内容
-(void)showReportView
{
//    ReprotTableViewController *rootView = [ReprotTableViewController new];
    
//    ReprotView *rootView = [[ReprotView alloc]init];
    ReprotEventController *rootView = [ReprotEventController new];
    
    UINavigationController *view=[[UINavigationController alloc]initWithRootViewController:rootView];
    view.title = @"问题投诉";
    rootView.title = @"问题投诉";
    rootView.ImageData = ImageData;
    [self presentViewController:view animated:YES completion:nil];
    /*
     present的时候会出现延迟，不会马上调用跳转的主线程
     这里使用perfromSelector主动激活 跳转主线程 解决延迟问题
     */
    [self performSelector:@selector(dontSeelp) onThread:[NSThread mainThread] withObject:nil waitUntilDone:NO];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if([mediaType isEqualToString:@"public.image"])
    {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        WSImage *img = [[WSImage alloc]init];
        //        image = [img scaleToSize:image size:CGSizeMake(320, 240)];
        image = [img imageCompressForWidth:image targetWidth:320];
        NSData *data= UIImageJPEGRepresentation(image,0.5);
        BOOL isJPG=YES;
        if(data==nil)
        {
            data = UIImagePNGRepresentation(image);
            isJPG = NO;
        }
        if(data)
        {
            ImageData = data;
        }
    }
    //    [self dismissViewControllerAnimated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:^{
        [self showReportView];
    }];
}

-(NSString*)pictureName:(BOOL)isJPG {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd_HHmmss"];
    NSString* tileName = [dateFormatter stringFromDate:[NSDate date]];
    
    if(isJPG == YES) {
        return [tileName stringByAppendingString:@".jpg"];
    }
    return [tileName stringByAppendingString:@".png"];
}
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result) {
        case MessageComposeResultCancelled:
            NSLog(@"取消");
            break;
        case MessageComposeResultFailed:
            NSLog(@"失败");
            break;
        case MessageComposeResultSent:
            NSLog(@"成功");
            break;
            
        default:
            break;
    }
    
    //关闭短信界面
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 设置ip相关
-(void)EditIP
{
    SettingOneView *view = [[SettingOneView alloc]init];
    view.SetName = @"设置";
    UINavigationController *item=[[UINavigationController alloc]initWithRootViewController:view];
    
    view.delegate = self;
    
    item.title = @"设置";
    
    self.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    [self presentViewController:item animated:YES completion:nil];
    //    [self.navigationController pushViewController:view animated:YES];
    
    /*
     present的时候会出现延迟，不会马上调用跳转的主线程
     这里使用perfromSelector主动激活 跳转主线程 解决延迟问题
     */
    [self performSelector:@selector(dontSeelp) onThread:[NSThread mainThread] withObject:nil waitUntilDone:NO];
    
}
-(void)showName:(NSString *)setName cellIndex:(NSIndexPath *)cellIndex
{}
-(IBAction)dontSeelp
{}
-(IBAction)showRightView:(id)sender
{
    [[SlideNavigationController sharedInstance] openMenu:MenuRight withCompletion:nil];
}

-(BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return NO;
}
-(BOOL)slideNavigationControllerShouldDisplayRightMenu
{
    return YES;
}
-(void)CheckUpdate
{
    updUrl = [PublicHelper checkUpdateWithAPPID];
    //    [alert dismissWithClickedButtonIndex:0 animated:YES];
    if(updUrl.length>0)
    {
        UIAlertView *udpMsg = [[UIAlertView alloc]initWithTitle:@"提示" message:@"有新版本，是否更新？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"更新", nil];
        udpMsg.tag = 88;
        [udpMsg show];
    }
    //    else
    //    {
    //        UIAlertView *udpMsg = [[UIAlertView alloc]initWithTitle:@"提示" message:@"没有发现新版本" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: nil];
    //        udpMsg.tag = 89;
    //        [udpMsg show];
    //    }
}

//蒲公英APP管理，更新回调函数
//-(void)updateMethod:(NSDictionary*)response
//{
//    if (response[@"downloadURL"]) {
//        updUrl = [response objectForKey:@"downloadURL"];
//        NSString *message = response[@"releaseNote"];
//        UIAlertView *udpMsg = [[UIAlertView alloc] initWithTitle:@"发现新版本"
//                                                         message:message
//                                                        delegate:self
//                                               cancelButtonTitle:@"关闭"
//                                               otherButtonTitles:@"更新",
//                               nil];
//        udpMsg.tag = 66;
//        [udpMsg show];
//    }
//    else
//    {
//        UIAlertView *udpMsg = [[UIAlertView alloc]initWithTitle:@"提示" message:@"没有发现新版本" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: nil];
//        udpMsg.tag = 66;
//        [udpMsg show];
//    }
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
