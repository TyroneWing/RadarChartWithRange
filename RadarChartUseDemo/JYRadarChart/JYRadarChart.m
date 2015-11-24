//
//  JYRadarChart.m
//  JYRadarChart
//
//  Created by jy on 13-10-31.
//  Copyright (c) 2013年 wcode. All rights reserved.
//

#import "JYRadarChart.h"
#import "JYLegendView.h"

#define PADDING 13
#define LEGEND_PADDING 3
#define ATTRIBUTE_TEXT_SIZE 10
#define COLOR_HUE_STEP 5
#define MAX_NUM_OF_COLOR 17

@interface JYRadarChart ()

@property (nonatomic, assign) NSUInteger numOfV;
@property (nonatomic, strong) JYLegendView *legendView;
@property (nonatomic, strong) UIFont *scaleFont;
@property (nonatomic, strong) NSMutableArray *pointValueLabelArray;
@end

@implementation JYRadarChart

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		self.backgroundColor = [UIColor whiteColor];
		_maxValue = 100.0;
		_centerPoint = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
		_r = MIN(self.frame.size.width / 2 - PADDING, self.frame.size.height / 2 - PADDING);
		_steps = 1;
		_drawPoints = NO;
		_showLegend = NO;
		_showStepText = NO;
        _fillArea = NO;
        _showPointValue = NO;
		_minValue = 0;
        _colorOpacity = 1.0;
		_backgroundLineColor = [UIColor darkGrayColor];
        _pointValueLabelArray = [[NSMutableArray alloc] init];
		self.legendView = [[JYLegendView alloc] initWithFrame:CGRectMake(frame.size.width - 60, 10, 50, 70)];
		self.legendView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
		self.legendView.backgroundColor = [UIColor clearColor];
		self.legendView.colors = [NSMutableArray array];
		self.attributes = @[@"you", @"should", @"set", @"these", @"data", @"titles,",
		                    @"this", @"is", @"just", @"a", @"placeholder"];
        
		self.scaleFont = [UIFont systemFontOfSize:ATTRIBUTE_TEXT_SIZE];
	}
	return self;
}

- (void)setShowLegend:(BOOL)showLegend {
	_showLegend = showLegend;
	if (_showLegend) {
		[self addSubview:self.legendView];
	}
	else {
		for (UIView *subView in self.subviews) {
			if ([subView isKindOfClass:[JYLegendView class]]) {
				[subView removeFromSuperview];
			}
		}
	}
}

- (void)setTitles:(NSArray *)titles {
	self.legendView.titles = titles;
}

- (void)setColors:(NSArray *)colors {
    [self.legendView.colors removeAllObjects];
    for (UIColor *color in colors) {
        [self.legendView.colors addObject:[color colorWithAlphaComponent:self.colorOpacity]];
    }
}

- (void)setNeedsDisplay {
	[super setNeedsDisplay];
	[self.legendView sizeToFit];
	[self.legendView setNeedsDisplay];
    NSLog(@"setNeedsDisplay");

}

- (void)setDataSeries:(NSArray *)dataSeries {
	_dataSeries = dataSeries;
	_numOfV = [_dataSeries[0] count];
	if (self.legendView.colors.count < _dataSeries.count) {
		for (int i = 0; i < _dataSeries.count; i++) {
			UIColor *color = [UIColor colorWithHue:1.0 * (i * COLOR_HUE_STEP % MAX_NUM_OF_COLOR) / MAX_NUM_OF_COLOR
			                            saturation:1
			                            brightness:1
			                                 alpha:self.colorOpacity];
			self.legendView.colors[i] = color;
		}
	}
}

- (void)setShowPointValue:(BOOL)showPointValue
{
    _showPointValue = showPointValue;
    NSLog(@"setShowPointValue");
}

- (void)layoutSubviews {
	[self.legendView sizeToFit];
	CGRect r = self.legendView.frame;
	r.origin.x = self.frame.size.width - self.legendView.frame.size.width - LEGEND_PADDING;
	r.origin.y = LEGEND_PADDING;
	self.legendView.frame = r;
	[self bringSubviewToFront:self.legendView];
}

