//
//  VWWBLEController.m
//  BLEPowerStrip
//
//  Created by Zakk Hoyt on 9/29/13.
//  Copyright (c) 2013 Zakk Hoyt. All rights reserved.
//

#import "VWWBLEController.h"
#import "BLE.h"
#import "NSTimer+Blocks.h"

static VWWBLEController *instance;


@interface VWWBLEController () <BLEDelegate>
@property (strong, nonatomic) BLE *ble;
//@property (nonatomic, strong) VWWBLEControllerSuccessBlock connectCompletion;

@end



@implementation VWWBLEController

#pragma mark Overridden methods

-(id)init{
    self = [super init];
    if(self){
        _ble = [[BLE alloc]init];
        [_ble controlSetup:1];
        _ble.delegate = self;
    }
    return self;
}





#pragma mark Private methods

//-(IBAction)sendDigitalOut:(id)sender
-(void)setDigitalState:(NSInteger)state forPin:(NSInteger)pin{
    UInt8 buf[3] = {0x01, state, pin};
    NSData *data = [[NSData alloc] initWithBytes:buf length:3];
    [self.ble write:data];
 //   NSLog(@"%s wrote %d to pin %d", __FUNCTION__, state, pin);
}





#pragma mark Public methods
+(VWWBLEController*)sharedInstance{
    if(instance == nil){
        instance = [[VWWBLEController alloc]init];
    }
    return instance;
}

-(BOOL)connected{
    return (self.ble.activePeripheral && self.ble.activePeripheral.isConnected);
}

-(void)connectWithCompletionBlock:(VWWBLEControllerSuccessBlock)completion{
    NSLog(@"%s", __func__);
    // Disconnect if already connected
    if (self.ble.activePeripheral && self.ble.activePeripheral.isConnected){
        NSError *error = [NSError errorWithDomain:@"ble" code:VWWBLEErrorAlreadyConnected userInfo:nil];
        completion(NO, error);
        return;
    }
    
    
    // Start connection. Completed via delegate
    if (self.ble.peripherals)
        self.ble.peripherals = nil;
    
    [self.ble findBLEPeripherals:2];
    
    [NSTimer scheduledTimerWithTimeInterval:2.0
                                     block:^{
                                         if (self.ble.peripherals.count > 0){
                                             [self.ble connectPeripheral:[self.ble.peripherals objectAtIndex:0]];
                                             completion(YES, nil);
                                             
                                         }
                                         else{
                                             NSError *error = [NSError errorWithDomain:@"ble" code:VWWBLEErrorCouldNotConnect userInfo:nil];
                                             completion(NO, error);
                                         }

                                     } repeats:NO];
}


-(void)disconnectWithCompletionBlock:(VWWBLEControllerSuccessBlock)completion{
    NSLog(@"%s", __func__);
    // Disconnect if already connected
    if (self.ble.activePeripheral){
        if(self.ble.activePeripheral.isConnected){
            [[self.ble CM] cancelPeripheralConnection:[self.ble activePeripheral]];
            
            self.ble.peripherals = nil;
            self.ble.activePeripheral = nil;
            completion(YES, nil);
        }
    }
}

#pragma mark BLEDelegate (Optional)

-(void) bleDidConnect{
    NSLog(@"%s", __func__);
//    [self.delegate bleControllerDidConnect:self];
}
-(void) bleDidDisconnect{
    NSLog(@"%s", __func__);
    [self.delegate bleControllerDidDisconnect:self];
}
-(void) bleDidUpdateRSSI:(NSNumber *) rssi{
    NSLog(@"%s rssi: %@", __func__, rssi);
    [self.delegate bleController:self didUpdateRSSI:rssi];
}
-(void) bleDidReceiveData:(unsigned char *)data{
    NSLog(@"%s", __func__);
    [self.delegate bleController:self didReceiveData:[NSString stringWithFormat:@"%s", data]];
    
}

@end
