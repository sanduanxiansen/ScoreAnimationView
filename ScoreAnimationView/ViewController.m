//
//  ViewController.m
//  ScoreAnimationView
//
//  Created by CC on 16/7/25.
//  Copyright © 2016年 CC. All rights reserved.
//

#import "ViewController.h"
#import "ScoreView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ScoreView *scoreView = [[ScoreView alloc] init];
    scoreView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 180);
    scoreView.center = self.view.center;
    scoreView.score = 8;
    [self.view addSubview:scoreView];
    
}



@end
