//
//  HomeTableViewController.m
//  FSUGuide
//
//  Created by Justin Block on 6/15/16.
//  Copyright © 2016 Justin Block. All rights reserved.
//

#import "HomeTableViewController.h"
#import "TodoTableViewCell.h"
#import "UIColor+FSUGuideColors.h"
#import "StudentTaskList.h"
#import "TaskWebViewController.h"
#import "CommonTipsTableViewCell.h"
#import <Parse/Parse.h>
#import "ThemedNavigationViewController.h"
#import "UpcomingEventsFeedParser.h"
#import "Gamification.h"
#import "URLBarButtonItem.h"

#define NUMBER_OF_SECTIONS 3
#define SECTION_NUM_FOR_COMMON_TIPS 0
#define SECTION_NUM_FOR_TASKS 1
#define SECTION_NUM_FOR_UPCOMING_EVENTS 2

@interface HomeTableViewController()
@property (strong, nonatomic) StudentTaskList* taskListHandler;
@property (strong, nonatomic) UpcomingEventsFeedParser* upcomingEventsFeedParser;
@property (nonatomic, strong) Gamification* gamification;
@end

@implementation HomeTableViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    // Makes the table view not cover up the status bar
    self.tableView.contentInset = UIEdgeInsetsMake(20.0f, 0.0f, 50.0f, 0.0f);
    
    self.taskListHandler = [[StudentTaskList alloc] initWithDelegate:self];
    self.upcomingEventsFeedParser = [[UpcomingEventsFeedParser alloc] initWithFSUFeed];
}

-(void)viewDidAppear:(BOOL)animated {
    // If we need to reload student tasks (to hide new student portions
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"shouldReloadStudentTasks"]) {
        [self.tableView reloadData];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"shouldReloadStudentTasks"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

/*
    Changes text of status bar at top (shows carrier information etc)
*/
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return NUMBER_OF_SECTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        // Common tips section
        case 0:
            return 1;
        break;
        // Tasks section
        case 1:
            return ([[NSUserDefaults standardUserDefaults] boolForKey:@"isNewStudent"]) ? [self.taskListHandler.todoItems count] : 0;
        break;
        // Upcoming events section
        case 2:
            return [self.upcomingEventsFeedParser.feedData count];
        break;
    }
    
    return 0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
     switch (section) {
         case SECTION_NUM_FOR_COMMON_TIPS:
            return @"Featured Tip";
        break;
        case SECTION_NUM_FOR_TASKS:
             return ([[NSUserDefaults standardUserDefaults] boolForKey:@"isNewStudent"]) ? @"New Student Tasks" : nil;
        break;
        case SECTION_NUM_FOR_UPCOMING_EVENTS:
             return @"Upcoming Events";
        break;
    }
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Common tips section
    if(indexPath.section == SECTION_NUM_FOR_COMMON_TIPS) {
        // NOTE - eventually make this a collection view and load tips from Parse
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CommonTipsCell" owner:self options:nil];
        CommonTipsTableViewCell *cell = [nib objectAtIndex:0];
        
        cell.tipTitle.text = @"Book Buying";
        cell.tipTextPreview.text = @"Don't buy books right away. Wait until the first day of class!";
        [cell.tipImage setImage: [UIImage imageNamed:@"bookBuyingTip"]];
        
        return cell;
    }
    // Tasks section
    else if(indexPath.section == SECTION_NUM_FOR_TASKS){
        // Loads the cell from the nib
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TodoCell" owner:self options:nil];
        TodoTableViewCell *cell = [nib objectAtIndex:0];
        cell.taskTitle.text = [[self.taskListHandler.todoItems objectAtIndex:indexPath.row] objectForKey:@"title"];
        [cell.taskTitle setFont:[UIFont systemFontOfSize:16]];
        cell.taskId = [[self.taskListHandler.todoItems objectAtIndex:indexPath.row] valueForKey:@"objectId"];
        cell.todoDelegate = self;
        
        // If the completedTodoItems contains the todo items object id its been completed
        if([[self.taskListHandler.completedTodoItems objectForKey:[[self.taskListHandler.todoItems objectAtIndex:indexPath.row] valueForKey:@"objectId"]] isEqual:[NSNumber numberWithBool:YES]]) {
            cell.isTaskComplete = YES;
            [cell.checkButton setBackgroundImage:[UIImage imageNamed:@"checkBoxChecked"] forState:UIControlStateNormal];
        } else {
            cell.isTaskComplete = NO;
            [cell.checkButton setBackgroundImage:[UIImage imageNamed:@"checkBoxEmpty"] forState:UIControlStateNormal];
        }
        
        return cell;
    }
    // Upcoming events section
    else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"upcomingEventsCell" forIndexPath:indexPath];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        cell.textLabel.text = [self.upcomingEventsFeedParser.feedData[indexPath.row] valueForKey:@"title"];
        cell.detailTextLabel.text = [self.upcomingEventsFeedParser.feedData[indexPath.row] valueForKey:@"startTime"];
        return cell;
    }
}
#pragma UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Text color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];
    
    // Background color of header
    view.tintColor = [UIColor fsuGarnetColor];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Change the height of the cells
    switch (indexPath.section) {
        case SECTION_NUM_FOR_COMMON_TIPS:
            return 100;
            break;
        case SECTION_NUM_FOR_TASKS:
            return 63;
            break;
        case SECTION_NUM_FOR_UPCOMING_EVENTS:
            return 60;
            break;
    }
    
    return 44; // Default value
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // If a task object is clicked
    if(indexPath.section == SECTION_NUM_FOR_TASKS) {
        [self performSegueWithIdentifier:@"displayPage" sender:self];
    } else if(indexPath.section == SECTION_NUM_FOR_UPCOMING_EVENTS) {
        [self performSegueWithIdentifier:@"displayUpcomingEvent" sender:self];
    }
}

