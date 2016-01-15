//
//  ButtonView.h
//  TopeveryEO
//
//  Created by WangShuai on 14/11/22.
//  Copyright (c) 2014年 Topevery. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ButtonView : UIButton<NSURLConnectionDelegate>
{
    NSMutableData *webData;
}
@property (nonatomic) float imgHeight;
@property (nonatomic,strong) NSString *badge;
@property (nonatomic,strong) NSURLConnection *conn;
@property (nonatomic,strong)NSMutableData *data;
@property (nonatomic,strong)NSURLResponse *response;

-(CGFloat)getHeightWithString:(NSString *)aStr WithSize:(CGSize)aSize WithFont:(UIFont *)aFont;

@end
