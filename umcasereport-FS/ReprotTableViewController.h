//
//  ReprotTableViewController.h
//  umcasereport-FS
//
//  Created by WangShuai on 15/9/25.
//  Copyright © 2015年 Topevery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImagesFroScroll.h"
//#import <BaiduMapAPI/BMapKit.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "ReportEventEntity.h"

@interface ReprotTableViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *table;
    ImagesFroScroll *_imagesScroll;
    CGFloat viewWidth;
    CGFloat viewHeight;
    NSMutableArray *titles;
    NSMutableArray *values;
}
@property(nonatomic,strong) IBOutlet ImagesFroScroll *imagesScroll;
@property(nonatomic,strong) NSData *ImageData;
- (IBAction)pickBtn:(id)sender;
- (IBAction)reportBtn:(id)sender;
-(void)selectGps:(CLLocationCoordinate2D)coordinate address:(BMKAddressComponent*)address pose:(NSString *)pose;

@end
