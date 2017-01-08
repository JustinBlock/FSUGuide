//
//  StudentTaskList.h
//  FSUGuide
//
//  Created by Justin Block on 6/16/16.
//  Copyright © 2016 Justin Block. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeTableViewController.h"

@interface StudentTaskList : NSObject

@property (strong, nonatomic) NSArray* todoItems;
@property (strong, nonatomic) NSMutableDictionary* completedTodoItems;
@property (nonatomic, weak) id <TodoTableViewDelegate> todoTableViewDelegate;

// Functions
- (instancetype)initWithDelegate:(id) delegate;
-(void) retrieveStudentTasksProgress;
-(void) retrieveStudentTaskList;
-(void) shouldSetTaskAsComplete: (BOOL)taskCompletionStatus forTaskId: (NSString *) taskId;
-(NSString *)getURLForTodoItemAtPosition:(NSUInteger) position;
-(NSString *)getTaskIdForTodoItemAtPosition:(NSUInteger) position;

@end
