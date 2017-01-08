//
//  ProfileTableViewController.h
//  FSUGuide
//
//  Created by Justin Block on 6/16/16.
//  Copyright © 2016 Justin Block. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProfileTableViewDelegate <NSObject>

-(void)reloadProfileTableView;
-(void)presentAlertUsingAlertController:(UIAlertController *)alertController;
-(void)showPopoverForSharingFSUPoints;

@end

@interface ProfileTableViewController : UITableViewController <ProfileTableViewDelegate>

@end
