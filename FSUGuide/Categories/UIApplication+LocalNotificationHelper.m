//
//  UIApplication+LocalNotificationHelper.m
//  FSUGuide
//
//  Created by Justin Block on 6/26/16.
//  Copyright © 2016 Justin Block. All rights reserved.
//

#import "UIApplication+LocalNotificationHelper.h"

@implementation UIApplication (LocalNotificationHelper)

-(BOOL)deleteNotificationWithAlertTitle:(NSString *)alertTitle {
    // Goes through all the notifications to find the one with the alert title and cancels it
    for (UILocalNotification* notification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        if([notification.alertTitle isEqualToString:alertTitle]) {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
            return YES;
        }
    }
    return NO;
}

/*
    Removes the orientation reminder notification
*/
-(BOOL)deleteOrientationReminderNotification {
    return [self deleteNotificationWithAlertTitle:@"Orientation Reminder"];
}

/*
    Returns YES if notification exists with the alert title
*/
-(BOOL)doesNotificationExistWithAlertTitle:(NSString *)alertTitle {
    // Goes through all the notifications to find the one with the alert title and cancels it
    for (UILocalNotification* notification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        if([notification.alertTitle isEqualToString:alertTitle]) {
            return YES;
        }
    }
    return NO;
}

@end
