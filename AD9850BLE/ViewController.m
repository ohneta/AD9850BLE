//
//  ViewController.m
//  AD9850BLE
//
//  Created by Takehisa Oneta on 2015/06/18.
//  Copyright (c) 2015年 Takehisa Oneta. All rights reserved.
//

#import "ViewController.h"
#import "FrequencyScreenView.h"
#import "AD9850Control.h"

@interface ViewController () <FrequencyScreenViewDelegate, AD9850ControlDelegate>

@property (weak, nonatomic) IBOutlet UILabel *frequencyLabel;
@property (weak, nonatomic) IBOutlet UIButton *frequencyUpButton;
@property (weak, nonatomic) IBOutlet UIButton *frequencyDownButton;

@property (weak, nonatomic) IBOutlet FrequencyScreenView *frequencyScreenView;

@end
//----------------------------------------------------------------

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	[self setFrequency:(10 * 1000 * 1000)];	// 初期値

	_frequencyScreenView.delegate = self;
	_frequencyScreenView.userInteractionEnabled = NO;
	_frequencyUpButton.enabled = NO;
	_frequencyDownButton.enabled = NO;


	// BLE connect
	{
		ad9850Control = [[AD9850Control alloc] init];
		ad9850Control.delegate = self;
		[ad9850Control peripheralScanStart];
	}
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

//----------------------------------------------------------------
#pragma mark - for AD9850ControlDelegate
- (void)didConnect
{
	_frequencyScreenView.userInteractionEnabled = YES;
	_frequencyUpButton.enabled = YES;
	_frequencyDownButton.enabled = YES;
	
}

- (void)didDisconnect
{
	_frequencyScreenView.userInteractionEnabled = NO;
	_frequencyUpButton.enabled = NO;
	_frequencyDownButton.enabled = NO;

}

- (void)didBeginCommandSend
{
	
}

- (void)didEndCommandSend
{
	
}

//----------------------------------------------------------------
//----------------------------------------------------------------

- (IBAction)frequencyUpButtonHandle:(id)sender {
	[self setFrequency:(frequency + 1)];
	[ad9850Control setFrequencey:frequency];
}

- (IBAction)frequencyDownButtonHandle:(id)sender {
	[self setFrequency:(frequency - 1)];
	[ad9850Control setFrequencey:frequency];
}

//----------------------------------------------------------------
#pragma mark - for FrequencyScreenViewDelegate

- (int32_t)requestFrequencyValue {
	return frequency;
}

- (void)changeFrequencyValue:(int32_t)value {
	static int cnt = 0;

	[self setFrequency:value];

	if (cnt == 0) {
		// send to BLE
		[ad9850Control setFrequencey:frequency];
	}

	cnt++;
	if (cnt > 3) {
		cnt = 0;
	}
}


- (void)didChangeFrequencyValue:(int32_t)value {
	[self setFrequency:value];

	// send to BLE
	[ad9850Control setFrequencey:frequency];
}

- (void)setFrequency:(int32_t)value
{
	if (value < 0) {		// 最小 0Hz
		value = 0;
	}
	if (value > (45 * 1000 * 1000)) {	// 最大 45MHz
		value = 45 * 1000 * 1000;
	}
	frequency = value;

	NSNumberFormatter *format = [[NSNumberFormatter alloc] init];
	[format setNumberStyle:NSNumberFormatterDecimalStyle];
	[format setGroupingSeparator:@","];
	[format setGroupingSize:3];
	_frequencyLabel.text = [format stringForObjectValue:[NSNumber numberWithInt:frequency]];
}

@end
