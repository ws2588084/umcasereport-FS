//
//  ImagesFroTable.m
//  图片缩略图
//
//  Created by EightLong on 14-9-2.
//
//

#import "ImagesFroTable.h"

@implementation ImagesFroTable

- (id)initWithFrame:(CGRect)frame
{
    self.dataSource = self;
    self.delegate = self;
    self = [super initWithFrame:frame];
//    NSMutableArray *list =(NSMutableArray *)self.arr;
    self.arr = [[NSMutableArray alloc]init];
    if (self) {
        // Initialization code
    }
    return self;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    int ys = self.arr.count % 3;
    if(ys == 0)
    {
        return self.arr.count / 3;
    }
    else
    {
        return self.arr.count / 3 + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellName = [NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    
    for (NSInteger i = 0; i < 3; i++) {
        int countIndex = (int)(indexPath.row * 3 + i);
        if(self.arr.count <= countIndex)
        {
            if(_IsAdd)
            {
                UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i*100+3, 0, 100, 100 )];
                [btn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                btn.backgroundColor = [UIColor redColor];
                [cell.contentView addSubview:btn];
            }
            break;
        }
        UIImage *img = [[UIImage alloc]initWithData:self.arr[countIndex]];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i*100+3, 0, 100, 100 )];
        
        if(btn.frame.size.width < img.size.width || btn.frame.size.height < img.size.height)
        {
            
            float widthBS = img.size.width/btn.frame.size.width;
            float heightBS = img.size.height/btn.frame.size.height;
            float bs = widthBS > heightBS ? heightBS : widthBS;
            img = [[UIImage alloc]initWithData:self.arr[countIndex] scale:bs];
        }
        
        [btn setImage:img forState:UIControlStateNormal];
        btn.imageView.contentMode = UIViewContentModeCenter;
        
        [btn addTarget:self action:@selector(imageShow:) forControlEvents:UIControlEventTouchUpInside];
        btn.restorationIdentifier =[NSString stringWithFormat:@"%d",countIndex];
        
        [cell.contentView addSubview:btn];
        UIButton *btnDel = [[UIButton alloc]initWithFrame:CGRectMake(i*100+3, 0, 26, 26)];
        [btnDel setBackgroundImage:[UIImage imageNamed:@"btn_del_default"] forState:UIControlStateNormal];
        btnDel.restorationIdentifier = [NSString stringWithFormat:@"%d",countIndex];
        [btnDel addTarget:self action:@selector(btnDel:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btnDel];
    }
    cell.frame = CGRectMake(0, 0, 320, 105);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the cell...
    
    return cell;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView.tag == 10)
    {
        //scrollview移动完之后需要做的处理
    }
}

-(void)btnDel:action
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否要删除？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是",nil];
    UIButton *btn = (UIButton *)action;
    delTag = [btn.restorationIdentifier integerValue];
    [alert show];
    
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
    UIScrollView *scroll = (UIScrollView *)[self.v viewWithTag:10];
    CGFloat pageWidth = scroll.frame.size.width;
    int index = scroll.contentOffset.x / pageWidth;
    UIImageView *imgView = (UIImageView *)[scroll viewWithTag:20 + index];
    
    int y = index / 3 * 100;
    int x = index % 3 * 100;
    
    [UIView animateWithDuration:0.5 animations:^{
        imgView.frame = CGRectMake(self.frame.origin.x + x, self.frame.origin.y + y, 100, 100);
        scroll.alpha = 0;
    } completion:^(BOOL finished) {
        scroll.hidden = YES;
        [scroll removeFromSuperview];
    }];
}

#pragma mark 使用button弹出uiview进行显示大图
-(void)imageShow1:action
{
    UIButton *btn = (UIButton *)action;
    NSInteger btnTag = [btn.restorationIdentifier integerValue];
    
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.v.frame.size.width,self.v.frame.size.height)];
    backgroundView.tag = 1;
    backgroundView.backgroundColor = [UIColor lightGrayColor];
    
    NSData *data = self.arr[btnTag];
    UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageWithData:data]];
    
    float width = img.frame.size.width;
    float height = img.frame.size.height;
    if(width > backgroundView.frame.size.width || height > backgroundView.frame.size.height)
    {
        float widthBS = img.frame.size.width/backgroundView.frame.size.width;
        
        float heightBS = img.frame.size.height/backgroundView.frame.size.height;
        if(widthBS > heightBS)
        {
            width = self.v.frame.size.width;
            height = img.frame.size.height/widthBS;
        }
        else
        {
            
            height = self.v.frame.size.height;
            width = img.frame.size.width/heightBS;
        }
    }
    
    img.frame = CGRectMake(0, 0, width, height);
    img.userInteractionEnabled = YES;
    img.center = backgroundView.center;
    [backgroundView addSubview:img];
    
    [self.v addSubview:backgroundView];
    UIButton *btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
    btnClose.frame = CGRectMake(0, 0, self.v.frame.size.width, self.v.frame.size.height);
    [btnClose addTarget:self action:@selector(hiddenView:) forControlEvents:UIControlEventTouchUpInside];
    [self.v addSubview:btnClose];
    
}
-(void)hiddenView:action
{
    UIButton *btn = (UIButton *)action;
//    btn.hidden = YES;
    [btn removeFromSuperview];
    UIView *background = [self.v viewWithTag:1];
    [background removeFromSuperview];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return cell.frame.size.height;
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView  buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"是"])
    {
        NSMutableArray *array = (NSMutableArray *)self.arr;
        [array removeObjectAtIndex:delTag];
        [self tableViewLoad];
    }
}
-(void)tableViewLoad
{
    [self reloadData];
}

