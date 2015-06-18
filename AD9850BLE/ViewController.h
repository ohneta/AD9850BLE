//
//  ViewController.h
//  AD9850BLE
//
//  Created by Takehisa Oneta on 2015/06/18.
//  Copyright (c) 2015年 Takehisa Oneta. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FrequencyScreenView;
@class AD9850Control;

@interface ViewController : UIViewController
{
	uint32_t		frequency;
	AD9850Control	*ad9850Control;
}

@end

