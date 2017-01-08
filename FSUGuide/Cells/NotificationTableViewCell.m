//
//  NotificationTableViewCell.m
//  FSUGuide
//
//  Created by Justin Block on 6/26/16.
//  Copyright © 2016 Justin Block. All rights reserved.
//

#import "NotificationTableViewCell.h"
#import "UIColor+FSUGuideColors.h"

@implementation NotificationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.notificationSwitch.onTintColor = [UIColor fsuGarnetColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/*
 When the user enables the notification
*/
- (IBAction)switchPressed:(UISwitch *)sender {
    // When turning the switch on set the notification
    if([sender isOn]) {
        [self.notificationsTableViewControllerDelegate notificationTurnedOnWithTitle:self.notificationTitle.text];
    } else {
        [self.notificationsTableViewControllerDelegate notificationTurnedOffWithTitle:self.notificationTitle.text];
    }
}
@end