#pragma Seguing
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"displayPage"]) {
        ThemedNavigationViewController* navController = (ThemedNavigationViewController *)segue.destinationViewController;
        TaskWebViewController* taskWebViewController = (TaskWebViewController*)navController.topViewController;
        
        // Increase users points
        [self.gamification increasePointsByDoubleValue:15];
        
        // Set navigation back button
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style: UIBarButtonItemStylePlain target:self action:@selector(closeViewController)];
        backButton.tintColor = [UIColor whiteColor];
        taskWebViewController.navigationItem.leftBarButtonItem = backButton;
        taskWebViewController.navigationItem.leftItemsSupplementBackButton = YES;
        [taskWebViewController setTitle:[[self.taskListHandler.todoItems objectAtIndex:[self.tableView indexPathForSelectedRow].row] valueForKey:@"title"]];
        
        // Set share button
        URLBarButtonItem *shareButton = [[URLBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                       target:taskWebViewController
                                                                                       action:@selector(shareURL:)];
        shareButton.url = [NSURL URLWithString:[self.taskListHandler getURLForTodoItemAtPosition:[self.tableView indexPathForSelectedRow].row]];
        shareButton.tintColor = [UIColor whiteColor];
        taskWebViewController.navigationItem.rightBarButtonItem = shareButton;
        
        // Set navigation complete button (if task isn't complete)
        if(![[self.taskListHandler.completedTodoItems objectForKey:[[self.taskListHandler.todoItems objectAtIndex:[self.tableView indexPathForSelectedRow].row] valueForKey:@"objectId"]] isEqual:[NSNumber numberWithBool:YES]]) {
            UIBarButtonItem *completeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"smallCheckBox"] style:UIBarButtonItemStylePlain target:self action:@selector(completeTask)];
            completeButton.tintColor = [UIColor whiteColor];
            
            // Set the complete button and share button as right bar button items
            taskWebViewController.navigationItem.rightBarButtonItems = @[completeButton, shareButton];
        }
        // Set just the share button as the right bar button item
        else {
            taskWebViewController.navigationItem.rightBarButtonItem = shareButton;
        }
        
        // Set the url to load
        taskWebViewController.urlToLoad = [self.taskListHandler getURLForTodoItemAtPosition:[self.tableView indexPathForSelectedRow].row];
    } else if ([[segue identifier] isEqualToString:@"displayUpcomingEvent"]) {
        ThemedNavigationViewController* navController = (ThemedNavigationViewController *)segue.destinationViewController;
        TaskWebViewController* taskWebViewController = (TaskWebViewController*)navController.topViewController;
        
        // Increase users points
        [self.gamification increasePointsByDoubleValue:10];
        
        // Set navigation back button
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style: UIBarButtonItemStylePlain target:self action:@selector(closeViewController)];
        backButton.tintColor = [UIColor whiteColor];
        taskWebViewController.navigationItem.leftBarButtonItem = backButton;
        taskWebViewController.navigationItem.leftItemsSupplementBackButton = YES;
        // Set the title
        [taskWebViewController setTitle:[self.upcomingEventsFeedParser.feedData[[self.tableView indexPathForSelectedRow].row] valueForKey:@"title"]];
        
        // Set share button
        URLBarButtonItem *shareButton = [[URLBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                     target:taskWebViewController
                                                                                       action:@selector(shareURL:)];
        shareButton.url = [NSURL URLWithString:[self.upcomingEventsFeedParser.feedData[[self.tableView indexPathForSelectedRow].row] valueForKey:@"link"]];
        shareButton.tintColor = [UIColor whiteColor];
        taskWebViewController.navigationItem.rightBarButtonItem = shareButton;
        
        // Set the url to load
        taskWebViewController.urlToLoad = [self.upcomingEventsFeedParser.feedData[[self.tableView indexPathForSelectedRow].row] valueForKey:@"link"];
    }
}

/*
   Marks task as complete
*/
-(void)completeTask {
    [self markTaskComplete:[self.taskListHandler getTaskIdForTodoItemAtPosition:[self.tableView indexPathForSelectedRow].row]];
    [self.tableView reloadData];
    [self closeViewController];
}

- (void)closeViewController
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma TodoTableDelegate
/*
 Marks the task completed on the parse backend
 */
-(void)markTaskComplete: (NSString *) taskId {
    [self.gamification increasePointsByDoubleValue:40];
    [self.taskListHandler shouldSetTaskAsComplete:YES forTaskId:taskId];
}

-(void) markTaskIncomplete: (NSString *) taskId; {
    [self.taskListHandler shouldSetTaskAsComplete:NO forTaskId:taskId];
}

-(BOOL) isTaskCurrentlyComplete: (NSString *) taskId {
    return YES;
}

-(void) reloadTable {
    [self.tableView reloadData];
}

#pragma Lazy Loading
-(Gamification *)gamification {
    if(_gamification == nil) {
        _gamification = [[Gamification alloc] init];
    }
    return _gamification;
}

@end
