//
//  ReprotView.h
//  CSGL
//
//  Created by WangShuai on 15/1/15.
//  Copyright (c) 2015年 topevery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImagesFroScroll.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import "ReportEventEntity.h"

@interface ReprotView : UIViewController<BMKGeoCodeSearchDelegate,BMKLocationServiceDelegate,CLLocationManagerDelegate,UITextViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,EditImageDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    BMKLocationService *location;
    BMKGeoCodeSearch *search;
    IBOutlet UITextField *txtPhone;
    IBOutlet UITextField *txtAddress;
    
    IBOutlet UIButton *btnRegion;
    IBOutlet UIButton *btnRecive;
    IBOutlet UITextView *txtDescription;
    IBOutlet UITextField *txtBZ;
    IBOutlet UITextField *txtReportName;
    IBOutlet UISwitch *MySwitch;
    
    UITextField *indexTextField;
    
    IBOutlet UILabel *textViewPlaceholder;
    IBOutlet UIView *FrontView;
    IBOutlet NSMutableArray *images;
    float keyboardHeight;
    //定位好的坐标
    CLLocationCoordinate2D MapGps;
    //上报时的提示
    UIAlertView *reportAlert;
    NSMutableArray *EvtList;
    
    IBOutlet UIScrollView *imageScroll;
    float viewWidth;
    float viewHeight;
    IBOutlet UIView *switchView;
    
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
@property(nonatomic,strong) IBOutlet ImagesFroScroll *imagesScroll;
@property(nonatomic,strong) NSData *ImageData;
- (IBAction)pickBtn:(id)sender;
- (IBAction)reportBtn:(id)sender;
-(void)selectGps:(CLLocationCoordinate2D)coordinate address:(BMKAddressComponent*)address pose:(NSString *)pose;

@end
