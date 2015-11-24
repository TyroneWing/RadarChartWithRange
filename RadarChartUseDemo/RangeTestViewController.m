//
//  RangeTestViewController.m
//  RadarChartUseDemo
//
//  Created by yi on 15/11/23.
//  Copyright © 2015年 yi. All rights reserved.
//

#import "RangeTestViewController.h"
#import "JYRadarChart.h"

#define ChartFirstColor [UIColor colorWithRed:255.0/255.0 green:104.0/255.0 blue:57.0/255.0 alpha:0.1]
#define ChartSecondColor [UIColor colorWithRed:115.0/255.0 green:193.0/255.0 blue:251.0/255.0 alpha:1.0]


@interface RangeTestViewController () {
    JYRadarChart *p;
    JYRadarChart *p2;
}

@end

@implementation RangeTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    p = [[JYRadarChart alloc] initWithFrame:CGRectMake(30, 20, 250, 200)];
    //    NSArray *a1 = @[@(81), @(97), @(87), @(60), @(65), @(77)];
    NSArray *a1 = @[@"80", @"200", @"7", @"60", @"200", @"100"];
    NSArray *a2 = @[@"30", @"100", @"5", @"80", @"120", @"80"];
    
    //限定每个分支的最大最小值
    p.maxArray = @[@[@"100", @"300", @"14", @"100", @"500", @"100"]];
    p.minArray = @[@[@"0", @"0", @"0", @"0", @"0", @"0"],@[@"0", @"0", @"0", @"0", @"0", @"0"]];
    //雷达最大最小值（已失效）
//    p.minValue = 30;
//    p.maxValue = 900;
    
    p.dataSeries = @[a1,a2];
    //雷达圈数
    p.steps = 5;
    //显示雷达圈数值大小
//    p.showStepText = YES;
    p.showPointValue = YES;
    //雷达每圈半径。不设置默认自动设置显示
    //    p.r = 100;

    //雷达区域是否填充颜色
    p.fillArea = NO;
    p.backgroundLineColor = [UIColor yellowColor];
    p.drawPoints = YES;
    p.colorOpacity = 1;
    p.attributes = @[@"Attack", @"Defense", @"Speed", @"HP", @"MP", @"IQ"];
    //是否显示雷达线条说明
    p.showLegend = YES;
    [p setTitles:@[@"archer"]];
    [p setColors:@[ChartFirstColor,ChartSecondColor,[UIColor yellowColor], [UIColor purpleColor]]];
    [self.view addSubview:p];
    
    //    [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(updateRadarChartData) userInfo:nil repeats:YES];
}

- (void)updateRadarChartData {
    int n = 6;
    NSMutableArray *a = [NSMutableArray array];
    NSMutableArray *b = [NSMutableArray array];
    NSMutableArray *c = [NSMutableArray array];
    
    
    for (int i = 0; i < n; i++) {
        a[i] = [NSNumber numberWithInt:arc4random() % 100 ];
        b[i] = [NSNumber numberWithInt:arc4random() % 100 ];
        c[i] = [NSNumber numberWithInt:arc4random() % 100 ];
    }
    
    p.dataSeries = @[a, b, c];
    p.steps = arc4random() % 6;
    p.fillArea = arc4random() % 2 ? YES : NO;
    p.drawPoints = arc4random() % 2 ? YES : NO;
    p.showStepText = YES;
    [p setTitles:@[@"iPhone", @"pizza", @"hard drive"]];
    [p setNeedsDisplay];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
