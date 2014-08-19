//
//  LYHSubViewController.h
//  SinaNewsUI
//
//  Created by Charles Leo on 14-8-7.
//  Copyright (c) 2014年 Charles Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYHSubViewController : UIViewController
@property (nonatomic, strong) NSString *szSignal;

- (id)initWithFrame:(CGRect)frame andSignal:(NSString *)szSignal;
@end