- (void)drawRect:(CGRect)rect {
    NSLog(@"drawRect");
    for (UIView *la in _pointValueLabelArray) {
        [la removeFromSuperview];
    }
    [_pointValueLabelArray removeAllObjects];

	NSArray *colors = [self.legendView.colors copy];
	CGFloat radPerV = M_PI * 2 / _numOfV;
	CGContextRef context = UIGraphicsGetCurrentContext();
    
	//draw attribute text
	CGFloat height = [self.scaleFont lineHeight];
	CGFloat padding = 2.0;
	for (int i = 0; i < _numOfV; i++) {
		NSString *attributeName = _attributes[i];
		CGPoint pointOnEdge = CGPointMake(_centerPoint.x - _r * sin(i * radPerV), _centerPoint.y - _r * cos(i * radPerV));
        
		CGSize attributeTextSize = JY_TEXT_SIZE(attributeName, self.scaleFont);
		NSInteger width = attributeTextSize.width;
        
		CGFloat xOffset = pointOnEdge.x >= _centerPoint.x ? width / 2.0 + padding : -width / 2.0 - padding;
		CGFloat yOffset = pointOnEdge.y >= _centerPoint.y ? height / 2.0 + padding : -height / 2.0 - padding;
		CGPoint legendCenter = CGPointMake(pointOnEdge.x + xOffset, pointOnEdge.y + yOffset);
        
		//TODO: use attributes in iOS 7
		[attributeName drawInRect:CGRectMake(legendCenter.x - width / 2.0,
		                                     legendCenter.y - height / 2.0,
		                                     width,
		                                     height)
		                 withFont:self.scaleFont
		            lineBreakMode:NSLineBreakByClipping
		                alignment:NSTextAlignmentCenter];
	}
    
    
	//draw steps line
	//static CGFloat dashedPattern[] = {3,3};
	//TODO: make this color a variable
	[[UIColor lightGrayColor] setStroke];
	CGContextSaveGState(context);
	for (int step = 1; step <= _steps; step++) {
		for (int i = 0; i <= _numOfV; ++i) {
			if (i == 0) {
				CGContextMoveToPoint(context, _centerPoint.x, _centerPoint.y - _r * step / _steps);
			}
			else {
				//                CGContextSetLineDash(context, 0, dashedPattern, 2);
				CGContextAddLineToPoint(context, _centerPoint.x - _r * sin(i * radPerV) * step / _steps,
				                        _centerPoint.y - _r * cos(i * radPerV) * step / _steps);
			}
		}
		CGContextStrokePath(context);
	}
	CGContextRestoreGState(context);
    
	//draw lines from center
	//TODO: make this color a variable
	[[UIColor darkGrayColor] setStroke];
	for (int i = 0; i < _numOfV; i++) {
		CGContextMoveToPoint(context, _centerPoint.x, _centerPoint.y);
		CGContextAddLineToPoint(context, _centerPoint.x - _r * sin(i * radPerV),
		                        _centerPoint.y - _r * cos(i * radPerV));
		CGContextStrokePath(context);
	}
	//end of base except axis label
    
    
	CGContextSetLineWidth(context, 2.0);
    
/////////////////////////////////////////////////////////////////
    
    
	//draw lines
	for (int serie = 0; serie < [_dataSeries count]; serie++) {
		if (self.fillArea) {
			[colors[serie] setFill];
		}
		else {
			[colors[serie] setStroke];
		}
        
        int minSerie = 0;
        if (_minArray.count == 1) {
            minSerie = 0;
        } else if (_minArray.count > 1 && _minArray.count == _numOfV) {
            minSerie = serie;
        }
        int maxSerie = 0;
        if (_maxArray.count == 1) {
            maxSerie = 0;
        } else if (_maxArray.count > 1 && _maxArray.count == _numOfV) {
            maxSerie = serie;
        }
        
		for (int i = 0; i < _numOfV; ++i) {
			CGFloat value = [_dataSeries[serie][i] floatValue];
			if (i == 0) {
				CGContextMoveToPoint(context, _centerPoint.x, _centerPoint.y - (value - [_minArray[minSerie][i] floatValue]) / ([_maxArray[maxSerie][i] floatValue] - [_minArray[minSerie][i] floatValue]) * _r);
			}
			else {
				CGContextAddLineToPoint(context, _centerPoint.x - (value - [_minArray[minSerie][i] floatValue]) / ([_maxArray[maxSerie][i] floatValue] - [_minArray[minSerie][i] floatValue]) * _r * sin(i * radPerV),
				                        _centerPoint.y - (value - [_minArray[minSerie][i] floatValue]) / ([_maxArray[maxSerie][i] floatValue] - [_minArray[minSerie][i] floatValue]) * _r * cos(i * radPerV));
			}
		}
		CGFloat value = [_dataSeries[serie][0] floatValue];
		CGContextAddLineToPoint(context, _centerPoint.x, _centerPoint.y - (value - [_minArray[minSerie][0] floatValue]) / ([_maxArray[maxSerie][0] floatValue] - [_minArray[minSerie][0] floatValue]) * _r);
        
        
//////////////////////////////////////////////////////////////////////
        
		if (self.fillArea) {
			CGContextFillPath(context);
		}
		else {
			CGContextStrokePath(context);
		}

        
		//draw data points
		if (_drawPoints) {
            
			for (int i = 0; i < _numOfV; i++) {
				CGFloat value = [_dataSeries[serie][i] floatValue];
				CGFloat xVal = _centerPoint.x - (value - [_minArray[minSerie][i] floatValue]) / ([_maxArray[maxSerie][i] floatValue] - [_minArray[minSerie][i] floatValue]) * _r * sin(i * radPerV);
				CGFloat yVal = _centerPoint.y - (value - [_minArray[minSerie][i] floatValue]) / ([_maxArray[maxSerie][i] floatValue] - [_minArray[minSerie][i] floatValue]) * _r * cos(i * radPerV);
                
				[colors[serie] setFill];
				CGContextFillEllipseInRect(context, CGRectMake(xVal - 2, yVal - 2, 4, 4));
				[self.backgroundColor setFill];
//				CGContextFillEllipseInRect(context, CGRectMake(xVal - 1, yVal - 1, 2, 2));
                
                NSString *pointLabelText = [NSString stringWithFormat:@"%g", value];
//                JY_DRAW_TEXT_IN_RECT(pointLabelText,CGRectMake(xVal, yVal, 20, 10),self.scaleFont);
                //显示点的数值
                if (_showPointValue) {
                    UILabel *pointLabel = [[UILabel alloc] initWithFrame:CGRectMake(xVal, yVal, 20, 10)];
                    [_pointValueLabelArray addObject:pointLabel];
                    pointLabel.font = [UIFont systemFontOfSize:12];
                    pointLabel.adjustsFontSizeToFitWidth = YES;
                    pointLabel.text = pointLabelText;
                    [self addSubview:pointLabel];
                    if (yVal<_centerPoint.y) {
                        if (xVal<_centerPoint.x) {
                            pointLabel.frame = CGRectMake(xVal, yVal-10, 20, 10);
                        } else if (xVal>_centerPoint.x){
                            pointLabel.frame = CGRectMake(xVal-20, yVal-10, 20, 10);
                        } else {
                            pointLabel.frame = CGRectMake(xVal-10, yVal-20, 20, 10);
                        }
                    } else {
                        pointLabel.frame = CGRectMake(xVal, yVal, 20, 10);
                    }

                }
            }
		}
	}
    
	if (self.showStepText) {
		//draw step label text, alone y axis
		//TODO: make this color a variable
		[[UIColor blackColor] setFill];
		for (int step = 0; step <= _steps; step++) {
			CGFloat value = [_minArray[0][0] floatValue] + ([_maxArray[0][0] floatValue] - [_minArray[0][0] floatValue]) * step / _steps;
			NSString *currentLabel = [NSString stringWithFormat:@"%.0f", value];
			JY_DRAW_TEXT_IN_RECT(currentLabel,
			                     CGRectMake(_centerPoint.x + 3,
			                                _centerPoint.y - _r * step / _steps - 3,
			                                20,
			                                10),
			                     self.scaleFont);
		}
	}
}
@end
