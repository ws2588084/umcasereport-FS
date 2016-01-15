//
//  EventCell.h
//  umcasereport
//
//  Created by WangShuai on 15/2/2.
//  Copyright (c) 2015年 Topevery. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventCell : UITableViewCell
{
    IBOutlet UILabel *lblIndex;
    IBOutlet UILabel *lblTitle;
    IBOutlet UILabel *lblAddress;
//    IBOutlet UILabel *lblContent;
    IBOutlet UILabel *rightTitle;
    IBOutlet UILabel *lblEvtTitle;
    IBOutlet UILabel *lblLeft;
    CGFloat viewWidth;
}
@property(nonatomic)NSInteger index;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *address;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSString *dateTime;
@property(nonatomic,strong)NSString *todoName;
@property(nonatomic,strong)NSString *evtTitle;
@property(nonatomic,strong)NSString *evtStatus;

-(void)loadCell;

@end
