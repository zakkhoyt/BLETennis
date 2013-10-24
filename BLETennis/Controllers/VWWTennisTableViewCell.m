//
//   VWWTennisTableViewCell.m
//  BLEPowerStrip
//
//  Created by Zakk Hoyt on 9/29/13.
//  Copyright (c) 2013 Zakk Hoyt. All rights reserved.
//

#import "VWWTennisTableViewCell.h"
#import "VWWTennisKeys.h"

@interface  VWWTennisTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *outletNameLabel;
@property (weak, nonatomic) IBOutlet UISwitch *outletSwitch;
@end

@implementation  VWWTennisTableViewCell

#pragma mark IBActions
- (IBAction)outletSwitchValueChanged:(UISwitch*)sender {
//    _outletState = sender.on;
    self.outlet[kStateKey] = sender.on ? @(0x01) : @(0x00);
    [self.delegate powerStripTableViewCell:self switchChangedState:sender.on];
}
#pragma mark Public methods

//-(void)setOutletState:(BOOL)outletState{
//    _outletState = outletState;
//    self.outletSwitch.on = _outletState;
//}
//
//-(void)setOutletName:(NSString *)outletName{
//    _outletName = outletName;
//    self.outletNameLabel.text = _outletName;
//}


-(void)setOutlet:(NSMutableDictionary *)outlet{
    _outlet = outlet;
    self.outletNameLabel.text = outlet[kNameKey];
    NSNumber *stateNumber = outlet[kStateKey];
    self.outletSwitch.on = stateNumber.integerValue == 0 ? 0x00 : 0x01;
}
@end
