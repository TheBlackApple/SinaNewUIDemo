//
//  LYHMainViewController.m
//  SinaNewsUI
//
//  Created by Charles Leo on 14-8-7.
//  Copyright (c) 2014年 Charles Leo. All rights reserved.
//

#import "LYHMainViewController.h"
#import "LYHSliderViewController.h"
#import "LYHSubViewController.h"
#import "LYHMainGestureRecognizerViewController.h"

#define MENU_HEIGHT 25
#define MENU_BUTTON_WIDTH  60

@interface LYHMainViewController ()<UIScrollViewDelegate>
{
    UIView * navView;
    UIView * topNaviView;
    UIScrollView * _scrollView;
    UIScrollView * navScrollView;
    UIView * navBgView;
    float startPoint;
    UIView * selectTabView;
}
@end

@implementation LYHMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIView * statusBarView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
    if (isIos7 >= 7 && __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1)
    {
        statusBarView.frame = CGRectMake(statusBarView.frame.origin.x, statusBarView.frame.origin.y, statusBarView.frame.size.width, 20.0f);
        statusBarView.backgroundColor = [UIColor clearColor];
        ((UIImageView *)statusBarView).backgroundColor = RGBA(159, 5, 13, 1);
        [self.view addSubview:statusBarView];
    }
    
    navView = [[UIImageView alloc]initWithFrame:CGRectMake(0, StatusbarSize, self.view.frame.size.width, 44.0f)];
    ((UIImageView *)navView).backgroundColor = RGBA(159, 5, 13, 1);
    [self.view insertSubview:navView belowSubview:statusBarView];
    navView.userInteractionEnabled = YES;
    
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((navView.frame.size.width - 200)/2, (navView.frame.size.height)/2, 200, 40)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:18.0f];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    [navView addSubview:titleLabel];
    
    UIButton * btnLeft = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnLeft.frame = CGRectMake(10, 2, 40, 40);
    [btnLeft setTitle:@"左" forState:UIControlStateNormal];
    [btnLeft addTarget:self action:@selector(leftAction:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:btnLeft];
    
    
    UIButton * btnRight = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnRight.frame = CGRectMake(navView.frame.size.width - 50, 2, 40, 40);
    [btnRight setTitle:@"右" forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:btnRight];
    
    topNaviView = [[UIView alloc]initWithFrame:CGRectMake(0, navView.frame.size.height + navView.frame.origin.y, self.view.frame.size.width, MENU_HEIGHT)];
    [self.view addSubview:topNaviView];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, topNaviView.frame.origin.y+topNaviView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - topNaviView.frame.origin.y - topNaviView.frame.size.height)];
    [_scrollView setPagingEnabled:YES];
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    [self.view insertSubview:_scrollView belowSubview:navView];
    _scrollView.delegate = self;
    [_scrollView.panGestureRecognizer addTarget:self action:@selector(scrollHandlePan:)];
    
    selectTabView = [[UIView alloc]initWithFrame:CGRectMake(0, _scrollView.frame.origin.y - _scrollView.frame.size.height, _scrollView.frame.size.width, _scrollView.frame.size.height)];
    selectTabView.backgroundColor = RGBA(236.f, 236.f, 236.f, 1);
    selectTabView.hidden = YES;
    [self.view insertSubview:selectTabView belowSubview:navView];
    [self createTabView];
}

- (void)createTabView
{
    float btnWidth = 30;
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(topNaviView.frame.size.width - btnWidth, 0, btnWidth, MENU_HEIGHT)];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn setTitle:@"+" forState:UIControlStateNormal];
    [topNaviView addSubview:btn];
    [btn addTarget:self action:@selector(showSelectView:) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray * arrayTab = @[@"测试1",@"测试2",@"测试3",@"测试4",@"测试5",@"测试6",@"测试7",@"测试8",@"测试9",@"测试10",@"测试11"];
    navScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, selectTabView.viewForBaselineLayout.frame.size.width - btnWidth, MENU_HEIGHT)];
    navScrollView.showsHorizontalScrollIndicator = NO;
    for (int i=0; i<arrayTab.count; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(MENU_BUTTON_WIDTH * i, 0, MENU_BUTTON_WIDTH, MENU_HEIGHT);
        [button setTitle:[arrayTab objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.tag = i+1;
        [button addTarget:self action:@selector(actionbtn:) forControlEvents:UIControlEventTouchUpInside];
        [navScrollView addSubview:button];
    }
    [navScrollView setContentSize:CGSizeMake(MENU_BUTTON_WIDTH * arrayTab.count, MENU_HEIGHT)];
    [topNaviView addSubview:navScrollView];
    navBgView = [[UIView alloc]initWithFrame:CGRectMake(0, MENU_HEIGHT - 2, MENU_BUTTON_WIDTH, 2)];
    navBgView.backgroundColor = [UIColor redColor];
    [navScrollView addSubview:navBgView];
    
    [self addViewPage:navScrollView count:arrayTab.count frame:CGRectZero];
}

- (void)addViewPage:(UIScrollView *)scroll count:(NSInteger)pageCount frame:(CGRect)frame
{
    for (int i=0; i<pageCount; i++) {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(_scrollView.frame.size.width * i, 0, _scrollView.frame.size.width, scroll.frame.size.height)];
        view.tag = i+1;
        UILabel * signalLabel = [[UILabel alloc]initWithFrame:CGRectMake(selectTabView.viewForBaselineLayout.center.x - 80, self.view.center.y - 130, 160, 90)];
        signalLabel.text = [NSString stringWithFormat:@"%d",(int)view.tag];
        signalLabel.textAlignment = NSTextAlignmentCenter;
        signalLabel.contentMode = UIViewContentModeScaleAspectFill;
        signalLabel.backgroundColor = [UIColor clearColor];
        signalLabel.textColor = [UIColor blackColor];
        signalLabel.font = [UIFont systemFontOfSize:20.0f];
        [view addSubview:signalLabel];
        signalLabel.userInteractionEnabled = YES;
        signalLabel.layer.borderWidth = 1;
        signalLabel.layer.borderColor = [UIColor blueColor].CGColor;
        UITapGestureRecognizer * singleTapRecognizer = [[UITapGestureRecognizer alloc]init];
        singleTapRecognizer.numberOfTapsRequired = 1;
        [singleTapRecognizer addTarget:self action:@selector(singleTapAction:)];
        [signalLabel addGestureRecognizer:singleTapRecognizer];
        [_scrollView addSubview:view];
    }
    _scrollView.contentSize = CGSizeMake(scroll.frame.size.width * pageCount, _scrollView.frame.size.height);
}

