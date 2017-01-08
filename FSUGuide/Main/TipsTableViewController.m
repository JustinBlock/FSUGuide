//
//  TipsTableViewController.m
//  FSUGuide
//
//  Created by Justin Block on 6/21/16.
//  Copyright © 2016 Justin Block. All rights reserved.
//

#import "TipsTableViewController.h"
#import "UserPostTableViewCell.h"
#import "UIColor+FSUGuideColors.h"
#import "AddTipTableViewHeaderFooterView.h"
#import "Gamification.h"

#define SECTION_NUM_USER_POSTS_SECTION 0
#define NUM_SECTIONS 1

@interface TipsTableViewController ()
@property (nonatomic, strong) NSMutableArray* posts;
@property (nonatomic, strong) NSString* className;
@property (nonatomic, strong) AddTipTableViewHeaderFooterView* addTipTableViewHeaderFooterView;
@property (nonatomic, strong) Gamification* gamification;
@end

@implementation TipsTableViewController

- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        // The className to query
        self.className = @"Tips";
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = YES;
        self.objectsPerPage = 25;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Makes the table view not cover up the status bar
    self.tableView.contentInset = UIEdgeInsetsMake(20.0f, 0.0f, 50.0f, 0.0f);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorInset = UIEdgeInsetsMake(10.0f, 5.0f, 10.0f, 5.0f);
    self.tableView.separatorColor = [UIColor fsuGoldColor];
    [self styleRefreshController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PFQueryTableViewController

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    // This method is called every time objects are loaded from Parse via the PFQuery
    self.posts = [self.objects mutableCopy];
}

- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.className];
    
    // If Pull To Refresh is enabled, query against the network by default.
    if (self.pullToRefreshEnabled) {
        query.cachePolicy = kPFCachePolicyNetworkOnly;
    }
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }

    [query whereKey:@"approved" equalTo:[NSNumber numberWithBool:YES]];
    [query whereKey:@"deleted" equalTo:[NSNumber numberWithBool:NO]];
    // Order by created date
    [query orderByDescending:@"createdAt"];
    return query;
}

-(PFObject *)objectAtIndexPath:(NSIndexPath *)indexPath {
    PFObject* localObj = nil;
    if(indexPath.row < [self.objects count]) {
        localObj = self.objects[indexPath.row];
    }
    return localObj;
}

-(PFTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UserPostTableViewCell" owner:self options:nil];
    UserPostTableViewCell* cell = [nib objectAtIndex:0];
    cell.tipsPostDelegate = self;
    cell.userPostRow = indexPath;
    cell.title.text = [object valueForKey:@"title"];
    cell.timeSincePostedLabel.text = [NSString stringWithFormat:@"%@", [self timeSincePost:[object createdAt]]];
    
    return cell;
}

#pragma Reloading Table Data

-(void) styleRefreshController {
    // Initialize the refresh control.
    self.refreshControl.backgroundColor = [UIColor fsuGarnetColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
}

/*
 Changes text of status bar at top (shows carrier information etc)
 */
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Table View Header
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section == SECTION_NUM_USER_POSTS_SECTION) {
        UINib* nib = [UINib nibWithNibName:@"AddTipTableViewHeaderFooterView" bundle:nil];
        [self.tableView registerNib:nib forHeaderFooterViewReuseIdentifier:@"AddTipTableViewHeaderFooterView"];
        self.addTipTableViewHeaderFooterView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:@"AddTipTableViewHeaderFooterView"];
        self.addTipTableViewHeaderFooterView.tipsDelegate = self;
        return self.addTipTableViewHeaderFooterView;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == SECTION_NUM_USER_POSTS_SECTION) {
        return 44;
    }
    return 30;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return NUM_SECTIONS;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Change the height of the cells
    switch (indexPath.section) {
        case SECTION_NUM_USER_POSTS_SECTION:
            return 80;
            break;
    }
    
    return 44; // Default value
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    [self.addTipTableViewHeaderFooterView.addTipTextField resignFirstResponder];
}

#pragma Helper Functions

