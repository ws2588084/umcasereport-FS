//
//  ReprotViewController.m
//  umcasereport-FS
//
//  Created by WangShuai on 15/9/26.
//  Copyright © 2015年 Topevery. All rights reserved.
//

#import "ReprotEventController.h"
#import "CLLocation+YCLocation.h"
#import "EventOperate.h"
#import "EventEntity.h"
#import "EntityHelper.h"
#import "LocationBaiDuMapView.h"
#import "HttpFileUpload.h"
#import "WSImage.h"
#import "EventSql.h"
#import "WebServiveInteraction.h"
#import "AppDelegate.h"

@interface ReprotEventController ()

@end

@implementation ReprotEventController

-(void)viewWillAppear:(BOOL)animated
{
    [self addNavigatItems];
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    self.automaticallyAdjustsScrollViewInsets = NO;
    #endif
    self.title = @"案件上报";
    viewWidth = [[UIScreen mainScreen]bounds].size.width;
    viewHeight = [[UIScreen mainScreen]bounds].size.height;
    images = [[NSMutableArray alloc]init];
    MapGps = CLLocationCoordinate2DMake(0, 0);
    keyboardHeight = 0;
    
//    FileDetail* fileDetail =[[FileDetail alloc]init];
//    fileDetail.data = _ImageData;
//    fileDetail.name = [self pictureName:YES];
//    [images addObject:fileDetail];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(oneFingerTwoTaps)];
    [self.view addGestureRecognizer:tap];
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [self defaultView];
    [self defaultPicker];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)defaultView
{
    CGFloat width = viewWidth - 16;
    myScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, viewWidth, viewHeight - 64)];
    myScroll.backgroundColor = [UIColor groupTableViewBackgroundColor];
    myScroll.showsHorizontalScrollIndicator = NO;
    myScroll.showsVerticalScrollIndicator = NO;
    //联系人姓名
    txtReportName = [[UITextField alloc]initWithFrame:CGRectMake(8, 8, width, 40)];
    txtReportName.placeholder = @"请输入联系人";
    txtReportName.borderStyle = UITextBorderStyleRoundedRect;
    txtReportName.font = [UIFont systemFontOfSize:14];
    txtReportName.returnKeyType = UIReturnKeyNext;
    txtReportName.delegate = self;
    //联系人电话
    txtPhone = [[UITextField alloc]initWithFrame:CGRectMake(8, txtReportName.frame.size.height + txtReportName.frame.origin.y + 8, width, 40)];
    txtPhone.placeholder = @"请输入联系手机（必填）";
    txtPhone.borderStyle = UITextBorderStyleRoundedRect;
    txtPhone.font = [UIFont systemFontOfSize:14];
    txtPhone.keyboardType = UIKeyboardTypePhonePad;
    txtPhone.returnKeyType = UIReturnKeyNext;
    txtPhone.delegate = self;
    //联系人电话注释
    UILabel *lblPhone = [[UILabel alloc]initWithFrame:CGRectMake(8, txtPhone.frame.size.height + txtPhone.frame.origin.y + 8, width, 70)];
    lblPhone.textColor = [UIColor redColor];
    lblPhone.font = [UIFont systemFontOfSize:13];
    lblPhone.text = @"为了便于必要时与您核实、补充情况，以及反馈处理情况，请填写本人的联系手机，我中心会保护个人隐私，防止资料外泄。如提供的手机号码不是投诉人本人的，为保护机主权益，我们将不予受理";
    lblPhone.numberOfLines = 0;
    //是否回复
    UIView *SwitchBackView = [[UIView alloc]initWithFrame:CGRectMake(8, lblPhone.frame.size.height + lblPhone.frame.origin.y + 8, width, 40)];
    UILabel *lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(8, 0, 200, 40)];
    lblTitle.text = @"案件处理结果是否需要回复";
    lblTitle.font = [UIFont systemFontOfSize:14];
    lblTitle.textColor = [UIColor lightGrayColor];
    MySwitch = [[UISwitch alloc]initWithFrame:CGRectMake(width - 60, 5, 51, 31)];
    SwitchBackView.backgroundColor = [UIColor whiteColor];
    //switch所在的母体边框样式
    SwitchBackView.layer.borderColor =  [[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.3] CGColor];
    SwitchBackView.layer.borderWidth = 1;
    SwitchBackView.layer.cornerRadius = 5;
    [SwitchBackView addSubview:lblTitle];
    [SwitchBackView addSubview:MySwitch];
    
    //事发位置
    txtAddress = [[UITextField alloc]initWithFrame:CGRectMake(8,SwitchBackView.frame.size.height + SwitchBackView.frame.origin.y + 8, width, 40)];
    txtAddress.placeholder = @"请输入事发位置（必填）";
    txtAddress.borderStyle = UITextBorderStyleRoundedRect;
    txtAddress.font = [UIFont systemFontOfSize:14];
    
    UIButton *btnDW = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, txtAddress.frame.size.height)];
    [btnDW addTarget:self action:@selector(DwBtn:) forControlEvents:UIControlEventTouchUpInside];
    [btnDW setTitle:@"定位" forState:UIControlStateNormal];
    [btnDW setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btnDW.titleLabel.font = [UIFont systemFontOfSize:14];
    //UITextField 右侧添加一个ui
    txtAddress.rightView=btnDW;
    txtAddress.rightViewMode = UITextFieldViewModeAlways;
    txtAddress.returnKeyType = UIReturnKeyNext;
    txtAddress.delegate = self;
    
    //所在区域
    btnRegion = [[UIButton alloc]initWithFrame:CGRectMake(8, txtAddress.frame.size.height + txtAddress.frame.origin.y + 8, width, 40)];
    [btnRegion setTitle:@"请选择事发区域（必选）" forState:UIControlStateNormal];
    [btnRegion setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    btnRegion.titleLabel.font = [UIFont systemFontOfSize:14];
    btnRegion.layer.borderColor =  [[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.3] CGColor];
    btnRegion.layer.borderWidth = 1;
    btnRegion.layer.cornerRadius = 5;
    btnRegion.backgroundColor = [UIColor whiteColor];
    btnRegion.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btnRegion.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
    [btnRegion addTarget:self action:@selector(pickerVIewShowOrHide) forControlEvents:UIControlEventTouchUpInside];
    
    //详细描述
    txtDescription = [[UITextView alloc]initWithFrame:CGRectMake(8, btnRegion.frame.size.height + btnRegion.frame.origin.y + 8, width, 80)];
    //文本编辑框中添加提示信息
    textViewPlaceholder= [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 320, 30)];
    textViewPlaceholder.text = @"请输入问题描述（必填）";
    textViewPlaceholder.textColor = [UIColor lightGrayColor];
    textViewPlaceholder.font = [UIFont systemFontOfSize:14];
    [txtDescription addSubview:textViewPlaceholder];
    //文本编辑框添加边框
    txtDescription.layer.borderColor =  [[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.3] CGColor];
    txtDescription.layer.borderWidth = 1;
    txtDescription.layer.cornerRadius = 5;
    txtDescription.delegate = self;
    txtDescription.font = [UIFont systemFontOfSize:14];
    //详细描述注释
    UILabel *lblDescription = [[UILabel alloc]initWithFrame:CGRectMake(8, txtDescription.frame.size.height + txtDescription.frame.origin.y + 8, width, 40)];
    lblDescription.textColor = [UIColor redColor];
    lblDescription.font = [UIFont systemFontOfSize:13];
    lblDescription.text = @"请详细填写您要投诉的问题及事发位置，为了能更好受理您的问题，必要时要们将致电与您进行核实";
    lblDescription.numberOfLines = 0;
    
    //附件
    _imagesScroll = [[ImagesFroScroll alloc]initWithFrame:CGRectMake(8, lblDescription.frame.size.height + lblDescription.frame.origin.y + 8, width, 70)];
    _imagesScroll.imageWidth = 70;
    _imagesScroll.v = self;
    _imagesScroll.column = 3;
    _imagesScroll.imgMaxNum = 3;
    _imagesScroll.EditImageDelegate = self;
    _imagesScroll.isAdd = YES;
    _imagesScroll.isDel = YES;
//    NSMutableArray* list = (NSMutableArray*)_imagesScroll.arr;
//    [list addObject:_ImageData];
    [_imagesScroll LoadScrollView];
    
    //附件注释
    UILabel *lblImage = [[UILabel alloc]initWithFrame:CGRectMake(8, _imagesScroll.frame.size.height + _imagesScroll.frame.origin.y + 8, width, 40)];
    lblImage.textColor = [UIColor redColor];
    lblImage.font = [UIFont systemFontOfSize:13];
    lblImage.text = @"图片内容须清晰不模糊，且远、近景相结合。近景突出问题主体、远景突出事发位置。建议2张图片为宜。";
    lblImage.numberOfLines = 0;
    //备注
    txtBZ = [[UITextField alloc]initWithFrame:CGRectMake(8, lblImage.frame.size.height + lblImage.frame.origin.y + 8, width, 40)];
    txtBZ.placeholder = @"备注";
    txtBZ.borderStyle = UITextBorderStyleRoundedRect;
    txtBZ.font = [UIFont systemFontOfSize:14];
    txtBZ.returnKeyType = UIReturnKeyNext;
    txtBZ.delegate = self;
    //受理主体
    btnRecive = [[UIButton alloc]initWithFrame:CGRectMake(8, txtBZ.frame.size.height + txtBZ.frame.origin.y + 8, width, 40)];
    [btnRecive setTitle:@"受理主体：属地受理" forState:UIControlStateNormal];
    [btnRecive setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    btnRecive.titleLabel.font = [UIFont systemFontOfSize:14];
    btnRecive.layer.borderColor =  [[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.3] CGColor];
    btnRecive.layer.borderWidth = 1;
    btnRecive.layer.cornerRadius = 5;
    btnRecive.backgroundColor = [UIColor whiteColor];
    btnRecive.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btnRecive.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
    [btnRecive addTarget:self action:@selector(reciveClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:myScroll];
    [myScroll addSubview:txtAddress];
    [myScroll addSubview:btnRegion];
    [myScroll addSubview:txtDescription];
    [myScroll addSubview:lblDescription];
    [myScroll addSubview:_imagesScroll];
    [myScroll addSubview:lblImage];
    [myScroll addSubview:txtBZ];
    [myScroll addSubview:SwitchBackView];
    [myScroll addSubview:txtReportName];
    [myScroll addSubview:txtPhone];
    [myScroll addSubview:lblPhone];
    [myScroll addSubview:btnRecive];
    myScroll.contentSize = CGSizeMake(viewWidth, btnRecive.frame.size.height + btnRecive.frame.origin.y + 8);
    
    NSString *phone = [PublicHelper GetSettingValue:@"UserPhone"];
    txtPhone.text = phone;
    NSString *name = [PublicHelper GetSettingValue:@"UserName"];
    txtReportName.text = name;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//消息方法oneFingerTwoTaps
- (void)oneFingerTwoTaps
{
    NSLog(@"Action: One finger, two taps");
    [txtPhone resignFirstResponder];
    [txtDescription resignFirstResponder];
    [txtAddress resignFirstResponder];
    [txtBZ resignFirstResponder];
    [txtReportName resignFirstResponder];
    indexTextField = nil;
    //    [self.textView resignFirstResponder];
}
#pragma - mark - 键盘监控事件
//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    keyboardHeight = keyboardRect.size.height;
    if(indexTextField!=nil)
    {
        CGRect frame = indexTextField.frame;
        NSLog(@"%f",frame.origin.y);
        int offset = frame.origin.y + frame.size.height - (myScroll.frame.size.height - keyboardHeight);//216键盘高度
        NSTimeInterval animationduration = 0.30f;
        [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
        [UIView setAnimationDuration:animationduration];
        
        if(offset > 0)
        {
//            self.view.frame = CGRectMake(0, -offset, self.view.frame.size.width, self.view.frame.size.height);
            [myScroll setContentOffset:CGPointMake(0, offset)];
        }
        [UIView commitAnimations];
    }
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [myScroll setContentOffset:CGPointMake(0, 0)];
    //    NSTimeInterval animationduration = 0.30f;
    //    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    //    [UIView setAnimationDuration:animationduration];
    //
    //        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    //
    //    [UIView commitAnimations];
}

#pragma - mark - 添加默认加载内容
-(void)addNavigatItems
{
    //    UIBarButtonItem *itemLeft=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"xj"] style:UIBarButtonItemStyleDone target:self action:@selector(pickBtn:)];
    UIBarButtonItem *itemLeft = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(backBtn:)];
    
    UIBarButtonItem *itemRight = [[UIBarButtonItem alloc]initWithTitle:@"上报" style:UIBarButtonItemStyleDone target:self action:@selector(reportBtn:)];
    
    [self.navigationItem setLeftBarButtonItem:itemLeft];
    [self.navigationItem setRightBarButtonItem:itemRight];
}
-(void)addTitleImg
{
    CGSize ScreenSize = [[UIScreen mainScreen] bounds].size;
    if(FrontView==nil)
    {
        FrontView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenSize.width, ScreenSize.height)];
        
        UIImageView *backImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg"]];
        backImage.frame = FrontView.frame;
        
        //        backImage.layer.cornerRadius = 50;
        
        CGFloat btnWidth = FrontView.frame.size.width/2;
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(btnWidth/2, FrontView.frame.size.height/4, btnWidth, btnWidth)];
        
        UIImageView *titleImg= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"biaoti.png"]];
        CGFloat titleImgHeight = ScreenSize.width / titleImg.frame.size.width*titleImg.frame.size.height;
        titleImg.frame = CGRectMake(0, btn.frame.origin.y - titleImgHeight, ScreenSize.width, titleImgHeight);
        
        [btn setImage:[UIImage imageNamed:@"anniu-down"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(pickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [FrontView addSubview:backImage];
        [FrontView addSubview:btn];
        [FrontView addSubview:titleImg];
        [self.navigationController.view addSubview:FrontView];
    }
    else
    {
        FrontView.hidden = NO;
    }
}

#pragma -mark - 案件相关事件
-(IBAction)backBtn:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"退出此次上报" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"退出", nil];
    alert.tag = 11;
    [alert show];
}
- (IBAction)pickBtn:(id)sender {
    UIImagePickerController *picker=[[UIImagePickerController alloc]init];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"请选择" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"相机",@"手机相册", nil];
        [alert show];
    }
    else
    {
        [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self presentViewController:picker animated:YES completion:nil];
    }
    [picker setDelegate:self];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==1 || alertView.tag==2 || alertView.tag==3)
    {
        [self oneFingerTwoTaps];
        reportAlert.hidden = YES;
        [reportAlert addButtonWithTitle:@"确定"];
        [reportAlert dismissWithClickedButtonIndex:0 animated:NO];
        if(alertView.tag == 2)
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    if(alertView.tag == 11)
    {
        if(buttonIndex == 1)
            [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        UIImagePickerController *picker=[[UIImagePickerController alloc]init];
        [picker setDelegate:self];
        if(buttonIndex == 0)
        {
            [alertView dismissWithClickedButtonIndex:0 animated:NO];
        }
        else
        {
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
    }
}

- (IBAction)reportBtn:(id)sender {
    NSString *errMsg = @"";
    if(txtPhone.text.length !=11||![[txtPhone.text substringToIndex:1] isEqualToString:@"1"])
        errMsg = @"请输入正确的手机号，例如139xxxxxxxx";
    else if(!txtAddress.text.length >0)
        errMsg = @"请输入事发位置，以方便更快的定位事发位置，进行处理！";
    else if(!districtId.length >0)
        errMsg = @"请选择事发区域";
    else if(!streetId.length >0)
        errMsg = @"请选择事发区域";
    else if(!txtDescription.text.length >0)
    {
        errMsg = @"请输入详细描述，为了能更好受理您的问题，必要时要们将致电与您进行核实";
//        [txtDescription becomeFirstResponder];
    }
    else{
        reportAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"正在上报，请稍等片刻…" delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
        reportAlert.tag = 99;
        [reportAlert show];
    }
    if(errMsg.length > 0)
    {
        UIAlertView *errAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:errMsg delegate:self cancelButtonTitle:@"关闭" otherButtonTitles: nil];
        [errAlert show];
    }
}
-(void)didPresentAlertView:(UIAlertView *)alertView
{
    if(alertView.tag == 99)
    {
        ReportEvtInfo *entity = [ReportEvtInfo new];
        entity.Linkman = txtReportName.text;
        entity.LinkPhone = txtPhone.text;
        entity.EvtPos = txtAddress.text;
        entity.EvtDesc = txtDescription.text;
        entity.GeoX = [[NSNumber alloc]initWithDouble:MapGps.longitude];
        entity.GeoY = [[NSNumber alloc]initWithDouble:MapGps.latitude];
        entity.AbsX = [[NSNumber alloc]initWithDouble:MapGps.longitude];
        entity.AbsY = [[NSNumber alloc]initWithDouble:MapGps.latitude];
        entity.HandleType = 0;
        entity.Summary = txtBZ.text;
        entity.IsReceipt = [NSNumber numberWithBool:MySwitch.on];
        entity.DistrictID = districtId;
        entity.StreetID = streetId;
        entity.ReciveType = ReciveType;
        
        NSString *errMsg = nil;
        NSArray *attchInfos = [self Upload:&errMsg];
        
        if(errMsg != nil) {
            //            [reportAlert addButtonWithTitle:@"确定"];
            //            [reportAlert dismissWithClickedButtonIndex:0 animated:NO];
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"错误" message:errMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alert.tag = 1;
            //            reportAlert.message = @"由于网络原因，上报失败，请重新上报。";
            [alert show];
        }
        else
        {
            if(attchInfos != nil && [attchInfos count]  > 0) {
                NSMutableArray *a = [[NSMutableArray alloc]init];
                //            [param.Files addObjectsFromArray:attchInfos];
                [a addObjectsFromArray:attchInfos];
                entity.Attachs = a;
            }
            [EventOperate ReportEvtInfo:entity successBlock:^(EvtRes *evtRes) {
                NSString *msg = @"上报成功";
                if(evtRes.EvtCode.length>4)
                {
                    msg = [NSString stringWithFormat:@"上报成功,受理号为：%@",evtRes.EvtCode];
                    entity.EvtCode = evtRes.EvtCode;
                    
                    [EventSql insertEvent:entity];
                    for (int i =0; i<EvtList.count; i++) {
                        EvtFile *file = EvtList[i];
                        file.EvtCode = entity.EvtCode;
                        [EventSql insertFile:file];
                    }
                }
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"关闭" otherButtonTitles: nil];
                alert.tag = 2;
                [alert show];
            } failedBlock:^(NSString *errMsg) {
                //                [reportAlert dismissWithClickedButtonIndex:0 animated:YES];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:errMsg delegate:self cancelButtonTitle:@"关闭" otherButtonTitles: nil];
                alert.tag = 3;
                [alert show];
            }];
        }
    }
}

