//
//  LYHSliderViewController.m
//  SinaNewsUI
//
//  Created by Charles Leo on 14-8-7.
//  Copyright (c) 2014年 Charles Leo. All rights reserved.
//

#import "LYHSliderViewController.h"
#import <sys/utsname.h>
typedef NS_ENUM(NSInteger, RMoveDirection)
{
    RMoveDirectionLeft = 0,
    RMoveDirectionRight
};

@interface LYHSliderViewController ()<UIGestureRecognizerDelegate>
{
    UIView * mainContentView;
    UIView * leftSideView;
    UIView * rightSideView;
    NSMutableDictionary * controllerDict;
    UITapGestureRecognizer * tapGestureRecognizer;
    UIPanGestureRecognizer * panGestureRecognizer;
    
    BOOL showingLeft;
    BOOL showingRight;
}
@end

@implementation LYHSliderViewController
- (void)dealloc
{
    #if __has_feature(objc_arc)
    mainContentView = nil;
    leftSideView = nil;
    rightSideView = nil;
    controllerDict = nil;
    tapGestureRecognizer = nil;
    panGestureRecognizer = nil;
    self.mLeftViewController = nil;
    self.mRightViewController = nil;
    self.mMainViewController = nil;
    #else
    
    [super dealloc];
    #endif
}
+ (LYHSliderViewController *)sharedSliderController
{
    static LYHSliderViewController * sharedSliderView;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        sharedSliderView = [[self alloc]init];
    });
    return sharedSliderView;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super initWithCoder:decoder]) {
        self.LeftContentOffset = 160;
        self.RightContentOffset = 160;
        self.LeftContentScale = 0.85;
        self.RightContentScale = 0.85;
        self.LeftJudgeOffset = 100;
        self.RightJudgeOffset = 100;
        self.LeftOpenDuration = 0.4;
        self.RightOpenDuration = 0.4;
        self.LeftCloseDuration = 0.3;
        self.RightCloseDuration = 0.3;
        self.canShowLeft = YES;
        self.canShowRight = YES;
    }
    return self;
}

