//
//  StudentTypeTableViewCell.h
//  FSUGuide
//
//  Created by Justin Block on 6/19/16.
//  Copyright © 2016 Justin Block. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileTableViewController.h"

@interface StudentTypeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UISegmentedControl *studentTypeSegmentedController;
@property (nonatomic, weak) id <ProfileTableViewDelegate> profileTableViewDelegate;
@end