-(IBAction)DwBtn:(id)sender
{
    //    LocationMapView *view = [[LocationMapView alloc]init];
    //    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"213" style:UIBarButtonItemStyleDone target:self action:@selector(selectGps)];
    //    view.navigationItem.leftBarButtonItem = item;
    LocationBaiDuMapView *view = [[LocationBaiDuMapView alloc]init];
    [self.navigationController pushViewController:view animated:YES];
    
    //    [qmap setShowsUserLocation:YES];
    //    [location startUserLocationService];
}
#pragma -mark - textView 事件
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    //去掉字符串两边的空格
    //    textView.text = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    textViewPlaceholder.hidden = YES;
    CGRect frame = textView.frame;
    
    int offset = frame.origin.y + frame.size.height - (myScroll.frame.size.height - keyboardHeight);//216键盘高度
    NSTimeInterval animationduration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationduration];
    
    if(offset > 0)
    {
        //            self.view.frame = CGRectMake(0, -offset, self.view.frame.size.width, self.view.frame.size.height);
        [myScroll setContentOffset:CGPointMake(0, offset)];
    }
    [UIView commitAnimations];
    
}
-(void)textViewDidChange:(UITextView *)textView
{
    [self textviewPlaceholderHidden];
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    NSTimeInterval animationduration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationduration];
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    [self textviewPlaceholderHidden];
}
-(void)textviewPlaceholderHidden
{
    if(txtDescription.text.length>0)
    {
        textViewPlaceholder.hidden = YES;
    }
    else
    {
        textViewPlaceholder.hidden = NO;
    }
}

