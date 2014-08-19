//
//  LYHMainGestureRecognizerViewController.h
//  SinaNewsUI
//
//  Created by Charles Leo on 14-8-7.
//  Copyright (c) 2014年 Charles Leo. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, MoveType)
{
    MoveTypeScale,
    MoveTypeMove
};
@interface LYHMainGestureRecognizerViewController : UIViewController
@property (assign,nonatomic) BOOL canDragBack;//时候可以拖拽
@property (nonatomic,assign) MoveType moveType;
- (void)addMainViewController:(UIViewController *)viewController;
+ (LYHMainGestureRecognizerViewController *)getMainViewController;
@end
