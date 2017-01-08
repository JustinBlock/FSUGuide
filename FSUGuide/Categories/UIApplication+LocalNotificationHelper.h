//
//  UIApplication+LocalNotificationHelper.h
//  FSUGuide
//
//  Created by Justin Block on 6/26/16.
//  Copyright © 2016 Justin Block. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (LocalNotificationHelper)

-(BOOL)deleteNotificationWithAlertTitle:(NSString *)alertTitle;
-(BOOL)deleteOrientationReminderNotification;
-(BOOL)doesNotificationExistWithAlertTitle:(NSString *)alertTitle;

@end
