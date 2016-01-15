//
//  SettingOneView.m
//  CSGL
//
//  Created by WangShuai on 15/1/19.
//  Copyright (c) 2015年 topevery. All rights reserved.
//

#import "SettingOneView.h"
#import "AppDelegate.h"

@interface SettingOneView ()

@end

@implementation SettingOneView

- (void)viewDidLoad {
    
//    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Setting" ofType:@"plist"];
//    NSMutableDictionary *data = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
    NSString *IP = [PublicHelper GetSettingValue:@"HttpIP"];
//    appDelegate.Http_IP = txtSetting.text;
    txtSetting.text =IP;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(barButton:)];
    UIBarButtonItem *itemLeft = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(leftBarButton:)];
    
    self.navigationItem.rightBarButtonItem = item;
    self.navigationItem.leftBarButtonItem = itemLeft;
    //    txtSetting.borderStyle = [UIColor lightGrayColor];
    NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:_SetName];
    if(value == nil)
        txtSetting.placeholder = @"请填写";
    else
        txtSetting.text = value;
    self.title = _SetName;
    [txtSetting setBounds:CGRectInset(txtSetting.bounds, 10, 10)];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)barButton:(id)sender
{
    if([_SetName isEqualToString:@"设置"])
    {
        
//        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Setting" ofType:@"plist"];
//        NSMutableDictionary *data = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
//        NSString *IP = [data valueForKey:@"HttpIP"];
//        IP = txtSetting.text;
        [PublicHelper UpdateSettingValue:@"HttpIP" value:txtSetting.text];
    }
//    [[NSUserDefaults standardUserDefaults] setObject:txtSetting.text forKey:_SetName];
//    [self.delegate showName:_SetName cellIndex:_cellIndex];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction)leftBarButton:(id)sender
{
//    [self.navigationController popToViewController:[self parentViewController] animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
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
