//
//  GamificationTableViewCell.h
//  FSUGuide
//
//  Created by Justin Block on 6/25/16.
//  Copyright © 2016 Justin Block. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileTableViewController.h"

@interface GamificationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (strong, nonatomic) id<ProfileTableViewDelegate> profileTableViewDelegate;
@end
