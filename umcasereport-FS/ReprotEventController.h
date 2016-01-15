//
//  ReprotViewController.h
//  umcasereport-FS
//
//  Created by WangShuai on 15/9/26.
//  Copyright © 2015年 Topevery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImagesFroScroll.h"
//#import <BaiduMapAPI/BMapKit.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "ReportEventEntity.h"

@interface ReprotEventController : UIViewController<BMKGeoCodeSearchDelegate,BMKLocationServiceDelegate,CLLocationManagerDelegate,UITextViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,EditImageDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIScrollView *myScroll;
    BMKLocationService *location;
    BMKGeoCodeSearch *search;
    UITextField *txtPhone;
    UITextField *txtAddress;
    
    UIButton *btnRegion;
    UIButton *btnRecive;
    UITextView *txtDescription;
    UITextField *txtBZ;
    UITextField *txtReportName;
    UISwitch *MySwitch;
    
    UITextField *indexTextField;
    
    UILabel *textViewPlaceholder;
    UIView *FrontView;
    NSMutableArray *images;
    float keyboardHeight;
    //定位好的坐标
    CLLocationCoordinate2D MapGps;
    //上报时的提示
    UIAlertView *reportAlert;
    NSMutableArray *EvtList;
    
    UIScrollView *imageScroll;
    float viewWidth;
    float viewHeight;
    UIView *switchView;
    
    NSArray *districtNames;
    NSMutableDictionary *districtDic;
    NSMutableDictionary *streetDic;
    
    //选择后保存要上报的数据
    NSString *districtId;
    NSString *streetId;
    NSNumber *ReciveType;
    
    UIPickerView *myPickerView;
    UIButton *pickBackgroundBtn;
    UIToolbar *toolBar;
}
@property(nonatomic,strong) ImagesFroScroll *imagesScroll;
@property(nonatomic,strong) NSData *ImageData;
- (IBAction)pickBtn:(id)sender;
- (IBAction)reportBtn:(id)sender;
-(void)selectGps:(CLLocationCoordinate2D)coordinate address:(BMKAddressComponent*)address pose:(NSString *)pose;

@end
