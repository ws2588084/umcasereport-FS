//
//  RootViewController.h
//  umcasereport-FS
//
//  Created by WangShuai on 15/7/2.
//  Copyright (c) 2015年 Topevery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingOneView.h"
#import <MessageUI/MessageUI.h>
#import "EventListView.h"
#import "GGViewController.h"
#import "WebViewController.h"
#import "WSImage.h"
#import "ReprotView.h"
#import "SlideNavigationController.h"
#import "PublicHelper.h"
#import "AboutViewController.h"

@interface RootViewController : UIViewController<secondViewDelegate,MFMessageComposeViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,SlideNavigationControllerDelegate>
{
    float viewWidth;
    NSData *ImageData;
    NSString *updUrl;
    UIAlertView *updAlertView;
    IBOutlet UIImageView *backgroundImg;
}

@end
