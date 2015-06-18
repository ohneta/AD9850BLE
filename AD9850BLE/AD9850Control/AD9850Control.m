//
//  AD9850Control.m
//  AD9850BLE
//
//  Created by Takehisa Oneta on 2015/05/20.
//  Copyright (c) 2015年 Takehisa Oneta. All rights reserved.
//

#import "AD9850Control.h"

@implementation AD9850Control

//------------------------------------------------------------------------------------------
/**
 *
 */
- (instancetype)init
{
	self = [super init];
	if (self != nil) {
		_characteristicDic = [NSMutableDictionary dictionary];
		[self initializeContoller];
	}
	return self;
}

//------------------------------------------------------------------------------------------
/**
 *
 */
- (void)initializeContoller
{
	bleAdvertising = [[BLEAdvertising alloc] init];
	bleAdvertising.delegate = self;
	blePeripheralAccess = nil;
}

//------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------
/**
 * スキャン開始
 */
- (void)peripheralScanStart
{
	[bleAdvertising scanStart];
}

/**
 * スキャン停止
 */
- (void)peripheralScanStop
{
	[bleAdvertising scanStop];
}

//--------------------------------------
// for BLEAdvertisingDelegate
/**
 * 所望のペリフェラルが存在した!
 */
- (void)didConnectPeripheral:(CBPeripheral *)peripheral
{
	NSLog(@"didConnectPeripheral");
	if ([_delegate respondsToSelector:@selector(didConnect)]) {
		[_delegate didConnect];
	}

	blePeripheralAccess = [[BLEPeripheralAccess alloc] initWithPeripheral:peripheral];
	blePeripheralAccess.delegate = self;
	{
		[blePeripheralAccess.characteristicUUIDs addObject:CHARACTERISTICS_UUID_DEVICE];
		[blePeripheralAccess.characteristicUUIDs addObject:CHARACTERISTICS_UUID_OUTPUT];
		[blePeripheralAccess.characteristicUUIDs addObject:CHARACTERISTICS_UUID_FREQUENCY];
	}
	[blePeripheralAccess discoverServices];
}

- (void)didDisconnectPeripheral:(CBPeripheral *)peripheral
{
	NSLog(@"didDisconnectPeripheral");
	blePeripheralAccess = nil;

	if ([_delegate respondsToSelector:@selector(didDisconnect)]) {
		[_delegate didDisconnect];
	}
}

//------------------------------------------------------------------------------------------
#pragma mark - for BLEPeripheralAccessDelegate

- (void)didFindCharacteristic:(CBCharacteristic *)characteristic c_uuid:(NSString *)c_uuid;
{
	[_characteristicDic setObject:characteristic forKey:c_uuid];
	NSLog(@"didFindCharacteristic : %@", c_uuid);
}

- (void)didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic
{
	
}

//------------------------------------------------------------------------------------------
/*
- (void)connect:(CBPeripheral *)peripheral
{
}
- (void)disconnect:(CBPeripheral *)peripheral
{
	// 強制切断
	[bleAdvertising disconnect:peripheral];
}
*/

- (void)forceDisconnect
{
	[bleAdvertising forceDisconnect];
}

- (BOOL)isConnected
{
	return (blePeripheralAccess != nil);
}

//------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------
#pragma mark - BLE Characteristics (FuncGen-commands)

// for FGControllerDelegate
- (void)beginCommand
{
	if ([_delegate respondsToSelector:@selector(didBeginCommandSend)]) {
		[_delegate didBeginCommandSend];
	}
}

- (void)endCommand
{
	if ([_delegate respondsToSelector:@selector(didEndCommandSend)]) {
		[_delegate didEndCommandSend];
	}
}

//------------------------------------------------------------------------------------------
/**
 * 出力デバイスの選択
 */
- (void)setDevice:(int)deviceId
{
	[self beginCommand];
	{
		
	}
	[self endCommand];
}

//------------------------------------------------------------------------------------------
/**
 * 出力のON/OFF
 *
 * @param BOOL using	YES=ON、NO=OFF
 */
- (void)setOutput:(BOOL)using
{
	 if (blePeripheralAccess == nil)
		 return;

	[self beginCommand];
	{
		uint8_t usingValue = using ? 1 : 0;
		NSData *data = [NSData dataWithBytes:(unsigned char *)&usingValue length:sizeof(uint8_t)];
		NSLog(@"setOutput: %@", data.description);
		
		CBCharacteristic *characteristic = [_characteristicDic objectForKey:CHARACTERISTICS_UUID_OUTPUT];
		[blePeripheralAccess writeWithResponse:characteristic value:data];
	}
	[self endCommand];
}


//------------------------------------------------------------------------------------------
/**
 * 周波数設定
 */
- (void)setFrequencey:(uint32_t)freq
{
	if (blePeripheralAccess == nil)
		return;
	
	[self beginCommand];
	{
		NSData *data = [NSData dataWithBytes:(unsigned char *)&freq length:sizeof(uint32_t)];
		NSLog(@"setFrequencey: %@", data.description);
		
		CBCharacteristic *characteristic = [_characteristicDic objectForKey:CHARACTERISTICS_UUID_FREQUENCY];
		[blePeripheralAccess writeWithResponse:characteristic value:data];
		
	}
	[self endCommand];
}

//------------------------------------------------------------------------------------------
/**
 * リセット
 */
- (void)reset
{
	[self beginCommand];
	[self endCommand];
}

//------------------------------------------------------------------------------------------
/**
 * デバイス情報取得
 */
- (int)getDevice
{
	[self beginCommand];
	[self endCommand];

	return 0;
}

//------------------------------------------------------------------------------------------
/**
 * 出力状態の取得
 *
 * @return BOOL YES=ON、NO=OFF
 */
- (BOOL)getOutput
{
	[self beginCommand];
	[self endCommand];
	
	return YES;
}

//------------------------------------------------------------------------------------------
/**
 * 出力周波数の取得
 */
- (UInt32)getFrequencey
{
	[self beginCommand];
	[self endCommand];
	
	return 100;
}

@end
