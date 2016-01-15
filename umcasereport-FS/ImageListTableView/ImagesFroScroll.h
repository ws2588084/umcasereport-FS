//
//  ImagesFroTable.h
//  图片缩略图
//
//  Created by EightLong on 14-9-2.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MRImgShowView.h"

typedef enum {
    HorizontalDirectiona=0,
    VerticalDirectionb=1
}SlidingDirection;
@protocol HttpToDataDelegate

-(void)finishImgData:(NSData*)data;

@end


@protocol EditImageDelegate

-(void)DelImage:(NSInteger)tag index:(NSInteger)index;
-(void)AddImage:(NSInteger)tag;

@end

@interface ImagesFroScroll : UIScrollView<UIAlertViewDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate,HttpToDataDelegate>
{
    NSInteger delTag;
    float viewWidth;
    NSInteger selImgIndex;
    UIView *indexView;
    MRImgShowView *imgShowView;
    UIScrollView *scroll;
//    UIScrollView *kImgVCenter;
    UIImageView *indexImg;
    NSMutableArray *imgArry;
}

@property(strong,nonatomic) NSMutableArray *arr;
@property(strong,nonatomic) UIViewController *v;
@property(weak,nonatomic) id<EditImageDelegate> EditImageDelegate;
@property(nonatomic) int column;
@property(nonatomic) CGFloat imageWidth;
@property(nonatomic) BOOL isAdd;
@property(nonatomic) BOOL isDel;
@property(nonatomic) SlidingDirection dir;
//最多可选择多少图片
@property(nonatomic) NSInteger imgMaxNum;
-(void)LoadScrollView;
@end