-(void)CreateScrollView:(UIButton *)btn
{
    UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, self.v.frame.size.height)];
    NSInteger index = [btn.restorationIdentifier intValue];
    
    UIImageView *imgView = [[UIImageView alloc]initWithImage:[[UIImage alloc]initWithData:self.arr[index]]];
    
    imgView.frame = [self GetImgFrame:imgView.frame default:self.v.frame.size];
    
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, self.v.frame.size.height)];
    int count = 0;
    
    if(index - 1 >= 0)
    {
        UIImageView *firstImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"test1"]];
        UIView *firstView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, self.v.frame.size.height)];
        
        firstImg.frame = [self GetImgFrame:firstImg.frame default:self.v.frame.size];
        [firstView addSubview:firstImg];
        [scroll addSubview:firstView];
        backgroundView.frame = CGRectMake(320, 0, 320, self.v.frame.size.height);
        count++;
    }
    if(index + 1 < self.arr.count)
    {
        UIImageView *lastImg = [[UIImageView alloc]initWithImage:[UIImage imageWithData:self.arr[index + 1]]];
        UIView *lastView = [[UIView alloc]initWithFrame:CGRectMake((count + 1) * 320, 0, 320, self.v.frame.size.height)];
        lastImg.frame = [self GetImgFrame:lastImg.frame default:self.v.frame.size];
        [lastView addSubview:lastImg];
        [scroll addSubview:lastView];
        count++;
    }
    
    scroll.pagingEnabled = YES;
    scroll.delegate = self;
    
    CGSize s = CGSizeMake((count + 1) * 320, self.v.frame.size.height);
    scroll.contentSize=s;
    
    //定位到scroll的指定坐标
    CGPoint point = CGPointMake(backgroundView.frame.origin.x, 0);
    scroll.contentOffset = point;
    scroll.tag = 10;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestrueRecognizer:)];
    [scroll addGestureRecognizer:tap];
    
    [backgroundView addSubview:imgView];
    [scroll addSubview:backgroundView];
    [self.v addSubview:scroll];
    scroll.alpha = 0;
    scroll.backgroundColor = [UIColor lightGrayColor];
    [UIView animateWithDuration:0.5 animations:^{
        scroll.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

-(CGRect)GetImgFrame:(CGRect)rect default:(CGSize)defaultSize
{
    float width = rect.size.width;
    float height = rect.size.height;
    float x = defaultSize.width/2 - rect.size.width/2;
    float y = defaultSize.height/2 - rect.size.height/2;
    if(width > defaultSize.width || height > defaultSize.height)
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
    UIScrollView *scroll = [[UIScrollView alloc]init];
//    scroll.showsHorizontalScrollIndicator = NO;
    scroll.frame = CGRectMake(0, 0, 320, self.v.frame.size.height);
    for (NSInteger i = 0; i<self.arr.count; i++) {
        NSData *data = self.arr[i];
        UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageWithData:data]];
        
        UIView *backgroundView = [[UIView alloc]init];
        backgroundView.frame = CGRectMake(i*self.v.frame.size.width, 0, self.v.frame.size.width, scroll.frame.size.height);
        //图片显示方式
        //        imgView.contentMode = UIViewContentModeCenter;
        imgView.tag = 20 + i;
        imgView.frame = [self GetImgFrame:imgView.frame default:self.v.frame.size];
        
        [backgroundView addSubview:imgView];
        
        [scroll addSubview:backgroundView];
    }
    scroll.pagingEnabled = YES;
    scroll.delegate = self;
    CGSize s = CGSizeMake(self.arr.count*320, self.v.frame.size.height);
    
    scroll.contentSize=s;
    
    //定位到scroll的指定坐标
    CGPoint point = CGPointMake(index*320, 0);
    scroll.contentOffset = point;
    scroll.tag = 10;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestrueRecognizer:)];
    [scroll addGestureRecognizer:tap];
    [self.v addSubview:scroll];
    scroll.backgroundColor = [UIColor lightGrayColor];
    
    UIImageView *imgShow = (UIImageView *)[self.v viewWithTag:20 + index];
    
    scroll.alpha = 0;
    
    CGRect showRect = imgShow.frame;
    imgShow.frame = CGRectMake(self.frame.origin.x + btnrect.origin.x, self.frame.origin.y + btnrect.origin.y, btnrect.size.width, btnrect.size.height);
    [UIView animateWithDuration:0.5 animations:^{
        imgShow.frame = showRect;
        scroll.alpha = 1;
    } completion:^(BOOL finished) {
//        [imgShow removeFromSuperview];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
