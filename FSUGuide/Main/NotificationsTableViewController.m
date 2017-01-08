//
//  NotificationsTableViewController.m
//  FSUGuide
//
//  Created by Justin Block on 6/26/16.
//  Copyright © 2016 Justin Block. All rights reserved.
//

#import "NotificationsTableViewController.h"
#import "NotificationTableViewCell.h"
#import "UIColor+FSUGuideColors.h"
#import "UIApplication+LocalNotificationHelper.h"

#define NUM_SECTIONS 1
#define NUM_ROWS_IN_NOTIFICATION_SECTION 2
#define NOTIFICATION_SECTION_NUM 0
#define ORIENTATION_REMINDER_TITLE @"Orientation Reminder"
#define EXPLORE_FSU_REMINDER_TITLE @"Explore FSU Reminder"

@interface NotificationsTableViewController ()
@property (nonatomic, strong) UISwitch* orientationSwitch;
@end

@implementation NotificationsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Makes the table view not cover up the status bar
    self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 50.0f, 0.0f);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return NUM_SECTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return NUM_ROWS_IN_NOTIFICATION_SECTION;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == NOTIFICATION_SECTION_NUM) {
        return nil;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Text color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];
    
    // Background color of header
    view.tintColor = [UIColor fsuGarnetColor];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    if(indexPath.section == NOTIFICATION_SECTION_NUM) {
        if(indexPath.row == 0) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NotificationTableViewCell" owner:self options:nil];
            NotificationTableViewCell *cell = [nib objectAtIndex:0];
            cell.notificationTitle.text = ORIENTATION_REMINDER_TITLE;
            cell.notificationsTableViewControllerDelegate = self;
            self.orientationSwitch = cell.notificationSwitch;
            // If the user isnt a new student disable the button (or orientation date is today)
            NSDate *orientationDate = [[NSUserDefaults standardUserDefaults] valueForKey:@"orientationDate"];
            if([[NSUserDefaults standardUserDefaults] boolForKey:@"isNewStudent"] == NO || [orientationDate timeIntervalSinceNow] < 0) {
                cell.notificationSwitch.enabled = NO;
                // Delete the notification as well
                [self notificationTurnedOffWithTitle:cell.notificationTitle.text];
                cell.notificationTitle.enabled = NO;
            }
            // If notification set
            if([[UIApplication sharedApplication] doesNotificationExistWithAlertTitle:ORIENTATION_REMINDER_TITLE]) {
                [cell.notificationSwitch setOn:YES];
            }
            return cell;
        }
        // Demo notification for class reminds user to explore fsu in 5 seconds
        else if(indexPath.row == 1) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NotificationTableViewCell" owner:self options:nil];
            NotificationTableViewCell *cell = [nib objectAtIndex:0];
            cell.notificationTitle.text = EXPLORE_FSU_REMINDER_TITLE;
            cell.notificationsTableViewControllerDelegate = self;
            // If notification set
            if([[UIApplication sharedApplication] doesNotificationExistWithAlertTitle:EXPLORE_FSU_REMINDER_TITLE]) {
                [cell.notificationSwitch setOn:YES];
            }
            return cell;
        }
    }
    
    return cell;
}

#pragma NotificationsTableViewControllerDelegate

/*
    Sets the notification based on the passed in notification title.
*/
-(void)notificationTurnedOnWithTitle:(NSString *)title {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // If user hasn't been prompted to enable notifications prompt them
    UIUserNotificationSettings *currentUserNotificationSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
    if(currentUserNotificationSettings.types == UIUserNotificationTypeNone) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Enable Notifications"
                                                                       message:@"To recieve notifications you will need to give FSU Guide permission. By clicking ok your phone will prompt you for permission. Would you like to continue?"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * action) {
                                                             [self.orientationSwitch setOn:NO]; // Shut off the switch since the user doesn't want to accept terms
                                                         }];
        UIAlertAction* yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  // Prompts the user to enable notifications
                                                                  if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
                                                                      [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound categories:nil]];
                                                                      [defaults setBool:YES forKey:@"userPromptedToEnableNotifications"];
                                                                  }
                                                              }];
        
        [alert addAction:noAction];
        [alert addAction:yesAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    // Set notification (if switch on)
    if([title isEqualToString:ORIENTATION_REMINDER_TITLE] && ![defaults boolForKey:@"orientationDate"]) {
            
        // Delete the notification for orientation reminders
        [[UIApplication sharedApplication] deleteOrientationReminderNotification];
            
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = [defaults valueForKey:@"orientationDate"]; //[NSDate dateWithTimeIntervalSinceNow:7]; // For testing
        notification.alertTitle = @"Orientation Reminder";
        notification.alertBody = @"Orientation is today!";
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.soundName = UILocalNotificationDefaultSoundName;
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    } else if([title isEqualToString:EXPLORE_FSU_REMINDER_TITLE]) {
        // Delete the notification if already exists
        [[UIApplication sharedApplication] deleteNotificationWithAlertTitle:EXPLORE_FSU_REMINDER_TITLE];
            
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:5]; // For testing
        notification.alertTitle = EXPLORE_FSU_REMINDER_TITLE;
        notification.alertBody = @"Check out the Explore FSU tab!";
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.soundName = UILocalNotificationDefaultSoundName;
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

-(void)notificationTurnedOffWithTitle:(NSString *)title {
    // Turn off the notification
    if([title isEqualToString:ORIENTATION_REMINDER_TITLE] && [[UIApplication sharedApplication] doesNotificationExistWithAlertTitle:ORIENTATION_REMINDER_TITLE]) {
        // Delete the notification for orientation reminders
        [[UIApplication sharedApplication] deleteOrientationReminderNotification];
    }
    else if([title isEqualToString:EXPLORE_FSU_REMINDER_TITLE] && [[UIApplication sharedApplication] doesNotificationExistWithAlertTitle:EXPLORE_FSU_REMINDER_TITLE]) {
        // Delete the notification to Explore FSU
        [[UIApplication sharedApplication] deleteNotificationWithAlertTitle:EXPLORE_FSU_REMINDER_TITLE];
    }
}


@end