#pragma -mark - textField 事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    //去掉字符串两边的空格
    //    textView.text = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    indexTextField = textField;
}

-(void)textFieldDidEndEditing:(UITextView *)textView
{
    NSTimeInterval animationduration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationduration];
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == txtReportName)
        [txtPhone becomeFirstResponder];
    if(textField == txtPhone)
        [txtAddress becomeFirstResponder];
    if(textField == txtAddress)
        [txtDescription becomeFirstResponder];
//    if(textField == txtBZ)
//        [txtReportName becomeFirstResponder];
//    if(textField == txtReportName)
//        [txtPhone becomeFirstResponder];
    return false;
}


-(void)didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    /*
     GPS22.539032,113.953001 百度 22.539020,113.964414
     腾讯22.533239,113.957885 地图中心点22.533232,113.957893
     */
    //22.54473,113.95954 gps坐标
    //广东省深圳市南山区高新南一道6-1号
    //转换前22.538998,113.953003 转后百度坐标22.544730,113.959540
    BMKReverseGeoCodeOption *option = [[BMKReverseGeoCodeOption alloc]init];
    CLLocationCoordinate2D cl = userLocation.location.coordinate;
    
    NSDictionary *dic = BMKConvertBaiduCoorFrom(CLLocationCoordinate2DMake(22.533226,113.957893),BMK_COORDTYPE_COMMON);
    //    22.533232,113.957893/22.533226,113.957893
    cl =BMKCoorDictionaryDecode(dic);
    
    //    cl = userLocation.location.locationMarsFromBaidu.coordinate;
    //    transform_mars_from_baidu(0,0,aa,bb);
    option.reverseGeoPoint = cl;
    NSLog(@"百度%f,%f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    cl = userLocation.location.locationMarsFromBaidu.coordinate;
    NSLog(@"%f,%f",cl.latitude,cl.longitude);
    
    [location stopUserLocationService];
    [search reverseGeoCode:option];
}
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    txtAddress.text = result.address;
}

