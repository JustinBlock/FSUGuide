//
//  StudentTaskList.m
//  FSUGuide
//
//  Created by Justin Block on 6/16/16.
//  Copyright © 2016 Justin Block. All rights reserved.
//

#import "StudentTaskList.h"
#import <Parse/Parse.h>

@implementation StudentTaskList

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self retrieveStudentTaskList];
        [self retrieveStudentTasksProgress];
    }
    return self;
}

- (instancetype)initWithDelegate:(id) delegate
{
    self = [super init];
    if (self) {
        [self retrieveStudentTaskList];
        [self retrieveStudentTasksProgress];
        self.todoTableViewDelegate = delegate;
    }
    return self;
}

-(void) retrieveStudentTaskList {
    // Get todo items to show
    PFQuery *query = [PFQuery queryWithClassName:@"StudentTaskList"];
    // First loads the todo items from the cache then gets any updates from the network
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query whereKey:@"studentType" equalTo:@"NewStudent"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // Success
            self.todoItems = objects;
            [self.todoTableViewDelegate reloadTable];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

-(void) retrieveStudentTasksProgress {
    // Get todo items progress
    PFQuery *query = [PFQuery queryWithClassName:@"StudentTaskListProgress"];
    // First loads the todo items from the cache then gets any updates from the network
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // Success
            for (PFObject *object in objects) {
                [self.completedTodoItems setValue:[object objectForKey:@"completed"] forKey:[object objectForKey:@"taskId"]];
            }
            [self.todoTableViewDelegate reloadTable];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

#pragma Helper Functions
-(NSString *)getURLForTodoItemAtPosition:(NSUInteger) position {
    return [[self.todoItems objectAtIndex:position] valueForKey:@"taskURL"];
}

-(NSString *)getTaskIdForTodoItemAtPosition:(NSUInteger) position {
    return [[self.todoItems objectAtIndex:position] valueForKey:@"objectId"];
}

/*
 Helper function -
 If the task exists for the user already update it to either complete or not.
 Otherwise create a new entry for the task in the database.
 */
-(void) shouldSetTaskAsComplete: (BOOL)taskCompletionStatus forTaskId: (NSString *) taskId {
    // Mark status locally
    [self.completedTodoItems setValue:[NSNumber numberWithBool:taskCompletionStatus] forKey:taskId];
    
    // Query the table
    PFQuery *query = [PFQuery queryWithClassName:@"StudentTaskListProgress"];
    [query whereKey:@"taskId" equalTo:taskId];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    // Get the number of results
    [query countObjectsInBackgroundWithBlock:^(int number, NSError * _Nullable error) {
        // If it already exists just update it
        if(number != 0) {
            [query getFirstObjectInBackgroundWithBlock:^(PFObject * object, NSError *error) {
                if (!error) {
                    // If it already exists set it to completed
                    [object setObject:[NSNumber numberWithBool:taskCompletionStatus] forKey:@"completed"];
                    // Save
                    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                        if(error) {
                            NSLog(@"Error");
                        } else {
                            // If no error, ATM do nothing
                        }
                    }];
                } else {
                    // error
                    NSLog(@"%@", error);
                }
            }];
        } else if(number == 0) {
            // If did not find entry create one
            PFObject *studentTaskListProgressObject = [PFObject objectWithClassName:@"StudentTaskListProgress"];
            studentTaskListProgressObject[@"completed"] = [NSNumber numberWithBool:taskCompletionStatus];
            studentTaskListProgressObject[@"user"] = [PFUser currentUser];
            studentTaskListProgressObject[@"taskId"] = taskId;
            // Save
            [studentTaskListProgressObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if(!error) {
                    // If no error, ATM do nothing
                }
            }];
        } else if(error) {
            NSLog(@"Error");
        }
    }];
}

/*
 Lazy loading
 */
-(NSMutableDictionary *)completedTodoItems {
    if(_completedTodoItems == nil) {
        _completedTodoItems = [NSMutableDictionary dictionary];
    }
    return _completedTodoItems;
}

@end
