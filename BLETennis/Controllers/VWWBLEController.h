//
//  VWWBLEController.h
//  BLEPowerStrip
//
//  Created by Zakk Hoyt on 9/29/13.
//  Copyright (c) 2013 Zakk Hoyt. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VWWBLEController;

__attribute ((unused)) static NSInteger VWWBLEErrorCouldNotConnect = 1;
__attribute ((unused)) static NSInteger VWWBLEErrorAlreadyConnected = 2;

typedef void (^VWWBLEControllerSuccessBlock)(BOOL success, NSError *error);

@protocol VWWBLEControllerDelegate <NSObject>
-(void)bleControllerDidConnect:(VWWBLEController*)sender success:(BOOL)success;
-(void)bleControllerDidDisconnect:(VWWBLEController*)sender;
-(void)bleController:(VWWBLEController*)sender didUpdateRSSI:(NSNumber*)rssi;
-(void)bleController:(VWWBLEController*)sender didReceiveData:(NSString*)data;
@end

@interface VWWBLEController : NSObject
+(VWWBLEController*)sharedInstance;
-(void)connectWithCompletionBlock:(VWWBLEControllerSuccessBlock)completion;
-(void)disconnectWithCompletionBlock:(VWWBLEControllerSuccessBlock)completion;
-(void)setDigitalState:(NSInteger)state forPin:(NSInteger)pin;
@property (nonatomic, weak) id <VWWBLEControllerDelegate> delegate;
@property (nonatomic) BOOL connected;
@end
