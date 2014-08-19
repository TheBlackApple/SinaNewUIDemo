//
//  LYHSubViewController.m
//  SinaNewsUI
//
//  Created by Charles Leo on 14-8-7.
//  Copyright (c) 2014年 Charles Leo. All rights reserved.
//

#import "LYHSubViewController.h"
#import "LYHMainGestureRecognizerViewController.h"
@interface LYHSubViewController ()
{
    UILabel *signalLabel;
    UISegmentedControl *selectTypeSegment;
}
@end

@implementation LYHSubViewController
- (id)initWithFrame:(CGRect)frame andSignal:(NSString *)szSignal
{
    self = [super init];
    if (self)
    {
        self.szSignal = szSignal;
        self.view.frame = frame;
        self.title = szSignal;
        [self.view setBackgroundColor:[UIColor whiteColor]];
        self.view.layer.borderWidth = 1;
        self.view.layer.borderColor = [UIColor blueColor].CGColor;
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
    signalLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 90)];
    signalLabel.text = _szSignal;
    signalLabel.textAlignment = NSTextAlignmentCenter;
    signalLabel.contentMode = UIViewContentModeScaleAspectFill;
    [signalLabel setBackgroundColor:[UIColor clearColor]];
    [signalLabel setTextColor:[UIColor blackColor]];
    [signalLabel setFont:[UIFont systemFontOfSize:20]];
    signalLabel.center = self.view.center;
    [self.view addSubview:signalLabel];
    signalLabel.userInteractionEnabled = YES;
    signalLabel.layer.borderWidth = 1;
    signalLabel.layer.borderColor = [UIColor blueColor].CGColor;
    
    UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] init];
    singleTapRecognizer.numberOfTapsRequired = 1;
    [singleTapRecognizer addTarget:self action:@selector(pust2View:)];
    [signalLabel addGestureRecognizer:singleTapRecognizer];
}

- (void)setSzSignal:(NSString *)szSignal
{
    _szSignal = szSignal;
    signalLabel.text = szSignal;
}

- (void)pust2View:(id)sender
{
    LYHSubViewController *subViewController = [[LYHSubViewController alloc] initWithFrame:[UIScreen mainScreen].bounds andSignal:@""];
    [[LYHMainGestureRecognizerViewController getMainViewController] addMainViewController:subViewController];
    NSArray *ar = [self.szSignal componentsSeparatedByString:@"--"];
    subViewController.szSignal = [NSString stringWithFormat:@"%@--%ld", [ar objectAtIndex:0], subViewController.view.tag];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
