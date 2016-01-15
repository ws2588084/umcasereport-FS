//
//  ButtonView.m
//  TopeveryEO
//
//  Created by WangShuai on 14/11/22.
//  Copyright (c) 2014年 Topevery. All rights reserved.
//

#import "ButtonView.h"
#import "AppDelegate.h"

@implementation ButtonView

-(void)layoutSubviews
{
    [super layoutSubviews];
//    CGPoint center = self.imageView.center;
//    center.x = self.frame.size.width/2;
//    center.y = self.frame.size.height/2 - _imgHeight/2;
    float x = self.frame.size.width/2 - _imgHeight/2;
    float y = self.frame.size.height/2 - _imgHeight/2 - 10;
    if(_imgHeight!=0)
    {
        self.imageView.frame = CGRectMake(x, y, _imgHeight, _imgHeight);
//        self.imageView.center = center;
    }
    
    //Center text
    CGRect newFrame = [self titleLabel].frame;
    newFrame.origin.x = 0;
    newFrame.origin.y = self.imageView.frame.size.height+self.imageView.frame.origin.y + 8;//self.imageView.frame.size.height;
    newFrame.size.width = self.frame.size.width;
    newFrame.size.height = [self getHeightWithString:self.titleLabel.text WithSize:newFrame.size WithFont:self.titleLabel.font];
    
//    self.titleLabel.backgroundColor = [UIColor redColor];
    self.titleLabel.frame = newFrame;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    CGFloat btnWidth = self.frame.size.width;
    CGFloat lblWidth = btnWidth/5;
    if(_badge>0)
    {
        UILabel *labBadge = [[UILabel alloc]initWithFrame:CGRectMake(btnWidth-lblWidth, 0, lblWidth, lblWidth)];
        labBadge.backgroundColor = [UIColor groupTableViewBackgroundColor];
        labBadge.text = @"1";
        labBadge.font = [UIFont systemFontOfSize:14];
        labBadge.textAlignment = NSTextAlignmentCenter;
        labBadge.textColor = [UIColor darkGrayColor];
        labBadge.layer.masksToBounds = YES;
        [labBadge.layer setCornerRadius:CGRectGetHeight([labBadge bounds]) / 2];
        [self addSubview:labBadge];
    }
}

- (CGFloat)getHeightWithString:(NSString *)aStr WithSize:(CGSize)aSize WithFont:(UIFont *)aFont
{
    CGRect rect;
    
    if ([[[UIDevice currentDevice] systemVersion]floatValue]>=7)//IOS 7.0 以上
    {
        NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:aFont, NSFontAttributeName,nil];
        
        rect = [aStr boundingRectWithSize:aSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:tdic context:nil];
    }
    else
    {
        rect.size = [aStr sizeWithFont:aFont constrainedToSize:aSize lineBreakMode:NSLineBreakByCharWrapping];
    }
    return rect.size.height;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
