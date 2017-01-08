//
//  NotificationTableViewCell.h
//  FSUGuide
//
//  Created by Justin Block on 6/26/16.
//  Copyright © 2016 Justin Block. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationsTableViewController.h"

@interface NotificationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *notificationTitle;
@property (weak, nonatomic) IBOutlet UISwitch *notificationSwitch;
@property (nonatomic) id<NotificationsTableViewControllerDelegate> notificationsTableViewControllerDelegate;

@end
