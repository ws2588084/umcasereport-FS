//
//  ImagesFroScroll.m
//  图片缩略图
//
//  Created by EightLong on 14-9-2.
//
//

#import "ImagesFroScroll.h"
#import "HttpImageButton.h"

@implementation ImagesFroScroll

- (id)initWithFrame:(CGRect)frame
{
    //    self.dataSource = self;
    //    self.delegate = self;
    self = [super initWithFrame:frame];
    viewWidth = [[UIScreen mainScreen]bounds].size.width;
    //    NSMutableArray *list =(NSMutableArray *)self.arr;
    self.arr = [[NSMutableArray alloc]init];
    imgArry = [NSMutableArray new];
    if (self) {
        // Initialization code
        _isDel = NO;
        
    }
    return self;
}

-(void)LoadScrollView
{
    for(UIView *subview in self.subviews)
    {
        [subview removeFromSuperview];
        self.contentSize = CGSizeMake(0, 0);
    }
    NSInteger lastAddImg = 6;
    if(_imgMaxNum>0)
        lastAddImg = _imgMaxNum;
    for (int i = 0; i<=_arr.count; i++) {
        
        //        CGFloat scrollSizeWidth = self.contentSize.width;
        CGFloat x = i * (_imageWidth + 8);
        CGFloat y = 0;
        if(_imageWidth == 0.0f)
        {
            _imageWidth = (viewWidth - (_column+1)*8) / _column;
            x = i % _column * (_imageWidth + 8);
            y = i / _column * (_imageWidth + 8);
        }
        if(i<_arr.count)
        {
            HttpImageButton *btn = [[HttpImageButton alloc]initWithFrame:CGRectMake(x, y, _imageWidth, _imageWidth)];
            
            btn.restorationIdentifier =[NSString stringWithFormat:@"%d",i];
            Class urlCls = NSClassFromString(@"NSString");
            if([_arr[i] isKindOfClass:urlCls])
            {
                [btn LoadBtnImage:_arr[i]];
                
                [btn.imageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
                btn.imageView.contentMode =  UIViewContentModeScaleAspectFill;
                btn.imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
                btn.imageView.clipsToBounds  = YES;
                btn.httpToDataDelegate = self;
            }
            else
            {
                UIImage *img = [[UIImage alloc]initWithData:self.arr[i]];
                if(btn.frame.size.width < img.size.width || btn.frame.size.height < img.size.height)
                {
                    float widthBS = img.size.width/btn.frame.size.width;
                    float heightBS = img.size.height/btn.frame.size.height;
                    float bs = widthBS > heightBS ? heightBS : widthBS;
                    img = [[UIImage alloc]initWithData:self.arr[i] scale:bs];
                }
                [btn setImage:img forState:UIControlStateNormal];
            }
            btn.imageView.contentMode = UIViewContentModeCenter;
            //            btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
            //添加点击事件
            [btn addTarget:self action:@selector(imageShow:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            if(_isDel)
            {
                UIButton *btnDel = [[UIButton alloc]initWithFrame:CGRectMake(x + _imageWidth-26, y, 26, 26)];
                [btnDel setBackgroundImage:[UIImage imageNamed:@"btn_del_default"] forState:UIControlStateNormal];
                
                [btnDel addTarget:self action:@selector(btnDel:) forControlEvents:UIControlEventTouchUpInside];
                btnDel.tag = 100 + i;
                [self addSubview:btnDel];
            }
        }
        else if(i<lastAddImg && _isAdd)
        {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(x, y, _imageWidth, _imageWidth)];
            btn.restorationIdentifier =[NSString stringWithFormat:@"%d",i];
            
            //            btn.backgroundColor = [UIColor redColor];
            [btn setImage:[UIImage imageNamed:@"iconfont-tianjia"] forState:UIControlStateNormal];
            //添加点击事件
            [btn addTarget:self action:@selector(btnAdd) forControlEvents:UIControlEventTouchUpInside];
            btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
            btn.layer.borderWidth = 1;
            [self addSubview:btn];
            
        }
        self.contentSize = CGSizeMake((_arr.count + 1) * (_imageWidth + 8), _imageWidth);
        //        if(dir==VerticalDirectionb)
        //            self.contentSize = CGSizeMake(viewWidth-16, y + _imageWidth);
        //        else
        //            self.contentSize = CGSizeMake(viewWidth-16, y + _imageWidth);
        
    }
}

-(void)btnDel:action
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否要删除？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是",nil];
    UIButton *btn = (UIButton *)action;
    delTag = btn.tag - 100;
    [alert show];
    
}
-(void)btnAdd
{
    [_EditImageDelegate AddImage:self.tag];
}
-(void)imageShow:action
{
    UIButton *btn = (UIButton *)action;
    NSInteger btnTag = [btn.restorationIdentifier integerValue];
    [self CreateScrollView:btnTag btnRect:btn.frame];
    //    [self CreateScrollView:btn];
    
}
-(void)tapGestrueRecognizer:(UIGestureRecognizer *)recognizer
{
    //    UIScrollView *scroll = (UIScrollView *)[self.v.navigationController.view viewWithTag:10];
    
    //    CGFloat pageWidth = imgShowView.frame.size.width;
    //    int index = imgShowView.contentOffset.x / pageWidth;
    //    UIImageView *imgView = (UIImageView *)[imgShowView viewWithTag:20 + index];
    
    //    CGFloat scrollSizeWidth = self.contentSize.width;
    //    CGFloat _imageWidth = (viewWidth - (_column+1)*8) / _column;
    //    int y = index / _column * _imageWidth;
    //    int x = index % _column * _imageWidth;
    
    [UIView animateWithDuration:0.5 animations:^{
        //        imgView.frame = CGRectMake(self.frame.origin.x + x, self.frame.origin.y + y, 100, 100);
        scroll.alpha = 0;
    } completion:^(BOOL finished) {
        scroll.hidden = YES;
        [scroll removeFromSuperview];
    }];
}

-(void)hiddenView:action
{
    UIButton *btn = (UIButton *)action;
    //    btn.hidden = YES;
    [btn removeFromSuperview];
    UIView *background = [self.v.view viewWithTag:1];
    [background removeFromSuperview];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView  buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"是"])
    {
        NSMutableArray *array = (NSMutableArray *)self.arr;
        [array removeObjectAtIndex:delTag];
        [self.EditImageDelegate DelImage:self.tag index:delTag];
        
        [self LoadScrollView];
    }
}

