//
//  AD9850Control.h
//  AD9850BLE
//
//  Created by Takehisa Oneta on 2015/05/20.
//  Copyright (c) 2015年 Takehisa Oneta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLEInfoDef.h"
#import "BLEAdvertising.h"
#import "BLEPeripheralAccess.h"

//----------------------------------------------------------------

typedef enum {
	// commands
	AD9850_Command_Non = 0x00,
	AD9850_Command_Device,				// 出力デバイス選択
	AD9850_Command_Output,				// 出力 ON/OFF
	AD9850_Command_Frequency,			// 周波数設定
	
	// status
	AD9850_Status_Device    = 0x80 | AD9850_Command_Device,		// 出力デバイス取得
	AD9850_Status_Output    = 0x80 | AD9850_Command_Output,		// 出力状態取得
	AD9850_Status_Frequency = 0x80 | AD9850_Command_Frequency,	// 出力周波数取得
	
	// special
	AD9850_Command_Reset = 0xff,			// デバイスリセット
	
} enumAD9850Command;

//----------------------------------------------------------------

@protocol AD9850ControlDelegate <NSObject>
- (void)didConnect;
- (void)didDisconnect;

- (void)didBeginCommandSend;
- (void)didEndCommandSend;
@end


@interface AD9850Control : NSObject <BLEAdvertisingDelegate, BLEPeripheralAccessDelegate>
{
	BLEAdvertising		*bleAdvertising;
	BLEPeripheralAccess	*blePeripheralAccess;

}
@property (nonatomic, assign) id<AD9850ControlDelegate> delegate;

@property (strong)	NSMutableDictionary	*characteristicDic;		// value=CBCharacteristic


//- (void)init;
- (void)initializeContoller;

- (void)peripheralScanStart;
- (void)peripheralScanStop;

- (void)forceDisconnect;
- (BOOL)isConnected;

//- (void)setWaveForm:(double *)waveBuffer;
//- (double *)getWaveForm;

- (void)beginCommand;
- (void)endCommand;

- (void)setDevice:(int)deviceId;
- (void)setOutput:(BOOL)using;

- (void)transferWaveBuffer;
- (void)setFrequencey:(uint32_t)freq;
- (void)reset;

- (int)getDevice;
- (BOOL)getOutput;
- (UInt32)getFrequencey;

@end
