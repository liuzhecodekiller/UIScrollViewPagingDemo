//
//  KGRootViewController.m
//  UIScrollViewPagingDemo
//
//  Created by KG on 15/6/18.
//  Copyright (c) 2015年 KG. All rights reserved.
//

#import "KGRootViewController.h"

@interface KGRootViewController ()<UIScrollViewDelegate>
{
    UIScrollView * _scrollView;
    UIPageControl * _pageControl;//页码指示器
}
@end

@implementation KGRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)prepareScrollView
{
    //在准备滚动视图时,需要将这个属性关掉
    //将偏移量复位
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, 320, 416)];
    _scrollView.bounces = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    //因为要去翻页,所以将翻页属性打开
    _scrollView.pagingEnabled = YES;
    
    //加图片
    for (int i = 0; i<6; i++) {
        NSString * name = [NSString stringWithFormat:@"美女2%d.jpg",i];
        UIImage * image = [UIImage imageNamed:name];
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*320, 0, 320, 416)];
        imageView.image = image;
        [_scrollView addSubview:imageView];
    }
    //设置滚动范围
    _scrollView.contentSize = CGSizeMake(_scrollView.subviews.count * 320, 416);
    
    
    
    //设置代理
    _scrollView.delegate = self;
    
    //设置缩放倍数
    _scrollView.maximumZoomScale = 3;
    _scrollView.minimumZoomScale = 1;
    
    
    
    //加到视图上
    [self.view addSubview:_scrollView];
    
}
-(void)preparePageControl
{
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 460, 320, 20)];
    //设置有多少页
    _pageControl.numberOfPages = _scrollView.subviews.count;
    //设置非当前页颜色
    _pageControl.pageIndicatorTintColor = [UIColor blueColor];
    //设置当前页颜色
    _pageControl.currentPageIndicatorTintColor = [UIColor yellowColor];
    //页码指示器是可以去加一个事件的,但一般在使用时,并不会去加,因为太细太难点
    [_pageControl addTarget:self action:@selector(pageControlAction:) forControlEvents:UIControlEventValueChanged];
    //如果不想用,可以禁用交互
    _pageControl.userInteractionEnabled = NO;
    
    [self.view addSubview:_pageControl];
}
//页码指示器的响应方法
-(void)pageControlAction:(UIPageControl *)pctl
{
    //显示当前页码
    NSLog(@"%ld",pctl.currentPage);
    //通过当前页来设置滚动视图的偏移量
    _scrollView.contentOffset = CGPointMake(pctl.currentPage*320, 0);
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //将要开始拖拽时调用
    NSLog(@"scrollViewWillBeginDragging");
}
//重要的一个方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //在滚动时调用
    NSLog(@"scrollViewDidScroll %@",NSStringFromCGPoint(scrollView.contentOffset));
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    //将要结束拖拽时,调用
    NSLog(@"scrollViewWillEndDragging");
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //结束拖拽时调用
    NSLog(@"scrollViewDidEndDragging");
}
//
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    //这个方法,是在拖拽结束后,开始加束时调用
    NSLog(@"scrollViewWillBeginDecelerating");
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //这个方法是在加速结束后调用
    NSLog(@"scrollViewDidEndDecelerating");
    
    _pageControl.currentPage = scrollView.contentOffset.x / 320;
    
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x /320;
    return [scrollView.subviews objectAtIndex:index];
    //上面和下面的方法,两者可选一种实现
    return [scrollView.subviews objectAtIndex:_pageControl.currentPage];
}



#pragma mark - ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self prepareScrollView];
    [self preparePageControl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
