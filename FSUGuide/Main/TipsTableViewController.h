//
//  TipsTableViewController.h
//  FSUGuide
//
//  Created by Justin Block on 6/21/16.
//  Copyright © 2016 Justin Block. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@protocol TipsPageDelegate <NSObject>
-(void) displayAlert: (UIAlertController*)alert;
-(void) addPost: (PFObject *)object;
@end

@protocol TipsPostDelegate <NSObject>
-(void) showPopoverForPostAtRow:(NSIndexPath*)indexPath;
@end

@interface TipsTableViewController : PFQueryTableViewController <TipsPageDelegate, TipsPostDelegate, UITextFieldDelegate>

@end
