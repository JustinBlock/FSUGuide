//
//  UserPostTableViewCell.h
//  FSUGuide
//
//  Created by Justin Block on 6/22/16.
//  Copyright © 2016 Justin Block. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TipsTableViewController.h"
#import <ParseUI/ParseUI.h>

@interface UserPostTableViewCell : PFTableViewCell
@property (weak, nonatomic) IBOutlet UITextView *title;
@property (nonatomic, strong) NSIndexPath* userPostRow;
@property (nonatomic) id<TipsPostDelegate> tipsPostDelegate;
@property (weak, nonatomic) IBOutlet UILabel *timeSincePostedLabel;

@end
