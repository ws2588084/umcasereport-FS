//
//  CityManagemantViewController.h
//  umcasereport-FS
//
//  Created by WangShuai on 15/9/21.
//  Copyright © 2015年 Topevery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ButtonView.h"
#import <MessageUI/MessageUI.h>
#import "EventListView.h"
#import "WebViewController.h"
#import "GGViewController.h"
#import "SettingOneView.h"
#import "WSImage.h"
#import "ReprotView.h"
#import "SlideNavigationController.h"
#import "PublicHelper.h"
#import "ReprotTableViewController.h"
#import "ReprotEventController.h"
#import "WeiXinViewController.h"

@interface CityManagemantViewController : UIViewController<secondViewDelegate,MFMessageComposeViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    CGFloat viewWidth;
    CGFloat viewHeight;
    NSData *ImageData;
    NSString *updUrl;
    UIAlertView *updAlertView;
}

@end
