//
//  FrequencyScreenView
//  AD9850BLE
//
//  Created by Takehisa Oneta on 2015/05/13.
//  Copyright (c) 2015年 Takehisa Oneta. All rights reserved.
//

#import "FrequencyScreenView.h"

//----------------------------------------------------------------
//----------------------------------------------------------------

@implementation FrequencyScreenView

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		_formRect = self.frame;
		_formRect.origin.x = 0;
		_formRect.origin.y = 0;
	}
	return self;
}

- (id) initWithCoder:(NSCoder*)coder {
	self = [super initWithCoder:coder];
	if(self) {
		_formRect = self.frame;
		_formRect.origin.x = 0;
		_formRect.origin.y = 0;


		panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
		panGesture.minimumNumberOfTouches = 1;
		panGesture.maximumNumberOfTouches = 1;
		[self addGestureRecognizer:panGesture];
	
	}
	return self;
}

//----------------------------------------------------------------
//----------------------------------------------------------------

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
	
	//NSLog(@"WaveScreenView: drawRect");

	CGContextRef context = UIGraphicsGetCurrentContext();
	
	//CGRect drawRect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
	CGRect drawRect = rect;
	CGContextSetRGBFillColor(context, 0.0f, 0.0f, 0.0f, 1.0f);
	CGContextFillRect(context, drawRect);
	CGContextStrokePath(context);
	
	[self drawGridline:context];
}

//----------------------------------------------------------------
/**
 */
- (CGFloat)changeX:(CGFloat)x
{
	return _formRect.origin.x + (x * _formRect.size.width);
}

/**
 */
- (CGFloat)changeY:(CGFloat)y
{
	return (_formRect.origin.y + _formRect.size.height) - (y * _formRect.size.height);
}

//----------------------------------------------------------------
/**
 * 目盛を描画
 */
- (void)drawGridline:(CGContextRef)context
{
	CGContextSetStrokeColorWithColor(context, UIColor.greenColor.CGColor);
	CGContextSetLineWidth(context, 0.2);
	{
		// Y軸 目盛 (10個)
		for (double y = 0; y <= 1.0; y += 0.1) {
			CGContextMoveToPoint(context,		[self changeX:0.0],	[self changeY:y]);
			CGContextAddLineToPoint(context,	[self changeX:1.0], [self changeY:y]);
		}
		
		// X軸 目盛
		{
			// 分割サイズ
			for (double x = 0; x <= 1.0; x += 0.1) {
				CGContextMoveToPoint(context,    [self changeX:x], [self changeY:0.0]);
				CGContextAddLineToPoint(context, [self changeX:x], [self changeY:1.0]);
			}
		}
	}
	CGContextStrokePath(context);
/*
	// センターライン
	CGContextSetStrokeColorWithColor(context, UIColor.greenColor.CGColor);
	CGContextSetLineWidth(context, 0.5);
	CGContextMoveToPoint(context,    [self changeX:0], [self changeY:0.5]);
	CGContextAddLineToPoint(context, [self changeX:1], [self changeY:0.5]);
	CGContextStrokePath(context);
*/
}

//----------------------------------------------------------------

- (void)handlePanGesture:(id)sender
{
	UIPanGestureRecognizer *pan = (UIPanGestureRecognizer*)sender;
	CGPoint point = [pan translationInView:self];
	//CGPoint velocity = [pan velocityInView:self];
	
	static int32_t frequency = -1;	// TODO: !!
	static CGPoint beginPoint;
	if (pan.state == UIGestureRecognizerStateBegan) {
		if ([_delegate respondsToSelector:@selector(requestFrequencyValue)]) {
			frequency = [_delegate requestFrequencyValue];
		}
		beginPoint = point;
		
	} else if ((pan.state == UIGestureRecognizerStateChanged) || (pan.state == UIGestureRecognizerStateEnded)) {
		int32_t tmpHzF1 = 0;
		int32_t tmpHzF2 = 0;
#if 1
		if (fabs(beginPoint.x - point.x) < fabs(beginPoint.y - point.y)) {
			tmpHzF1 = (int)point.y;
		} else {
			tmpHzF2 = (int)point.x;
		}
#else
		tmpHzF1 = (int)point.y;
		tmpHzF2 = (int)point.x;
#endif
		int32_t hzF = tmpHzF1 * -1 * (1 * 1000) + tmpHzF2;
/*
		int32_t hzF1 = tmpHzF1 * -1 * (10 * 1000);
		if (hzF1 < 0) {
			hzF1 = 0;
		}
 		int32_t hzF = hzF1 + tmpHzF2;
*/

		
		if (pan.state == UIGestureRecognizerStateChanged) {
			if ([_delegate respondsToSelector:@selector(changeFrequencyValue:)]) {
				[_delegate changeFrequencyValue:(frequency + hzF)];
			}
		} else if (pan.state == UIGestureRecognizerStateEnded) {
			if ([_delegate respondsToSelector:@selector(didChangeFrequencyValue:)]) {
				[_delegate didChangeFrequencyValue:(frequency + hzF)];
			}
		}
	}
	
}

//----------------------------------------------------------------

@end
