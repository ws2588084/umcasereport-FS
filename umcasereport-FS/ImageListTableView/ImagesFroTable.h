//
//  ImagesFroTable.h
//  图片缩略图
//
//  Created by EightLong on 14-9-2.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ImagesFroTable : UITableView<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate>
{
    NSInteger delTag;
}

@property(strong,nonatomic) NSArray *arr;
@property(strong,nonatomic) UIView *v;
@property(nonatomic) BOOL IsAdd;
-(void)tableViewLoad;

@end