-(CGRect)GetImgFrame:(CGRect)rect default:(CGSize)defaultSize
{
    float width = rect.size.width;
    float height = rect.size.height;
    float x = defaultSize.width/2 - rect.size.width/2;
    float y = defaultSize.height/2 - rect.size.height/2;
    if(width < defaultSize.width || height < defaultSize.height)
    {
        float widthBS = rect.size.width/defaultSize.width;
        
        float heightBS = rect.size.height/defaultSize.height;
        if(widthBS > heightBS)
        {
            width = defaultSize.width;
            height = rect.size.height/widthBS;
            y = defaultSize.height/2 - height/2;
            x = 0;
        }
        else if(widthBS < heightBS)
        {
            height = defaultSize.height;
            width = rect.size.width/heightBS;
            x = defaultSize.width/2 - width/2;
            y = 0;
        }
        else
        {
            width = defaultSize.width;
            height = defaultSize.height;
            x = 0; y = 0;
        }
    }
    
    return CGRectMake(x, y, width, height);
}

-(void)CreateScrollView:(NSInteger)index btnRect:(CGRect)btnrect
{
//    NSMutableArray *data = [[NSMutableArray alloc]init];
//    //    [data addObject:[UIImage imageNamed:@"bg"]];
//    if(imgArry!=nil && imgArry.count>0)
//    {
//        for (int i = 0; i<imgArry.count; i++) {
//            [data addObject: [UIImage imageWithData:imgArry[i]]];
//        }
//    }
//    else
//    {
//        for (int i = 0; i<_arr.count; i++) {
//            [data addObject: [UIImage imageWithData:_arr[i]]];
//        }
//    }
//    
//    //头尾结合的图片浏览
//    imgShowView = [[MRImgShowView alloc]
//                   initWithFrame:[[UIScreen mainScreen] bounds]
//                   withSourceData:data
//                   withIndex:index];
    
    // 解决谦让
    //    [imgShowView requireDoubleGestureRecognizer:[[_v.navigationController.view gestureRecognizers] lastObject]];
    //    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestrueRecognizer:)];
    //    [imgShowView addGestureRecognizer:tap];
    //    imgShowView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //    [_v.navigationController.view addSubview:imgShowView];
    
    scroll = [[UIScrollView alloc]init];
    //    scroll.delegate = self;
    //设置最大伸缩比例
    //    scroll.maximumZoomScale=1.5;
    //设置最小伸缩比例
    //    scroll.minimumZoomScale=0.5;
    
    //    scroll.showsHorizontalScrollIndicator = NO;
    scroll.frame = [UIScreen mainScreen].bounds;//CGRectMake(0, 0, [UIScreen mainScreen].bounds, self.v.view.frame.size.height);
    [self CreateImages:index];
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.showsVerticalScrollIndicator = NO;
    scroll.pagingEnabled = YES;
    scroll.delegate = self;
    CGSize s = CGSizeMake(self.arr.count*viewWidth, self.v.view.frame.size.height);
    
    scroll.contentSize=s;
    
    //定位到scroll的指定坐标
    CGPoint point = CGPointMake(index*viewWidth, 0);
    scroll.contentOffset = point;
    scroll.tag = 10;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestrueRecognizer:)];
    [scroll addGestureRecognizer:tap];
    [self.v.navigationController.view addSubview:scroll];
    scroll.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIImageView *imgShow = (UIImageView *)[self.v.navigationController.view viewWithTag:20 + index];
    
    scroll.alpha = 0;
    
    CGRect showRect = imgShow.frame;
    //    imgShow.frame = CGRectMake(self.frame.origin.x + btnrect.origin.x, self.frame.origin.y + btnrect.origin.y, btnrect.size.width, btnrect.size.height);
    imgShow.frame = CGRectMake((self.v.view.frame.size.width - btnrect.size.width)/2,(self.v.view.frame.size.height - btnrect.size.height)/2, btnrect.size.width, btnrect.size.height);
    
    [UIView animateWithDuration:0.5 animations:^{
        imgShow.frame = showRect;
        scroll.alpha = 1;
    } completion:^(BOOL finished) {
        //        [imgShow removeFromSuperview];
    }];
}

