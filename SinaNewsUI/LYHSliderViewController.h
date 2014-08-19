//
//  LYHSliderViewController.h
//  SinaNewsUI
//
//  Created by Charles Leo on 14-8-7.
//  Copyright (c) 2014年 Charles Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYHSliderViewController : UIViewController

@property (nonatomic,strong) UIViewController * mLeftViewController;
@property (strong,nonatomic) UIViewController * mRightViewController;
@property (strong,nonatomic) UIViewController * mMainViewController;

@property (strong,nonatomic) NSMutableDictionary * controllersDict;
//左右偏移量
@property (assign,nonatomic) float LeftContentOffset;
@property (assign,nonatomic) float RightContentOffset;
//左右缩放量
@property (assign,nonatomic) float LeftContentScale;
@property (assign,nonatomic) float RightContentScale;
//判断左右偏移量
@property (assign,nonatomic) float LeftJudgeOffset;
@property (assign,nonatomic) float RightJudgeOffset;

@property (assign,nonatomic) float LeftOpenDuration;
@property (assign,nonatomic) float RightOpenDuration;

@property (assign,nonatomic) float LeftCloseDuration;
@property (assign,nonatomic) float RightCloseDuration;

@property (assign,nonatomic) BOOL canShowLeft;
@property (assign,nonatomic) BOOL canShowRight;

+ (LYHSliderViewController *)sharedSliderController;

- (void)showContentControllerWithModel:(NSString *)className;

- (void)showLeftViewController;

- (void)showRightViewController;

- (void)moveViewWithGesture:(UIPanGestureRecognizer *)panGesture;

@end
