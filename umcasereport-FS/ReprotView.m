//
//  ReprotView.m
//  CSGL
//
//  Created by WangShuai on 15/1/15.
//  Copyright (c) 2015年 topevery. All rights reserved.
//

#import "ReprotView.h"
//#import "LocationMapView.h"
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

@interface ReprotView ()

@end

@implementation ReprotView
-(void)viewWillAppear:(BOOL)animated
{
//    if(images.count <= 0)
//    {
//        [self addTitleImg];
//    }
//    else
//    {
//        [self addNavigatItems];
//    }
    [self addNavigatItems];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
//    self.navigationController.navigationBar.translucent = NO;
    //22.536814,113.974518
    //默认定位坐标是0，0
    self.title = @"案件上报";
    viewWidth = [[UIScreen mainScreen]bounds].size.width;
    viewHeight = [[UIScreen mainScreen]bounds].size.height;
    images = [[NSMutableArray alloc]init];
    MapGps = CLLocationCoordinate2DMake(0, 0);
    
    keyboardHeight = 0;
    //switch所在的母体边框样式
    switchView.layer.borderColor =  [[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.3] CGColor];
    switchView.layer.borderWidth = 1;
    switchView.layer.cornerRadius = 5;
    
    FileDetail* fileDetail =[[FileDetail alloc]init];
    fileDetail.data = _ImageData;
    fileDetail.name = [self pictureName:YES];
    [images addObject:fileDetail];
    
    CGRect rect = _imagesScroll.frame;
    _imagesScroll = [[ImagesFroScroll alloc]initWithFrame:CGRectMake(rect.origin.x, rect.origin.y, viewWidth-16, 80)];
    _imagesScroll.imageWidth = 70;
    _imagesScroll.v = self;
    _imagesScroll.column = 3;
    _imagesScroll.imgMaxNum = 3;
    _imagesScroll.EditImageDelegate = self;
    _imagesScroll.isAdd = YES;
    _imagesScroll.isDel = YES;
    [self.view addSubview:_imagesScroll];
    
    NSMutableArray* list = (NSMutableArray*)_imagesScroll.arr;
    [list addObject:_ImageData];
    [_imagesScroll LoadScrollView];
    
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
    
//    [self addNavigatItems];
//    CGSize ScreenSize = [[UIScreen mainScreen] bounds].size;
    //百度地图定位 以及获得地理编码
    location = [[BMKLocationService alloc]init];
    location.delegate = self;
    search = [[BMKGeoCodeSearch alloc]init];
    search.delegate = self;
    self.tabBarController.tabBar.tintColor = [UIColor orangeColor];
    
    UIButton *btnDW = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, txtAddress.frame.size.height)];
    [btnDW addTarget:self action:@selector(DwBtn:) forControlEvents:UIControlEventTouchUpInside];
    [btnDW setTitle:@"定位" forState:UIControlStateNormal];
    [btnDW setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btnDW.titleLabel.font = [UIFont systemFontOfSize:14];
    //UITextField 右侧添加一个ui
    txtAddress.rightView=btnDW;
    txtAddress.rightViewMode = UITextFieldViewModeAlways;

    
    //文本编辑框中添加提示信息
    textViewPlaceholder= [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 320, 30)];
    textViewPlaceholder.text = @"请输入详细描述内容";
    textViewPlaceholder.textColor = [UIColor lightGrayColor];
    textViewPlaceholder.font = [UIFont systemFontOfSize:14];
    [txtDescription addSubview:textViewPlaceholder];
    //文本编辑框添加边框
    txtDescription.layer.borderColor =  [[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.3] CGColor];
    txtDescription.layer.borderWidth = 1;
    txtDescription.layer.cornerRadius = 5;
    
    NSString *phone = [PublicHelper GetSettingValue:@"UserPhone"];
    txtPhone.text = phone;
    NSString *name = [PublicHelper GetSettingValue:@"UserName"];
    txtReportName.text = name;
    
    
    btnRecive.layer.borderColor =  [[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.3] CGColor];
    btnRecive.layer.borderWidth = 1;
    btnRecive.layer.cornerRadius = 5;
    btnRegion.layer.borderColor =  [[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.3] CGColor];
    btnRegion.layer.borderWidth = 1;
    btnRegion.layer.cornerRadius = 5;
    
    ReciveType = [NSNumber numberWithInt:2];
    
    [self defaultPicker];
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
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
//        NSLog(@"%f",frame.origin.y);
        int offset = frame.origin.y + frame.size.height - (self.view.frame.size.height - keyboardHeight);//216键盘高度
        NSTimeInterval animationduration = 0.30f;
        [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
        [UIView setAnimationDuration:animationduration];
        
        if(offset > 0)
        {
            self.view.frame = CGRectMake(0, -offset, self.view.frame.size.width, self.view.frame.size.height);
        }
        [UIView commitAnimations];
    }
    else
    {
        CGRect frame = txtDescription.frame;
        int offset = frame.origin.y + frame.size.height - (self.view.frame.size.height - keyboardHeight);//216键盘高度
        NSTimeInterval animationduration = 0.30f;
        [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
        [UIView setAnimationDuration:animationduration];
        
        if(offset > 0)
        {
            self.view.frame = CGRectMake(0, -offset, self.view.frame.size.width, self.view.frame.size.height);
        }
        [UIView commitAnimations];
    }
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if(!txtPhone.text.length >0)
        errMsg = @"请输入手机号码，以方便问题处理时及时联系您！";
    else if(!txtAddress.text.length >0)
        errMsg = @"请输入事发位置，以方便更快的定位事发位置，进行处理！";
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
    NSLog(@"%f",frame.origin.y);
    int offset = frame.origin.y + frame.size.height - (self.view.frame.size.height - keyboardHeight);//216键盘高度
    NSTimeInterval animationduration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationduration];
    
    if(offset > 0)
    {
        self.view.frame = CGRectMake(0, -offset, self.view.frame.size.width, self.view.frame.size.height);
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
    [textField resignFirstResponder];
    if(textField == txtAddress)
       [txtDescription becomeFirstResponder];
    if(textField == txtBZ)
        [txtReportName becomeFirstResponder];
    if(textField == txtReportName)
        [txtPhone becomeFirstResponder];
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
        image = [img imageCompressForWidth:image targetWidth:320];
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
    NSString *city = @"";
    NSString *district = @"";
    NSString *street = @"";
    if(address!=nil)
    {
        city = address.city;
        
        NSString* dId = [self DictionaryKeyForValue:districtDic value:address.district];
        
        if(dId.length > 0)
        {
            district = address.district;
            districtId = dId;
        }
        
        NSMutableDictionary *streDic = [PublicHelper GetAddress:districtId type:2];
        NSString* sId = [streDic objectForKey:address.streetName];
        if(sId.length > 0)
        {
            street = address.streetName;
            streetId = sId;
        }
    }
//    txtRegion.text = [NSString stringWithFormat:@"%@%@",district,street];
    
    [btnRegion setTitle:[NSString stringWithFormat:@"%@%@",district,street] forState:UIControlStateNormal];
    
//    CLLocation *locationGps = [[CLLocation alloc]initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
//    MapGps = locationGps.locationMarsFromBaidu.coordinate;
    MapGps = coordinate;
    txtDescription.text = [NSString stringWithFormat:@"[%@]%@",city,pose];
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
    districtDic = [PublicHelper GetAddress:@"" type:1];
    streetDic = [PublicHelper GetAddress:districtDic.allKeys[0] type:2];
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
    
    [btnRegion setTitle:[NSString stringWithFormat:@"%@%@",districtDic.allValues[districtIndex],streetDic.allValues[streetIndex]] forState:UIControlStateNormal];
    
    districtId = districtDic.allKeys[districtIndex];
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
        return districtDic.allKeys.count;
    if(component == 1)
        return streetDic.allKeys.count;
    return 0;
}
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component == 0)
        return [districtDic objectForKey:districtDic.allKeys[row]];
    if(component == 1)
        return [streetDic objectForKey:streetDic.allKeys[row]];
    return @"";
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(component == 0)
    {
        NSString *disName = [districtDic objectForKey:districtDic.allKeys[row]];
        streetDic = [PublicHelper GetAddress:districtDic.allKeys[row] type:2];
        //重点！更新第二个轮子的数据
        [pickerView reloadComponent:1];
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

#pragma -mark - 受理主体处理方法
-(IBAction)reciveClick:(id)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"受理主题" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"属地受理" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ReciveType = [NSNumber numberWithInt:2];
        [btnRecive setTitle:@"属地受理" forState:UIControlStateNormal];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"市级受理" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ReciveType = [NSNumber numberWithInt:1];
        [btnRecive setTitle:@"市级受理" forState:UIControlStateNormal];
    }];
    [alert addAction:action];
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
