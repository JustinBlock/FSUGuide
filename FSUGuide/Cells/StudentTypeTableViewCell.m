//
//  StudentTypeTableViewCell.m
//  FSUGuide
//
//  Created by Justin Block on 6/19/16.
//  Copyright © 2016 Justin Block. All rights reserved.
//

#import "StudentTypeTableViewCell.h"
#import "UIColor+FSUGuideColors.h"
#import "UIApplication+LocalNotificationHelper.h"

@implementation StudentTypeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.studentTypeSegmentedController.tintColor = [UIColor fsuGarnetColor];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL isNewUser = [defaults boolForKey:@"isNewStudent"];
    self.studentTypeSegmentedController.selectedSegmentIndex = (isNewUser) ? 0 : 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)studentTypeChanged:(id)sender {
    UISegmentedControl *segmentController = (UISegmentedControl *)sender;
    NSInteger selectedSegment = segmentController.selectedSegmentIndex;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // If user selected new student
    if(selectedSegment == 0) {
        [defaults setBool:YES forKey:@"isNewStudent"];
    }
    // If user selected existing student
    else if (selectedSegment == 1) {
        [defaults setBool:NO forKey:@"isNewStudent"];
        // Delete the notification for orientation reminders
        [[UIApplication sharedApplication] deleteOrientationReminderNotification];
    }
    [defaults setBool:YES forKey:@"shouldReloadStudentTasks"];
    [defaults synchronize];
    [self.profileTableViewDelegate reloadProfileTableView];
}

@end