/*
 Returns the time since the last post
 
 Credits to http://stackoverflow.com/a/25618316
*/
-(NSString*)timeSincePost: (NSDate *) dateOfPost {
    NSString *timeSincePost;
    // Gets seconds since the post
    NSInteger seconds = [[NSDate date] timeIntervalSinceDate:dateOfPost] + 55;
    
    // Calculate number of days since post
    NSInteger days = (int) (floor(seconds / (3600 * 24)));
    if(days) seconds -= days * 3600 * 24;
    
    NSInteger hours = (int) (floor(seconds / 3600));
    if(hours) seconds -= hours * 3600;
    
    NSInteger minutes = (int) (floor(seconds / 60));
    if(minutes) seconds -= minutes * 60;
    
    // Incase the local time isn't equal to the server 0 seconds
    if(seconds < 0) { seconds = 0; }
    
    // Only show the largest time unit
    if(days) {
        timeSincePost = [NSString stringWithFormat:@"%ld days ago", (long)days];
    }
    else if(hours) {
        timeSincePost = [NSString stringWithFormat: @"%ld hours ago", (long)hours];
    }
    else if(minutes) {
        timeSincePost = [NSString stringWithFormat: @"%ld min ago",(long)minutes];
    }
    else {
        timeSincePost = [NSString stringWithFormat: @"%lds ago", (long)seconds];
    }
    
    return timeSincePost;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma Tips Page Delegate
-(void)displayAlert:(UIAlertController *)alert {
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)addPost:(PFObject *)object {
    [self.gamification increasePointsByDoubleValue:20];
    [self loadObjects];
}

#pragma TipsPostDelegate
-(void) showPopoverForPostAtRow:(NSIndexPath *)indexPath {
    NSInteger rowPos = indexPath.row;
    UIAlertController* additionalOptions = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* shareAction = [UIAlertAction
                                  actionWithTitle:@"Share"
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction * action) {
                                      UIActivityViewController *activityViewController = [[UIActivityViewController alloc]
                                                                                          initWithActivityItems:@[[self.posts[indexPath.row] valueForKey:@"title"]]
                                                                                          applicationActivities:nil];
                                      [self presentViewController:activityViewController animated:YES completion:nil];
                                  }];
    UIAlertAction* deleteAction = [UIAlertAction
                                   actionWithTitle:@"Delete"
                                   style:UIAlertActionStyleDestructive
                                   handler:^(UIAlertAction * action) {
//                                       // ENABLE FOR LOGGING IN FINAL VERSION
//                                       PFObject *object = [PFObject objectWithoutDataWithClassName:@"Tips"
//                                                                                          objectId:[self.posts[rowPos] valueForKey:@"objectId"]];
//                                       // Marks post as deleted
//                                       [object setObject:[NSNumber numberWithBool:YES] forKey:@"deleted"];
//                                       // Save
//                                       [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
//                                           [self loadObjects];
//                                       }];
//                                       // END ENABLE FOR LOGGING IN FINAL VERSION
                                       
                                         [self removeObjectAtIndexPath:indexPath];
                                   }];
    UIAlertAction* cancelAction = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction * action) {}];

    NSString* userIdOfPost = [[self.posts[rowPos] valueForKey:@"user"] valueForKey:@"objectId"];
    NSString* userIdOfOwner = [[PFUser currentUser] valueForKey:@"objectId"];
    [additionalOptions addAction:shareAction];
    if([userIdOfPost isEqualToString:userIdOfOwner]) {
        [additionalOptions addAction:deleteAction];
    }
    
    [additionalOptions addAction:cancelAction];
    [self presentViewController:additionalOptions animated:YES completion:nil];
}

#pragma UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

#pragma Lazy loading
-(NSMutableArray *)posts {
    if(_posts == nil) {
        _posts = [[NSMutableArray alloc] init];
    }
    return _posts;
}

#pragma Lazy Loading
-(Gamification *)gamification {
    if(_gamification == nil) {
        _gamification = [[Gamification alloc] init];
    }
    return _gamification;
}

@end
