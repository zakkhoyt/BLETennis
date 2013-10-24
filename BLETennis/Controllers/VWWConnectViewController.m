//
//  VWWConnectViewController.m
//  BLEPowerStrip
//
//  Created by Zakk Hoyt on 9/29/13.
//  Copyright (c) 2013 Zakk Hoyt. All rights reserved.
//

#import "VWWConnectViewController.h"
#import "MBProgressHUD.h"
#import "VWWBLEController.h"

static NSString *kSegueConnectToPowerStrip = @"segueConnectToPowerStrip";

@interface VWWConnectViewController () <VWWBLEControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *infoTextView;
@property (weak, nonatomic) IBOutlet UIButton *connectButton;
@property (nonatomic, strong) VWWBLEController *bleController;
@end

@implementation VWWConnectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.bleController = [VWWBLEController sharedInstance];
    self.bleController.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark IBActions
- (IBAction)connectButtonTouchUpInside:(id)sender {
    
    if(self.bleController.connected){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.50];
        hud.labelText = @"Disconnecting from power strip...";
        [self.bleController disconnectWithCompletionBlock:^(BOOL success, NSError *error) {
            NSLog(@"Disonnected from Power Strip");
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.connectButton setTitle:@"Connect" forState:UIControlStateNormal];
        }];
        
    } else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.50];
        hud.labelText = @"Connecting to power strip...";
        
        [self.bleController connectWithCompletionBlock:^(BOOL success, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if(success){
                NSLog(@"Connected to Power Strip");
                [self.connectButton setTitle:@"Disconnect" forState:UIControlStateNormal];
                [self performSegueWithIdentifier:kSegueConnectToPowerStrip sender:self];
            } else {
                NSLog(@"Error connecting to Power Strip");
                [self.connectButton setTitle:@"Connect" forState:UIControlStateNormal];
            }
        }];
    }
    
    
}


#pragma mark VWWBLEControllerDelegate
-(void)bleControllerDidConnect:(VWWBLEController*)sender success:(BOOL)success{
    if(success){
        
    }
    else{
        
    }
}
-(void)bleControllerDidDisconnect:(VWWBLEController*)sender{
    
}
-(void)bleController:(VWWBLEController*)sender didUpdateRSSI:(NSNumber*)rssi{
    
}
-(void)bleController:(VWWBLEController*)sender didReceiveData:(NSString*)data{
    
}


@end
