//
//  RadarChartViewController.m
//  RadarChartUseDemo
//
//  Created by yi on 15/11/23.
//  Copyright © 2015年 yi. All rights reserved.
//

#import "RadarChartViewController.h"
#import "JYRadarChart.h"

@interface RadarChartViewController () {
    JYRadarChart *p;
    JYRadarChart *p2;
}

@end

@implementation RadarChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    p = [[JYRadarChart alloc] initWithFrame:CGRectMake(30, 20, 250, 200)];
//    NSArray *a1 = @[@(81), @(97), @(87), @(60), @(65), @(77)];
    NSArray *a1 = @[@"81", @"97", @"87", @"60", @"65", @"77"];  
    NSArray *a2 = @[@(91), @(87), @(33), @(77), @(78), @(96)];
    NSLog(@"%@",a1);
    p.dataSeries = @[a1, a2];
    //雷达圈数
    p.steps = 3;
    //显示雷达圈数值大小
//    p.showStepText = YES;
    p.backgroundColor = [UIColor grayColor];
    //雷达每圈半径。不设置默认自动设置显示
//    p.r = 100;
    //雷达最大最小值,不设置最大最小值默认0-100
    p.minValue = 30;
//    p.maxValue = 900;
    //雷达区域是否填充颜色
    p.fillArea = NO;
    p.backgroundLineColor = [UIColor redColor];
    p.drawPoints = YES;
    p.colorOpacity = 1;
    p.attributes = @[@"Attack", @"Defense", @"Speed", @"HP", @"MP", @"IQ"];
    //是否显示雷达线条说明
    p.showLegend = YES;
    [p setTitles:@[@"archer", @"footman"]];
    [p setColors:@[[UIColor yellowColor], [UIColor purpleColor]]];
    [self.view addSubview:p];
    NSLog(@"%f",p.r);
    
//    [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(updateRadarChartData) userInfo:nil repeats:YES];
    
    
    
    p2 = [[JYRadarChart alloc] initWithFrame:CGRectMake(10, 250, 300, 200)];
    //	p2.centerPoint = CGPointMake(130, 100);
    p2.showLegend = YES;
    [p2 setTitles:@[@"0000a", @"b"]];
    p2.drawPoints = YES;
    p2.attributes = @[@"Price", @"Value", @"Pressure", @"Height", @"Weight", @"Grade",
                      @"Volume", @"Length", @"Size", @"Padding", @"Pages", @"HAHAHA"];
    NSArray *b1 = @[@(86), @(97), @(87), @(60), @(85), @(77), @(73), @(74), @(53), @(82), @(65), @(61)];
    NSArray *b2 = @[@(91), @(87), @(43), @(77), @(78), @(96), @(51), @(65), @(77), @(55), @(84), @(91)];
    NSArray *b3 = @[@(51), @(97), @(87), @(60), @(25), @(77), @(93), @(14), @(53), @(34), @(65), @(51)];
    NSArray *b4 = @[@(11), @(87), @(65), @(77), @(55), @(84), @(43), @(77), @(78), @(96), @(51), @(11)];
    NSArray *b5 = @[@(41), @(97), @(87), @(60), @(95), @(77), @(73), @(74), @(59), @(82), @(95), @(41)];
    NSArray *b6 = @[@(61), @(96), @(51), @(65), @(77), @(87), @(43), @(70), @(78), @(55), @(44), @(61)];
    NSArray *b7 = @[@(81), @(97), @(74), @(53), @(82), @(65), @(87), @(60), @(85), @(77), @(73), @(81)];
    NSArray *b8 = @[@(91), @(84), @(43), @(67), @(78), @(96), @(47), @(55), @(67), @(55), @(51), @(91)];
    NSArray *b9 = @[@(38), @(85), @(77), @(93), @(74), @(53), @(82), @(97), @(87), @(60), @(65), @(38)];
    NSArray *b10 = @[@(31), @(87), @(43), @(37), @(78), @(96), @(51), @(65), @(17), @(55), @(54), @(31)];
    p2.dataSeries = @[b1, b2];
    p2.steps = 3;
    p2.minValue = 30;
    p2.showLegend = YES;
    p2.showStepText = YES;
    
    p2.backgroundColor = [UIColor grayColor];
    [self.view addSubview:p2];
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

