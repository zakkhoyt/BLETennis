//
//   VWWTennisTableViewCell.h
//  BLEPowerStrip
//
//  Created by Zakk Hoyt on 9/29/13.
//  Copyright (c) 2013 Zakk Hoyt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  VWWTennisTableViewCell;

@protocol  VWWTennisTableViewCellDelegate <NSObject>
-(void)powerStripTableViewCell:( VWWTennisTableViewCell*)sender switchChangedState:(BOOL)on;
@end

@interface  VWWTennisTableViewCell : UITableViewCell
@property (nonatomic, weak) id < VWWTennisTableViewCellDelegate> delegate;

@property (nonatomic, strong) NSMutableDictionary *outlet;
@end
