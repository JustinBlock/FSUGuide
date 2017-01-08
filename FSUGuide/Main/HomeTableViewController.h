//
//  HomeTableViewController.h
//  FSUGuide
//
//  Created by Justin Block on 6/15/16.
//  Copyright © 2016 Justin Block. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TodoTableViewDelegate <NSObject>

-(void) markTaskComplete: (NSString *) taskId;
-(void) markTaskIncomplete: (NSString *) taskId;
-(BOOL) isTaskCurrentlyComplete: (NSString *) taskId;
-(void) reloadTable;

@end

@interface HomeTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, TodoTableViewDelegate>

@end
