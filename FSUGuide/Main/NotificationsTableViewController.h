//
//  NotificationsTableViewController.h
//  FSUGuide
//
//  Created by Justin Block on 6/26/16.
//  Copyright © 2016 Justin Block. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NotificationsTableViewControllerDelegate <NSObject>

-(void)notificationTurnedOnWithTitle:(NSString *)title;
-(void)notificationTurnedOffWithTitle:(NSString *)title;

@end

@interface NotificationsTableViewController : UITableViewController <NotificationsTableViewControllerDelegate>

@end
