//
//  EventCell.m
//  umcasereport
//
//  Created by WangShuai on 15/2/2.
//  Copyright (c) 2015年 Topevery. All rights reserved.
//

#import "EventCell.h"

@implementation EventCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)loadCell
{
    viewWidth = [[UIScreen mainScreen]bounds].size.width;
    //案件标题
    lblTitle.text = [NSString stringWithFormat:@"受 理 号：%@",_title];
    //地址信息
    lblAddress.text = [NSString stringWithFormat:@"地  址：%@",_address];
    
    //案件信息
    UILabel *lblContent = [[UILabel alloc]initWithFrame:CGRectMake(30, lblAddress.frame.origin.y + lblAddress.frame.size.height, lblAddress.frame.size.width, lblAddress.frame.size.height)];
    _content = [NSString stringWithFormat:@"问  题：%@",_content];
    lblContent.numberOfLines = 0;
    lblContent.font = [UIFont fontWithName:@"Chalkboard SE" size:14];//[UIFont systemFontOfSize:13];
    lblContent.text = _content;
    lblContent.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size = [lblContent sizeThatFits:CGSizeMake(lblContent.frame.size.width, MAXFLOAT)];
    lblContent.frame = CGRectMake(lblContent.frame.origin.x, lblContent.frame.origin.y, lblContent.frame.size.width, size.height);
    [self addSubview:lblContent];
    //案件状态
    UILabel *lblEvtStatus = [[UILabel alloc]initWithFrame:CGRectMake(30, lblContent.frame.origin.y + lblContent.frame.size.height, lblContent.frame.size.width, lblContent.frame.size.height)];
    _evtStatus = [NSString stringWithFormat:@"案件状态：%@",_evtStatus];
    lblEvtStatus.numberOfLines = 0;
    lblEvtStatus.font = [UIFont fontWithName:@"Chalkboard SE" size:14];//[UIFont systemFontOfSize:13];
    lblEvtStatus.text = _evtStatus;
    lblEvtStatus.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size1 = [lblEvtStatus sizeThatFits:CGSizeMake(lblEvtStatus.frame.size.width, MAXFLOAT)];
    lblEvtStatus.frame = CGRectMake(lblEvtStatus.frame.origin.x, lblEvtStatus.frame.origin.y, lblEvtStatus.frame.size.width, size1.height);
    [self addSubview:lblEvtStatus];
    //案件号
    lblEvtTitle.frame = CGRectMake(8, size1.height + 10 + lblEvtStatus.frame.origin.y, lblEvtTitle.frame.size.width, lblEvtTitle.frame.size.height);
    lblEvtTitle.text = [NSString stringWithFormat:@"案 件 号：%@",_evtTitle];
    //案件时间
    rightTitle.frame = CGRectMake(8, lblEvtTitle.frame.size.height + 10 + lblEvtTitle.frame.origin.y, rightTitle.frame.size.width, rightTitle.frame.size.height);
    rightTitle.text = [NSString stringWithFormat:@"上报时间：%@",_dateTime];
    
    self.frame = CGRectMake(0, 0, viewWidth, rightTitle.frame.origin.y + rightTitle.frame.size.height);
    
    //添加标签
    lblIndex.text = [NSString stringWithFormat:@"%d",_index + 1];
    lblIndex.layer.masksToBounds = YES;
    lblIndex.textColor = [UIColor whiteColor];
    [lblIndex.layer setCornerRadius:CGRectGetHeight([lblIndex bounds]) / 2];
    lblIndex.layer.borderWidth = 1;
    lblIndex.layer.borderColor = [UIColor clearColor].CGColor;
    //待办环节
    lblLeft.text = _todoName;
}

@end
