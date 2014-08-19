//
//  LYHMainGestureRecognizerViewController.m
//  SinaNewsUI
//
//  Created by Charles Leo on 14-8-7.
//  Copyright (c) 2014年 Charles Leo. All rights reserved.
//

#import "LYHMainGestureRecognizerViewController.h"

@interface LYHMainGestureRecognizerViewController ()<UIGestureRecognizerDelegate>
{
    CGPoint startTouch;
    NSMutableArray * viewControllers;
    UIView * blackMask;
    CGFloat startBackViewX;
}

@property (nonatomic,assign) BOOL isMoving;

@end

@implementation LYHMainGestureRecognizerViewController

static LYHMainGestureRecognizerViewController * mainGestureView;
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
	self.view.backgroundColor = [UIColor yellowColor];
    if (!viewControllers) {
        viewControllers = [NSMutableArray new];
    }
    self.canDragBack = YES;
    self.moveType = MoveTypeMove;
    
    //添加边界阴影图片
    UIImageView * shadowImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"left_shadow_bg"]];
    shadowImageView.frame = CGRectMake(-10, 0, 10, self.view.frame.size.height);
    [self.view addSubview:shadowImageView];
    
    //添加拖拽手势
    UIPanGestureRecognizer * panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureRecognizer:)];
    panGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:panGestureRecognizer];
    mainGestureView =self;
}
- (void)addMainViewController:(UIViewController *)viewController
{
    [self.view addSubview:viewController.view];
    [viewControllers addObject:viewController];
    viewController.view.tag = viewControllers.count;
    
    CGRect frame = viewController.view.frame;
    viewController.view.frame = CGRectMake(320, viewController.view.frame.origin.y, viewController.view.frame.size.width, viewController.view.frame.size.height);
    if (!blackMask) {
        blackMask = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width,frame.size.height)];
        blackMask.backgroundColor = [UIColor blackColor];
    }
    [blackMask setAlpha:0.2];
    
    if (viewControllers.count > 1) {
        UIViewController * backViewController = [viewControllers objectAtIndex:viewControllers.count - 1];
        [backViewController.view addSubview:blackMask];
    }
    [UIView animateWithDuration:0.6 animations:^{
        [viewController.view setFrame:frame];
        [blackMask setAlpha:0.6];
    }
    completion:^(BOOL finished) {
        if (viewControllers.count > 1) {
            UIViewController * backViewController = [viewControllers objectAtIndex:viewControllers.count - 1];
            backViewController.view.alpha = 0;
        }
    }];
}
- (void)moveViewWithX:(float)x
{
    x = x>320?320:x;
    x= x<0?0:x;
    UIView * view = ((UIViewController *)[viewControllers lastObject]).view;
    CGRect frame = self.view.frame;
    frame.origin.x = x;
    view.frame = frame;
    float alpha = 0.4 - (x/800);
    blackMask.alpha = alpha;
    switch (self.moveType) {
        case MoveTypeScale:
            [self moveViewWithXTypeForScale:x];
            break;
            case MoveTypeMove:
            [self moveViewWithXTypeForMove:x];
        default:
            break;
    }
}

- (void)moveViewWithXTypeForScale:(float)x
{
    float scale = (x/6400)+0.95;
    UIView * backView = ((UIViewController *)[viewControllers objectAtIndex:viewControllers.count - 2]).view;
    backView.transform = CGAffineTransformMakeTranslation(scale, scale);
}
- (void)moveViewWithXTypeForMove:(float)x
{
    CGFloat aa = abs(startBackViewX)/[UIScreen mainScreen].bounds.size.width;
    CGFloat y = x * aa;
    UIView * backView = ((UIViewController *)[viewControllers objectAtIndex:viewControllers.count - 2]).view;
    [backView setFrame:CGRectMake(startBackViewX + y, backView.bounds.origin.y, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
}

- (void)panGestureRecognizer:(UIPanGestureRecognizer *)recoginzer
{
    if (viewControllers.count <= 1 || !self.canDragBack) return;
    CGPoint touchPoint = [recoginzer locationInView:[[UIApplication sharedApplication] keyWindow]];
    if (recoginzer.state == UIGestureRecognizerStateBegan) {
        self.isMoving = YES;
        startTouch = touchPoint;
        CGRect frame = self.view.frame;
        if (!blackMask) {
            blackMask = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
            blackMask.backgroundColor = [UIColor blackColor];
        }
        UIView * backView = ((UIViewController *)[viewControllers objectAtIndex:viewControllers.count - 2]).view;
        backView.alpha = 1;
        switch (self.moveType) {
            case MoveTypeScale:
            {
                break;
            }
                case MoveTypeMove:
            {
                [backView addSubview: blackMask];
                startBackViewX = -200;
                [backView setFrame:CGRectMake(startBackViewX, backView.frame.origin.y, backView.frame.size.height, backView.frame.size.width)];
                break;
            }
            default:
                break;
        }
    }
    else if (recoginzer.state == UIGestureRecognizerStateEnded)
    {
        if (touchPoint.x - startTouch.x > 50) {
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:320];
            }
            completion:^(BOOL finished) {
                self.isMoving = NO;
                [viewControllers removeLastObject];
                [blackMask removeFromSuperview];
            }];
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:0];
            }
            completion:^(BOOL finished) {
                self.isMoving = NO;
                [blackMask removeFromSuperview];
            }];
        }
        return;
    }
    else if(recoginzer.state == UIGestureRecognizerStateCancelled)
    {
        [UIView animateWithDuration:0.3 animations:^{
            [self moveViewWithX:0];
        }
        completion:^(BOOL finished) {
            self.isMoving = NO;
            UIView * backView = ((UIViewController *)[viewControllers objectAtIndex:viewControllers.count - 2]).view;
            backView.alpha = 0;
        }];
        return;
    }
    if (self.isMoving) {
        [self moveViewWithX:touchPoint.x - startTouch.x];
    }
}

+ (LYHMainGestureRecognizerViewController *)getMainViewController
{
    return mainGestureView;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"])
    {
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
