//
//  ViewController.m
//  scrollLabel
//
//  Created by ZHS on 3/20/15.
//  Copyright (c) 2015 HuaZhu. All rights reserved.
//

#import "ViewController.h"
#import "HTTickerLabel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIFont *font = [UIFont systemFontOfSize: 16];
    
    HTTickerLabel* tickerLabel = [[HTTickerLabel alloc] initWithFrame: CGRectMake(280, 50, 110, 25)];
    tickerLabel.font = font;
    tickerLabel.changeTextAnimationDuration = .5;
    tickerLabel.backgroundColor = [UIColor clearColor];
    tickerLabel.textColor = [UIColor blueColor];
    
    tickerLabel.text = @"1024";
    
    [self.view addSubview: tickerLabel];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        tickerLabel.text = @"1099";
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
