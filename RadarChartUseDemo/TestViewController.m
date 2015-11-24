//
//  TestViewController.m
//  RadarChartUseDemo
//
//  Created by yi on 15/11/23.
//  Copyright © 2015年 yi. All rights reserved.
//

#import "TestViewController.h"
#import <AFNetworking.h>
#import "JYRadarChart.h"

#define ChartFirstColor [UIColor colorWithRed:255.0/255.0 green:104.0/255.0 blue:57.0/255.0 alpha:1.0]
#define ChartSecondColor [UIColor colorWithRed:115.0/255.0 green:193.0/255.0 blue:251.0/255.0 alpha:1.0]
#define ChartThirdColor [UIColor colorWithRed:208.0/255.0 green:79.0/255.0 blue:206.0/255.0 alpha:1.0]
#define ChartFourthColor [UIColor colorWithRed:38.0/255.0 green:195.0/255.0 blue:24.0/255.0 alpha:1.0]
#define ChartFifthColor [UIColor colorWithRed:80.0/255.0 green:124.0/255.0 blue:236.0/255.0 alpha:1.0]
#define ChartSixthColor [UIColor colorWithRed:255.0/255.0 green:72.0/255.0 blue:166.0/255.0 alpha:1.0]
#define ChartSeventhColor [UIColor colorWithRed:176.0/255.0 green:61.0/255.0 blue:207.0/255.0 alpha:1.0]
@interface TestViewController ()
{
    NSMutableDictionary *_radarChartDataDict;
     JYRadarChart *_radarChart;
}
@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    http://112.74.195.125:8080/capi/statistics/water/radarMonthly/6
    self.view.backgroundColor = [UIColor whiteColor];
    _radarChartDataDict = [[NSMutableDictionary alloc] init];
    [self startDowmloadRadarChartData];
    
}
- (void)addReloadBtn
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, 20, 60, 25);
    [btn addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"Reload" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn];
}
- (void)reloadData
{
    int n = 7;
    NSMutableArray *a = [NSMutableArray array];
    NSMutableArray *b = [NSMutableArray array];
    NSMutableArray *c = [NSMutableArray array];
    
    
    for (int i = 0; i < n - 1; i++) {
        a[i] = [NSNumber numberWithInt:arc4random() % 100 ];
        b[i] = [NSNumber numberWithInt:arc4random() % 100 ];
        c[i] = [NSNumber numberWithInt:arc4random() % 100 ];
    }
    
    _radarChart.dataSeries = @[a];
    _radarChart.fillArea = arc4random() % 2 ? YES : NO;
    _radarChart.drawPoints = YES;
    _radarChart.showStepText = NO;
    _radarChart.showPointValue = YES;
    [_radarChart setNeedsDisplay];

}

- (void)startDowmloadRadarChartData
{
    NSString *url = @"http://112.74.195.125:8080/capi/statistics/water/radarMonthly/6";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFCompoundResponseSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        _radarChartDataDict = dict;
        
        NSLog(@"_radarChartDataDict = %@",dict);
        

        [self createRadarChart];
        [self addReloadBtn];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)createRadarChart
{
    _radarChart = [[JYRadarChart alloc] initWithFrame:CGRectMake(0, 30, self.view.bounds.size.width, 200)];
    _radarChart.dataSeries = _radarChartDataDict[@"data"];
    _radarChart.showPointValue = YES;
    //雷达圈数
    _radarChart.steps = 3;
    //显示雷达圈数值大小
    //    p.showStepText = YES;
    _radarChart.backgroundColor = [UIColor whiteColor];
    //雷达每圈半径。不设置默认自动设置显示
    //    p.r = 100;
    float min = 0.0;
    float max = 0.0;
    for (NSArray *data in _radarChartDataDict[@"data"]) {
        for (int i = 0; i<data.count; i++) {
            double y = [data[i] doubleValue];
            if (y > max) {
                max = y;
            }
            if (y < min) {
                min = y;
            }

        }
    }
    if (min>1.0) {
        min = min - 1.0;
    }
    //雷达最大最小值,不设置最大最小值默认0-100
    _radarChart.minValue = min;
    _radarChart.maxValue = max;
    //雷达区域是否填充颜色
    _radarChart.fillArea = NO;
    _radarChart.drawPoints = YES;
    _radarChart.colorOpacity = 1;
    _radarChart.attributes = _radarChartDataDict[@"item"];
    //是否显示雷达线条说明
    _radarChart.showLegend = YES;
    [_radarChart setTitles:_radarChartDataDict[@"legend"]];
    [_radarChart setColors:@[ChartFirstColor,ChartSecondColor,ChartThirdColor,ChartFourthColor,ChartFirstColor,ChartFifthColor,ChartSixthColor,ChartSeventhColor]];
    [self.view addSubview:_radarChart];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