-(void)CreateImages:(NSInteger)index
{
    selImgIndex = index;
    
    NSMutableArray *datas = [[NSMutableArray alloc]init];
    //    [data addObject:[UIImage imageNamed:@"bg"]];
    if(imgArry!=nil && imgArry.count>0)
    {
        for (int i = 0; i<imgArry.count; i++) {
            [datas addObject: [UIImage imageWithData:imgArry[i]]];
        }
    }
    else
    {
        for (int i = 0; i<_arr.count; i++) {
            [datas addObject: [UIImage imageWithData:_arr[i]]];
        }
    }
    
    for (NSInteger i = 0; i<datas.count; i++) {
//        NSData *data = datas[i];
        
        //        UIView *backgroundView = [[UIView alloc]init];
        //        backgroundView.frame = CGRectMake(i*viewWidth, 0, viewWidth, scroll.frame.size.height);
        //图片显示方式
        //        imgView.contentMode = UIViewContentModeCenter;
        //        imgView.frame = [self GetImgFrame:imgView.frame default:[[UIScreen mainScreen]bounds].size];
        
        //        [backgroundView addSubview:imgView];
        //
        //        [scroll addSubview:backgroundView];
        if(index == i)
        {
            //            indexImg.contentMode = UIViewContentModeScaleAspectFit;
            //            indexImg.frame = CGRectMake(0, 0, viewWidth, scroll.frame.size.height);
            //            indexImg = [[UIImageView alloc]initWithImage:[UIImage imageWithData:data]];
            
            indexImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, viewWidth, scroll.frame.size.height)];
            indexImg.contentMode = UIViewContentModeScaleAspectFit;
            [indexImg setImage:datas[i]];
            indexImg.contentMode = UIViewContentModeScaleAspectFit;
            
            indexImg.tag = 20 + i;
            UIScrollView *sv = [[UIScrollView alloc]initWithFrame:CGRectMake(i*viewWidth, 0, viewWidth, scroll.frame.size.height)];
            sv.delegate = self;
            //设置最大伸缩比例
            sv.maximumZoomScale=2;
            //设置最小伸缩比例
            sv.minimumZoomScale=1;
            sv.showsHorizontalScrollIndicator = NO;
            sv.showsVerticalScrollIndicator = NO;
            [sv addSubview:indexImg];
            [scroll addSubview:sv];
        }
        else
        {
            UIImageView *imgView = [[UIImageView alloc]initWithImage:datas[i]];
            
            imgView.tag = 20 + i;
            imgView.contentMode = UIViewContentModeScaleAspectFit;
            imgView.frame = CGRectMake(i*viewWidth, 0, viewWidth, scroll.frame.size.height);
            [scroll addSubview:imgView];
        }
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    if(scrollView != scroll)
        return indexImg;
    return nil;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView == scroll)
    {
        CGFloat viewX = scrollView.contentOffset.x;
        if(viewX/viewWidth != selImgIndex)
        {
            [scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            selImgIndex = viewX/viewWidth;
            [self CreateImages:selImgIndex];
        }
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

-(void)finishImgData:(NSData *)data
{
    [imgArry addObject:data];
}

@end