#pragma -mark - 相册相机监控事件
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if([mediaType isEqualToString:@"public.image"])
    {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        WSImage *img = [[WSImage alloc]init];
        //        image = [img scaleToSize:image size:CGSizeMake(320, 240)];
//        image = [img imageCompressForWidth:image targetWidth:320];
        if(image.size.height > 720)
            image = [img imageCompressForSize:image targetSize:CGSizeMake(0, 720)];
        NSLog(@"%f",image.size.height);
        NSData *data= UIImageJPEGRepresentation(image,1);
        BOOL isJPG=YES;
        if(data==nil)
        {
            data = UIImagePNGRepresentation(image);
            isJPG = NO;
        }
        if(data)
        {
            //            NSString *name = [self pictureName:isJPG];
            //            NSLog(@"%@",name);
            
            FileDetail* fileDetail =[[FileDetail alloc]init];
            fileDetail.data = data;
            fileDetail.name = [self pictureName:YES];
            [images addObject:fileDetail];
            
            NSMutableArray* list = (NSMutableArray*)_imagesScroll.arr;
            if([list containsObject:data] == NO) {
                [list addObject:data];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"选择的图片已经存在，请重新选择" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
            
            [_imagesScroll LoadScrollView];
        }
        self.navigationController.navigationBar.hidden = NO;
        FrontView.hidden = YES;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
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

-(void)btnDel:(id)sender
{
    UIButton *btn = sender;
    btn.hidden = YES;
}
-(void)DelImage:(NSInteger)tag index:(NSInteger)index
{
    [images removeObjectAtIndex:index];
}
-(void)AddImage:(NSInteger)tag
{
    //    scrollTag = tag;
    [self pickBtn:nil];
}

-(void)selectGps:(CLLocationCoordinate2D)coordinate address:(BMKAddressComponent*)address pose:(NSString *)pose
{
    //    MapGps = coordinate;
    //    NSLog(@"%f,%f",MapGps.latitude,MapGps.longitude);
    txtAddress.text = pose;
//    NSString *city = @"";
//    NSString *district = @"";
//    NSString *street = @"";
//    if(address!=nil)
//    {
//        city = address.city;
//        
//        NSString* dId = [self DictionaryKeyForValue:districtDic value:address.district];
//        
//        if(dId.length > 0)
//        {
//            district = address.district;
//            districtId = dId;
//        }
//        
//        NSMutableDictionary *streDic = [PublicHelper GetAddress:districtId type:2];
//        NSString* sId = [streDic objectForKey:address.streetName];
//        if(sId.length > 0)
//        {
//            street = address.streetName;
//            streetId = sId;
//        }
//        [btnRegion setTitle:[NSString stringWithFormat:@"%@%@",district,[self streetRemoveZJ:street]] forState:UIControlStateNormal];
//    }
    //    txtRegion.text = [NSString stringWithFormat:@"%@%@",district,street];
    
    
    //    CLLocation *locationGps = [[CLLocation alloc]initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    //    MapGps = locationGps.locationMarsFromBaidu.coordinate;
    MapGps = coordinate;
//    txtDescription.text = [NSString stringWithFormat:@"[%@]%@",city,pose];
    [self textviewPlaceholderHidden];
    //    NSLog(@"%f,%f",MapGps.latitude,MapGps.longitude);
    
}

-(NSString*)DictionaryKeyForValue:(NSDictionary*) dic value:(NSString*)value
{
    NSArray *keys = dic.allKeys;
    NSArray *values = dic.allValues;
    for (int i = 0; i < values.count; i++) {
        if([value isEqual:values[i]])
            return keys[i];
    }
    return @"";
}

#pragma -mark - 附件相关内容
-(void)DelImage:(NSInteger)index
{
    [images removeObjectAtIndex:index];
}
-(void)AddImage
{
    [self pickBtn:nil];
}


-(NSArray *)Upload:(NSString **)errMsg
{
    NSMutableArray *attachInfoArray = [NSMutableArray array];
    EvtList = [[NSMutableArray alloc]init];
    
    if (images.count) {
        *errMsg = nil;//@"上传附件失败";
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"upload",@"action",
                                       nil, nil];
        //        NSMutableArray* fileDetails = [[NSMutableArray alloc]init];
        //        for (int i=0; i<[images count]; i++) {
        //            NSData* data = images[i];
        //            FileDetail* fileDetail =[[FileDetail alloc]init];
        //            fileDetail.data = data;
        //            fileDetail.name = [self pictureName:YES];
        //
        //            [fileDetails addObject:fileDetail];
        //        }
        //        NSMutableArray* fileDetails = (NSMutableArray*)dataArray;
        
        
        for (int i=0; i<[images count]; i++) {
            
            FileDetail* fileDetail = images[i];
            
            [params setObject:fileDetail forKey:fileDetail.name];
        }
        
        
        NSString *IP = [PublicHelper GetSettingValue:@"HttpIP"];
        
        NSData *result = [HttpFileUpload upload:[NSString stringWithFormat:@"http://%@/ashx/attchupload.ashx",IP] widthParams:params];
        if(result != nil) {
            NSInteger count = [result length] / 36;
            if(count == [images count]) {
                NSString* uuidStrs = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
                for (int i=0; i < count; i++) {
                    NSRange range = NSMakeRange(i*36, 36);
                    NSString* uuidStr = [uuidStrs substringWithRange:range];
                    //                    NSUUID* uuid = [[NSUUID alloc]initWithUUIDString:uuidStr];
                    
                    FileDetail *fileDetail = images[i];
                    AttachInfo* info = [[AttachInfo alloc] init];
                    info.Id = uuidStr;
                    info.Name = fileDetail.name;
                    info.Type = 0;
                    info.UsageType = 0;
                    info.IsChecked = @"false";
                    info.Uploaded = @"true";
                    info.GeoX = [[NSNumber alloc]initWithDouble:MapGps.longitude];
                    info.GeoY = [[NSNumber alloc]initWithDouble:MapGps.latitude];
                    info.AbsX = [[NSNumber alloc]initWithDouble:MapGps.longitude];
                    info.AbsY = [[NSNumber alloc]initWithDouble:MapGps.latitude];
                    
                    [attachInfoArray addObject:info];
                    EvtFile *file = [[EvtFile alloc]init];
                    file.ID = uuidStr;
                    file.FileName = fileDetail.name;
                    file.fileData = fileDetail.data;
                    [EvtList addObject:file];
                }
                *errMsg = nil;
            }
        }
    }
    return attachInfoArray;
}

#pragma -mark - picker相关内容（所在区域）
-(void)defaultPicker
{
    //    districtDic = [[NSMutableDictionary alloc]initWithDictionary:[PublicHelper GetAddress:@"" type:1]];
    //    streetDic = [NSMutableDictionary new];
    districtNames = [PublicHelper GetAddress:@"" type:0];
    districtDic = [PublicHelper GetAddress:@"" type:1];
    
    NSInteger index = [districtDic.allValues indexOfObject:districtNames[0]];
    streetDic = [PublicHelper GetAddress:districtDic.allKeys[index] type:2];
    myPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, viewHeight - 216, viewWidth, 216)];
    myPickerView.delegate = self;
    myPickerView.dataSource = self;
    myPickerView.hidden = YES;
    myPickerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    pickBackgroundBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    
    pickBackgroundBtn.backgroundColor = [UIColor groupTableViewBackgroundColor];
    pickBackgroundBtn.alpha = 0.5;
    pickBackgroundBtn.hidden = YES;
    [pickBackgroundBtn addTarget:self action:@selector(pickerVIewShowOrHide) forControlEvents:UIControlEventTouchUpInside];
    
    toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, myPickerView.frame.origin.y - 44, viewWidth, 44)];
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(barItemClick:)];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *item3 = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(barItemClick:)];
    
    toolBar.items = [NSArray arrayWithObjects:item1,item2,item3, nil];
    toolBar.hidden = YES;
    
    
    [self.view addSubview:pickBackgroundBtn];
    [self.view addSubview:toolBar];
    [self.view addSubview:myPickerView];
}
-(IBAction)pickerVIewShowOrHide
{
    [self oneFingerTwoTaps];
    myPickerView.hidden = !myPickerView.hidden;
    toolBar.hidden = !toolBar.hidden;
    pickBackgroundBtn.hidden = !pickBackgroundBtn.hidden;
}
-(void)barItemClick:(UIBarButtonItem*)item
{
    if([item.title isEqualToString: @"确定"])
    {
        NSInteger districtIndex = [myPickerView selectedRowInComponent:0];
        NSInteger streetIndex = [myPickerView selectedRowInComponent:1];
        NSString *name = districtNames[districtIndex];
        NSInteger index = [districtDic.allValues indexOfObject:name];
        [btnRegion setTitle:[NSString stringWithFormat:@"%@%@",name,[self streetRemoveZJ:streetDic.allValues[streetIndex]]] forState:UIControlStateNormal];
        
        districtId = districtDic.allKeys[index];
        streetId = streetDic.allKeys[streetIndex];
    }
    
    [self pickerVIewShowOrHide];
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == 0)
        return districtNames.count;//districtDic.allKeys.count;
    if(component == 1)
        return streetDic.allKeys.count;
    return 0;
}
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component == 0)
        return districtNames[row];//[districtDic objectForKey:districtNames[row]];
    if(component == 1)
    {
        NSString *streetName = [streetDic objectForKey:streetDic.allKeys[row]];
        streetName = [self streetRemoveZJ:streetName];
        
        return streetName;//[streetDic objectForKey:streetDic.allKeys[row]];
    }
    return @"";
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(component == 0)
    {
//        NSString *disName = [districtDic objectForKey:districtDic.allKeys[row]];
        NSString *disName = districtNames[row];
        NSInteger index = [districtDic.allValues indexOfObject:disName];
        streetDic = [PublicHelper GetAddress:districtDic.allKeys[index] type:2];
        //重点！更新第二个轮子的数据
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:NO];
        NSLog(@"%@",disName);
    }
    
    if(component == 1)
    {
        NSString *streetName = [streetDic objectForKey:streetDic.allKeys[row]];
        //重点！更新第二个轮子的数据
        [pickerView reloadComponent:1];
        NSLog(@"%@",streetName);
    }
}
-(NSString*)streetRemoveZJ:(NSString*)streetName
{
    NSRange range = [streetName rangeOfString:@"镇"];
    
    if(range.location !=NSNotFound)
        streetName = [streetName substringToIndex:range.location];
    
    
    NSRange range1 = [streetName rangeOfString:@"街道"];
    if(range1.location !=NSNotFound)
        streetName = [streetName substringToIndex:range1.location];
    return streetName;
}

#pragma -mark - 受理主体处理方法
-(IBAction)reciveClick:(id)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"受理主题" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"属地受理" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ReciveType = [NSNumber numberWithInt:2];
        [btnRecive setTitle:@"受理主体：属地受理" forState:UIControlStateNormal];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"市级受理" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ReciveType = [NSNumber numberWithInt:1];
        [btnRecive setTitle:@"受理主体：市级受理" forState:UIControlStateNormal];
    }];
    [alert addAction:action];
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
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
