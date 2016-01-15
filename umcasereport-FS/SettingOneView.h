//
//  SettingOneView.h
//  CSGL
//
//  Created by WangShuai on 15/1/19.
//  Copyright (c) 2015年 topevery. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol secondViewDelegate

-(void)showName:(NSString *)setName cellIndex:(NSIndexPath*)cellIndex;

@end

@interface SettingOneView : UIViewController
{
    IBOutlet UITextField *txtSetting;
}

@property (nonatomic,strong) IBOutlet NSString *SetName;
-(IBAction)barButton:(id)sender;
@property (nonatomic,weak) id<secondViewDelegate> delegate;
@property (nonatomic,strong) IBOutlet NSIndexPath *cellIndex;

@end
