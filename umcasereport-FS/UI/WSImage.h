//
//  WSImage.h
//  umcasereport
//
//  Created by WangShuai on 15/2/2.
//  Copyright (c) 2015年 Topevery. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSImage : UIImage
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;
-(UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;
-(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;
@end
