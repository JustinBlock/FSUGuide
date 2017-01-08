//
//  AddTipTableViewHeaderFooterView.h
//  FSUGuide
//
//  Created by Justin Block on 6/24/16.
//  Copyright © 2016 Justin Block. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TipsTableViewController.h"
#import <ParseUI/ParseUI.h>

@interface AddTipTableViewHeaderFooterView : UITableViewHeaderFooterView
@property (weak, nonatomic) id<TipsPageDelegate> tipsDelegate;
@property (weak, nonatomic) IBOutlet UITextField *addTipTextField;
@property (weak, nonatomic) IBOutlet UIButton *addTipButton;


@end
