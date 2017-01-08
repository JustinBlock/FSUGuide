//
//  OrientationTableViewCell.h
//  FSUGuide
//
//  Created by Justin Block on 6/19/16.
//  Copyright © 2016 Justin Block. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrientationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *daysLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayOfTheWeekLabel;
@property (weak, nonatomic) IBOutlet UILabel *fullDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *daysLeftTitleLabel;

@end
