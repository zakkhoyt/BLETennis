//
//   VWWTennisViewController.m
//  BLEPowerStrip
//
//  Created by Zakk Hoyt on 9/29/13.
//  Copyright (c) 2013 Zakk Hoyt. All rights reserved.
//

#import "VWWTennisViewController.h"
#import "MBProgressHUD.h"
#import "VWWBLEController.h"
#import "VWWTennisKeys.h"
#import "VWWTennisTableViewCell.h"

@interface  VWWTennisViewController () <VWWBLEControllerDelegate,  VWWTennisTableViewCellDelegate>
@property (nonatomic, strong) VWWBLEController *bleController;
@property (weak, nonatomic) IBOutlet UILabel *rssiLabel;
@property (weak, nonatomic) IBOutlet UISwitch *pin4Switch;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *outlets;
@end

@implementation  VWWTennisViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	self.bleController = [VWWBLEController sharedInstance];
    self.outlets = [@[]mutableCopy];
    [self buildOutlets];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.bleController.delegate = self;
    
    self.pin4Switch.on = NO;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}


#pragma mark Private methods

-(void)buildOutlets{
    
    for(NSInteger index = 0; index < 8; index++){
        NSMutableDictionary *outlet = [@{kNameKey : [NSString stringWithFormat:@"Outlet %ld", (long)index],
                                     kIndexKey : @(index),
                                     kStateKey : @(0)}mutableCopy];
        
        [self.outlets addObject:outlet];
    }
}


#pragma mark IBActions
- (IBAction)disconnectButtonTouchUpInside:(id)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.50];
    hud.labelText = @"Disconnecting from power strip...";

    [self.bleController disconnectWithCompletionBlock:^(BOOL success, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

//- (IBAction)pin4SwitchValueChanged:(UISwitch*)sender {
//    [self.bleController setDigitalState:sender.on ? 0x01 : 0x00 forPin:0x04];
//}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.outlets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     VWWTennisTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VWWTennisTableViewCell"];
    cell.outlet = self.outlets[indexPath.row];
    cell.delegate = self;
    return cell;
}







#pragma mark VWWBLEControllerDelegate
-(void)bleControllerDidConnect:(VWWBLEController*)sender success:(BOOL)success{
    if(success){
        
    }
    else{
        
    }
}
-(void)bleControllerDidDisconnect:(VWWBLEController*)sender{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)bleController:(VWWBLEController*)sender didUpdateRSSI:(NSNumber*)rssi{
    self.rssiLabel.text = [NSString stringWithFormat:@"Signal strength: %ld", (long)rssi.floatValue];
}
-(void)bleController:(VWWBLEController*)sender didReceiveData:(NSString*)data{
    
}

#pragma mark  VWWTennisTableViewCellDelegate <NSObject>
-(void)powerStripTableViewCell:( VWWTennisTableViewCell*)sender switchChangedState:(BOOL)on{
    NSMutableDictionary *outlet = sender.outlet;
    NSInteger state = ((NSNumber*)outlet[kStateKey]).integerValue;
    NSInteger pin = ((NSNumber*)outlet[kIndexKey]).integerValue;
    [self.bleController setDigitalState:state forPin:pin];
}



@end
