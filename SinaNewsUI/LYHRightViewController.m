//
//  LYHRightViewController.m
//  SinaNewsUI
//
//  Created by Charles Leo on 14-8-7.
//  Copyright (c) 2014年 Charles Leo. All rights reserved.
//

#import "LYHRightViewController.h"

@interface LYHRightViewController ()

@end

@implementation LYHRightViewController

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
	UIImageView * imageBg = [[UIImageView alloc]initWithFrame:self.view.bounds];
    [imageBg setImage:[UIImage imageNamed:@"sidebar_bg.jpg"]];
    [self.view addSubview:imageBg];
    imageBg.userInteractionEnabled = YES;
    
    float y = 0.3 * self.view.frame.size.height;
    
    //头像
    _headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.center.x - 40 * 0.7, y, 100, 100)];
    _headImageView.layer.cornerRadius = 50.0;
    _headImageView.backgroundColor = [UIColor clearColor];
    _headImageView.layer.borderWidth = 1.0;
    _headImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _headImageView.layer.masksToBounds = YES;
    _headImageView.image = [UIImage imageNamed:@"head1.jpg"];
    [imageBg addSubview:_headImageView];
    
    _headImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * singleTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headPhotoAnimation)];
    [_headImageView addGestureRecognizer:singleTapRecognizer];
}
- (void)headPhotoAnimation
{
    [self rotate360WithDuration:2.0 repeatCount:1];
    _headImageView.animationDuration = 2.0;
    _headImageView.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"head1.jpg"],
                                      [UIImage imageNamed:@"head2.jpg"],[UIImage imageNamed:@"head2.jpg"],
                                      [UIImage imageNamed:@"head2.jpg"],[UIImage imageNamed:@"head2.jpg"],
                                      [UIImage imageNamed:@"head1.jpg"], nil];
    _headImageView.animationRepeatCount = 1;
    [_headImageView startAnimating];
}

- (void)rotate360WithDuration:(CGFloat)aDuration repeatCount:(CGFloat)aRepeatCount
{
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animation];
    animation.values = [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0, 1, 0)],[NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0, 1, 0)],[NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0, 1, 0)],[NSValue valueWithCATransform3D:CATransform3DMakeRotation(2*M_PI, 0, 1, 0)],nil];
    animation.cumulative = YES;
    animation.duration = aDuration;
    animation.repeatCount = aRepeatCount;
    animation.removedOnCompletion = YES;
    [_headImageView.layer addAnimation:animation forKey:@"transform"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
