//
//  LYHLeftViewController.m
//  SinaNewsUI
//
//  Created by Charles Leo on 14-8-7.
//  Copyright (c) 2014年 Charles Leo. All rights reserved.
//

#import "LYHLeftViewController.h"

@interface LYHLeftViewController ()
{
    NSArray * arrayData;
}
@end

@implementation LYHLeftViewController

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
    arrayData = @[@"新闻",@"订阅",@"图片",@"视频",@"跟帖",@"电台"];
    self.view.backgroundColor = [UIColor clearColor];
    UIImageView * imageBg = [[UIImageView alloc]initWithFrame:self.view.bounds];
    imageBg.image = [UIImage imageNamed:@"sidebar_bg.jpg"];
    [self.view addSubview:imageBg];
    
    __block float h = self.view.frame.size.height * 0.7/[arrayData count];
    __block float y = 0.15*self.view.frame.size.height;
    [arrayData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView * listView = [[UIView alloc]initWithFrame:CGRectMake(0, y, self.view.frame.size.height, h)];
        listView.backgroundColor = [UIColor clearColor];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, listView.frame.size.width - 60, listView.frame.size.height)];
        label.font = [UIFont systemFontOfSize:20];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        label.text = obj;
        [listView addSubview:label];
        [self.view addSubview:listView];
        y+=h;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
