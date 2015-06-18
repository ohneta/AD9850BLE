//
//  FrequencyScreenView.h
//  AD9850BLE
//
//  Created by Takehisa Oneta on 2015/05/13.
//  Copyright (c) 2015年 Takehisa Oneta. All rights reserved.
//

#import <UIKit/UIKit.h>

//----------------------------------------------------------------
@protocol FrequencyScreenViewDelegate <NSObject>
- (int32_t)requestFrequencyValue;

- (void)changeFrequencyValue:(int32_t)value;
- (void)didChangeFrequencyValue:(int32_t)value;

@end


@interface FrequencyScreenView : UIView
{
	UIPanGestureRecognizer	*panGesture;
}

@property (nonatomic, assign)	CGRect	formRect;

@property (nonatomic, assign) id<FrequencyScreenViewDelegate> delegate;


@end
