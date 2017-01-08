//
//  TodoTableViewCell.h
//  FSUGuide
//
//  Created by Justin Block on 6/15/16.
//  Copyright © 2016 Justin Block. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeTableViewController.h"

@interface TodoTableViewCell : UITableViewCell

@property (nonatomic, weak) id <TodoTableViewDelegate> todoDelegate;
@property (weak, nonatomic) IBOutlet UITextView *taskTitle;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (strong, nonatomic) NSString* taskId;
@property (nonatomic) BOOL isTaskComplete;

@end