- (void)changeView:(float)x
{
    float offset = x * (MENU_BUTTON_WIDTH / self.view.frame.size.width);
    navBgView.frame = CGRectMake(offset, navBgView.frame.origin.y, navBgView.frame.size.width, navBgView.frame.size.height);
}
- (void)actionbtn:(UIButton *)sender
{
    [_scrollView scrollRectToVisible:CGRectMake(_scrollView.frame.size.width * (sender.tag - 1), _scrollView.frame.origin.y, _scrollView.frame.size.width, _scrollView.frame.size.height) animated:YES];
    float x = _scrollView.frame.size.width * (sender.tag - 1) * (MENU_BUTTON_WIDTH/self.view.frame.size.width)-MENU_BUTTON_WIDTH;
    [navScrollView scrollRectToVisible:CGRectMake(x, 0, navScrollView.frame.size.width, navScrollView.frame.size.height) animated:YES];
    
}
- (void)singleTapAction:(UITapGestureRecognizer *)tapGesture
{
    CGPoint point = [tapGesture locationInView:_scrollView];
    int t = point.x / _scrollView.frame.size.width + 1;
    LYHSubViewController * subView = [[LYHSubViewController alloc]initWithFrame:[UIScreen mainScreen].bounds andSignal:@""];
    [[LYHMainGestureRecognizerViewController getMainViewController]addMainViewController:subView];
    subView.szSignal = [NSString stringWithFormat:@"%d -- %ld",t,subView.view.tag];
}
- (void)leftAction:(UIButton *)sender
{
    NSLog(@"leftAction");
    if ([selectTabView isHidden] == NO) {
        [self showSelectView:sender];
        return;
    }
    [((LYHSliderViewController *)[[[self.view superview]superview]nextResponder]) showLeftViewController];
}

- (void)rightAction:(UIButton *)sender
{
    NSLog(@"rightAction");

    if ([selectTabView isHidden] == NO) {
        [self showSelectView:sender];
        return;
    }
    [((LYHSliderViewController *)[[[self.view superview]superview]nextResponder]) showRightViewController];
}
- (void)showSelectView:(UIButton *)sender
{
    if ([selectTabView isHidden] == YES) {
        [selectTabView setHidden: NO];
        [UIView animateWithDuration:0.6 animations:^{
            selectTabView.frame = CGRectMake(0, _scrollView.frame.origin.y, _scrollView.frame.size.width, _scrollView.frame.size.height);
        }];
    }
    else
    {
        [UIView animateWithDuration:0.6 animations:^{
        
            [selectTabView setFrame:CGRectMake(0, _scrollView.frame.origin.y - _scrollView.frame.size.height, _scrollView.frame.size.width, _scrollView.frame.size.height)];
        } completion:^(BOOL finished) {
            selectTabView.hidden = YES;
        }];
    }
}
- (void)scrollHandlePan:(UIPanGestureRecognizer *)panGesture
{
    BOOL isPaning = NO;
    if (_scrollView.contentOffset.x < 0) {
        isPaning = YES;
    }
    else if(_scrollView.contentOffset.x > (_scrollView.contentSize.width - _scrollView.frame.size.width))
    {
        isPaning = YES;
    }
    if (isPaning) {
        [((LYHSliderViewController *)[[[self.view superview]superview]nextResponder])moveViewWithGesture:panGesture];
    }
}
#pragma mark - UIScrollViewDelegate的代理方法
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    startPoint = scrollView.contentOffset.x;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self changeView:scrollView.contentOffset.x];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float x = scrollView.contentOffset.x * (MENU_BUTTON_WIDTH / self.view.frame.size.width) - MENU_BUTTON_WIDTH;
    [navScrollView scrollRectToVisible:CGRectMake(x, 0, navScrollView.frame.size.width, navScrollView.frame.size.height) animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