- (id)init
{
    if (self = [super init]) {
        self.LeftContentOffset = 160;
        self.RightContentOffset = 160;
        self.LeftContentScale = 0.85;
        self.RightContentScale = 0.85;
        self.LeftJudgeOffset = 100;
        self.RightJudgeOffset = 100;
        self.LeftOpenDuration = 0.4;
        self.RightOpenDuration = 0.4;
        self.LeftCloseDuration = 0.3;
        self.RightCloseDuration = 0.3;
        self.canShowLeft = YES;
        self.canShowRight = YES;
    }
    return self;
}

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
    self.navigationController.navigationBarHidden = YES;
    controllerDict = [[NSMutableDictionary alloc]init];
    [self initSubViews];
    
    [self initChildControllers:self.mLeftViewController rightVC:self.mRightViewController];
    
    [self showContentControllerWithModel:self.mMainViewController !=Nil?NSStringFromClass([self.mMainViewController class]):@"LYHMainViewController"];
    if ((self.wantsFullScreenLayout = self.mMainViewController.wantsFullScreenLayout)) {
        rightSideView.frame = [UIScreen mainScreen].bounds;
        leftSideView.frame = [UIScreen mainScreen].bounds;
        mainContentView.frame = [UIScreen mainScreen].bounds;
    }
    tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeSideBar)];
    tapGestureRecognizer.delegate = self;
    [mainContentView addGestureRecognizer:tapGestureRecognizer];
    tapGestureRecognizer.enabled = NO;
    
    panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(moveViewWithGesture:)];
    [mainContentView addGestureRecognizer:panGestureRecognizer];
}
#pragma mark - 初始化方法
- (void)initSubViews
{
    rightSideView = [[UIView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:rightSideView];
    
    leftSideView = [[UIView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:leftSideView];
    
    mainContentView = [[UIView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:mainContentView];
}

- (void)initChildControllers:(UIViewController *)leftVC rightVC:(UIViewController *)rightVC
{
    if (self.canShowRight && rightVC!= nil) {
        [self addChildViewController:rightVC];
        rightVC.view.frame = CGRectMake(0, 0, rightVC.view.frame.size.width, rightVC.view.frame.size.height);
        [rightSideView addSubview:rightVC.view];
    }
    if (self.canShowLeft && leftVC != nil) {
        [self addChildViewController:leftVC];
        leftVC.view.frame = CGRectMake(0, 0, leftVC.view.frame.size.width, leftVC.view.frame.size.height);
        [leftSideView addSubview:leftVC.view];
    }
}
#pragma mark - Actions
- (void)showContentControllerWithModel:(NSString *)className
{
    [self closeSideBar];
    UIViewController * controller = controllerDict[className];
    if (!controller) {
        Class c = NSClassFromString(className);
#if __has_feature(objc_arc)
        
        controller = [[c alloc]init];
#else
        controller = [[[c alloc]init]autorelease];
#endif
        [controllerDict setObject:controller forKey:className];
    }
    if (mainContentView.subviews.count > 0) {
        UIView * view = [mainContentView.subviews firstObject];
        [view removeFromSuperview];
    }
    
    controller.view.frame = mainContentView.frame;
    [mainContentView addSubview:controller.view];
    self.mMainViewController = controller;
}
- (void)showLeftViewController
{
    if (showingLeft) {
        [self closeSideBar];
        return;
    }
    if (!self.canShowLeft || self.mLeftViewController == nil) {
        return;
    }
    CGAffineTransform conT = [self transformWithDirection:RMoveDirectionRight];
    [self.view sendSubviewToBack:rightSideView];
    [self configureViewShadowWithDirection:RMoveDirectionRight];
    [UIView animateWithDuration:self.LeftOpenDuration animations:^{
        mainContentView.transform = conT;
    }
    completion:^(BOOL finished) {
        tapGestureRecognizer.enabled = YES;
        showingLeft = YES;
        self.mMainViewController.view.userInteractionEnabled = NO;
    }];
}
- (void)showRightViewController
{
    if (showingRight) {
        [self closeSideBar];
        return;
    }
    if (!self.canShowRight || self.mRightViewController == nil) {
        return;
    }
    CGAffineTransform conT = [self transformWithDirection:RMoveDirectionLeft];
    [self.view sendSubviewToBack:leftSideView];
    [self configureViewShadowWithDirection:RMoveDirectionLeft];
    [UIView animateWithDuration:self.RightOpenDuration animations:^{
        mainContentView.transform = conT;
    }
    completion:^(BOOL finished) {
        tapGestureRecognizer.enabled = YES;
        showingRight = YES;
        self.mMainViewController.view.userInteractionEnabled = NO;
    }];
}
- (void)closeSideBar
{
    CGAffineTransform trans = CGAffineTransformIdentity;
    [UIView animateWithDuration:mainContentView.transform.tx == self.LeftContentOffset?self.LeftCloseDuration:self.RightCloseDuration  animations:^{
        mainContentView.transform = trans;
    }
    completion:^(BOOL finished) {
        tapGestureRecognizer.enabled = NO;
        showingRight = NO;
        showingLeft = NO;
        self.mMainViewController.view.userInteractionEnabled = YES;
    }];
}
- (void)moveViewWithGesture:(UIPanGestureRecognizer *)panGesture
{
    static CGFloat currentTranslateX;
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        currentTranslateX = mainContentView.transform.tx;
    }
    if (panGesture.state == UIGestureRecognizerStateChanged) {
        CGFloat transX = [panGesture translationInView:mainContentView].x;
        transX = transX + currentTranslateX;
        CGFloat sca = 0;
        if (transX > 0) {
            if (!self.canShowLeft || self.mLeftViewController == nil) {
                return;
            }
            [self.view sendSubviewToBack:rightSideView];
            [self configureViewShadowWithDirection:RMoveDirectionRight];
            
            if (mainContentView.frame.origin.x < self.LeftContentOffset) {
                sca = 1 - (mainContentView.frame.origin.x /self.LeftContentOffset) * (1-self.LeftContentScale);
            }
            else
            {
                sca = self.LeftContentScale;
            }
        }
        else
        {
            if (!self.canShowRight || self.mRightViewController == nil) {
                return;
            }
            [self.view sendSubviewToBack:leftSideView];
            [self configureViewShadowWithDirection:RMoveDirectionLeft];
            
            if (mainContentView.frame.origin.x > -self.RightContentOffset) {
                sca = 1 - (-mainContentView.frame.origin.x / self.RightContentOffset) * (1- self.RightContentScale);
            }
            else
            {
                sca = self.RightContentScale;
            }
        }
        CGAffineTransform transS = CGAffineTransformMakeScale(sca, sca);
        CGAffineTransform transT = CGAffineTransformMakeTranslation(transX, 0);
        CGAffineTransform conT = CGAffineTransformConcat(transT, transS);
        mainContentView.transform = conT;
    }
    else if (panGesture.state == UIGestureRecognizerStateEnded)
    {
        CGFloat panX = [panGesture translationInView:mainContentView].x;
        CGFloat finalX = currentTranslateX + panX;
        if (finalX > self.LeftJudgeOffset) {
            if (!self.canShowLeft || self.mLeftViewController) {
                return;
            }
            CGAffineTransform conT = [self transformWithDirection:RMoveDirectionRight];
            [UIView beginAnimations:nil context:nil];
            mainContentView.transform = conT;
            [UIView commitAnimations];
            showingLeft = YES;
            self.mMainViewController.view.userInteractionEnabled = NO;
            tapGestureRecognizer.enabled = YES;
            return;
        }
        if (finalX < -self.RightJudgeOffset) {
            if (!self.canShowRight || self.mRightViewController == nil) {
                return;
            }
            CGAffineTransform conT = [self transformWithDirection:RMoveDirectionLeft];
            [UIView beginAnimations:nil context:nil];
            mainContentView.transform = conT;
            [UIView commitAnimations];
            showingRight = YES;
            self.mMainViewController.view.userInteractionEnabled = NO;
            tapGestureRecognizer.enabled = YES;
            return;
        }
        else
        {
            CGAffineTransform oriT = CGAffineTransformIdentity;
            [UIView beginAnimations:nil context:nil];
            mainContentView.transform = oriT;
            [UIView commitAnimations];
            showingRight = NO;
            showingLeft = NO;
            self.mMainViewController.view.userInteractionEnabled = YES;
            tapGestureRecognizer.enabled = NO;
        }
    }
}
- (CGAffineTransform)transformWithDirection:(RMoveDirection)direction
{
    CGFloat translateX = 0;
    CGFloat transcale = 0;
    switch (direction) {
        case RMoveDirectionLeft:
            translateX = -self.RightContentOffset;
            transcale = self.RightContentScale;
            break;
            case RMoveDirectionRight:
            translateX = self.LeftContentOffset;
            transcale = self.LeftContentScale;
            break;
        default:
            break;
    }
    CGAffineTransform transT = CGAffineTransformMakeTranslation(translateX, 0);
    CGAffineTransform scaleT = CGAffineTransformMakeScale(transcale, transcale);
    CGAffineTransform conT = CGAffineTransformConcat(transT, scaleT);
    return conT;
}
- (NSString *)deviceWithNumString
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString * deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    @try {
        return [deviceString stringByReplacingOccurrencesOfString:@"," withString:@""];
    }
    @catch (NSException *exception) {
        return deviceString;
    }
    @finally {

    }
}
- (void)configureViewShadowWithDirection:(RMoveDirection)direction
{
    if ([[self deviceWithNumString]hasPrefix:@"iPhone"]&&[[[self deviceWithNumString]stringByReplacingOccurrencesOfString:@"iPhone" withString:@""] floatValue]<40) {
        return;
    }
    if ([[self deviceWithNumString]hasPrefix:@"iPod"]&&[[[self deviceWithNumString]stringByReplacingOccurrencesOfString:@"iPod" withString:@""] floatValue]<40) {
        return;
    }
    if ([[self deviceWithNumString]hasPrefix:@"iPad"]&&[[[self deviceWithNumString]stringByReplacingOccurrencesOfString:@"iPad" withString:@""] floatValue]<40) {
        return;
    }
    CGFloat shadowWidth;
    switch (direction) {
        case RMoveDirectionLeft:
            shadowWidth = 2.0f;
            break;
        case RMoveDirectionRight:
            shadowWidth = -2.0f;
            break;
        default:
            break;
    }
    mainContentView.layer.shadowOffset = CGSizeMake(shadowWidth, 1.0);
    mainContentView.layer.shadowColor = [UIColor blackColor].CGColor;
    mainContentView.layer.shadowOpacity = 0.8f;
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"] ) {
        return NO;
    }
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
