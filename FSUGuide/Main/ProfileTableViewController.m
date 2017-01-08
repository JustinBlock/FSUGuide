//
//  ProfileTableViewController.m
//  FSUGuide
//
//  Created by Justin Block on 6/16/16.
//  Copyright © 2016 Justin Block. All rights reserved.
//

#import "ProfileTableViewController.h"
#import "UIColor+FSUGuideColors.h"
#import "OrientationTableViewCell.h"
#import "StudentTypeTableViewCell.h"
#import "LogoutTableViewCell.h"
#import "GamificationTableViewCell.h"
#import "Gamification.h"
#import "ThemedNavigationViewController.h"
#import "NotificationsTableViewController.h"

#define NUM_SECTIONS 3
#define SECTION_NUM_FOR_GAMIFICATION_SECTION 0
#define SECTION_NUM_FOR_ORIENTATION_SECTION 1
#define SECTION_NUM_FOR_ADDITIONAL_SECTION 2
#define NUM_ROWS_IN_GAMIFICATION_SECTION 1
#define NUM_ROWS_IN_ADDITIONAL_SECTION 4

// Additional section cells
#define NOTIFICATIONS_CELL_ROW_NUM 1
#define SEPERATOR_CELL_ROW_NUM 2
#define LOGOUT_CELL_ROW_NUM 3

@interface ProfileTableViewController ()
@property (nonatomic, strong) Gamification* gamification;
@end

@implementation ProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Makes the table view not cover up the status bar
    self.tableView.contentInset = UIEdgeInsetsMake(20.0f, 0.0f, 50.0f, 0.0f);
}

-(void)viewDidAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 Changes text of status bar at top (shows carrier information etc)
 */
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Change the height of the cells
    switch (indexPath.section) {
        case SECTION_NUM_FOR_GAMIFICATION_SECTION:
            return 44;
            break;
        case SECTION_NUM_FOR_ORIENTATION_SECTION:
            return 145;
            break;
        case SECTION_NUM_FOR_ADDITIONAL_SECTION:
            return 45;
            break;
    }
    
    return 44; // Default value
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case SECTION_NUM_FOR_GAMIFICATION_SECTION:
            return nil;
            break;
        case SECTION_NUM_FOR_ORIENTATION_SECTION:
            return ([[NSUserDefaults standardUserDefaults] boolForKey:@"isNewStudent"]) ? @"Orientation Countdown" : nil;
            break;
        case SECTION_NUM_FOR_ADDITIONAL_SECTION:
            return @"Settings";
            break;
    }
    return @"";
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Text color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];
    
    // Background color of header
    view.tintColor = [UIColor fsuGarnetColor];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return NUM_SECTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == SECTION_NUM_FOR_GAMIFICATION_SECTION) {
        return NUM_ROWS_IN_GAMIFICATION_SECTION;
    }
    else if(section == SECTION_NUM_FOR_ORIENTATION_SECTION) {
        return ([[NSUserDefaults standardUserDefaults] boolForKey:@"isNewStudent"]) ? 1 : 0;
    } else {
        return NUM_ROWS_IN_ADDITIONAL_SECTION;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if(indexPath.section == SECTION_NUM_FOR_GAMIFICATION_SECTION) {
        // If account type cell
        if(indexPath.row == 0) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GamificationTableViewCell" owner:self options:nil];
            GamificationTableViewCell *cell = [nib objectAtIndex:0];
            cell.profileTableViewDelegate = self;
            return cell;
        }
    }
    else if(indexPath.section == SECTION_NUM_FOR_ORIENTATION_SECTION) {
        // If account type cell
        if(indexPath.row == 0) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OrientationTableViewCell" owner:self options:nil];
            OrientationTableViewCell *cell = [nib objectAtIndex:0];
            return cell;
        }
    }
    // Configuring the cell
    else if(indexPath.section == SECTION_NUM_FOR_ADDITIONAL_SECTION) {
        // If account type cell
        if(indexPath.row == 0) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"StudentTypeTableViewCell" owner:self options:nil];
            StudentTypeTableViewCell *cell = [nib objectAtIndex:0];
            cell.profileTableViewDelegate = self;
            return cell;
        }
        // If notification cell
        else if(indexPath.row == NOTIFICATIONS_CELL_ROW_NUM) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pageTransitionCell" forIndexPath:indexPath];
            cell.textLabel.text = @"Notifications";
            return cell;
        }
        // If seperator cell
        else if(indexPath.row == SEPERATOR_CELL_ROW_NUM) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"profileCell" forIndexPath:indexPath];
            return cell;
        }
        // If logout button
        else if(indexPath.row == LOGOUT_CELL_ROW_NUM) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LogoutTableViewCell" owner:self options:nil];
            LogoutTableViewCell *cell = [nib objectAtIndex:0];
            return cell;
        }
    }
    
    return cell;
}

#pragma Table View Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == SECTION_NUM_FOR_ORIENTATION_SECTION) {
        // Orientation countdown
        if(indexPath.row == 0) {
            [self createOrientationAlert];
        }
    }
    else if(indexPath.section == SECTION_NUM_FOR_ADDITIONAL_SECTION) {
        // Logout button
        if(indexPath.row == LOGOUT_CELL_ROW_NUM) {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Reset App"
                                                                           message:@"Are you sure you want to reset the FSU Guide app?"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel
                                                              handler:^(UIAlertAction * action) {}];
            UIAlertAction* yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {
                                                                      // Resets the standard default settings to Apple default
                                                                      [[NSUserDefaults standardUserDefaults] setPersistentDomain:[NSDictionary dictionary] forName:[[NSBundle mainBundle] bundleIdentifier]];
                                                                      [self performSegueWithIdentifier:@"segueToOnboardingScreen" sender:self];
                                                                  }];
            
            [alert addAction:noAction];
            [alert addAction:yesAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else if(indexPath.row == NOTIFICATIONS_CELL_ROW_NUM) {
            [self performSegueWithIdentifier:@"showNotificationsPageSegue" sender:self];
        }
    }
}

-(void)createOrientationAlert {
    // Create alert box
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // Gets orientation date if one
    NSDate *orientationDate = [defaults objectForKey:@"orientationDate"];
    
    // Credits to http://stackoverflow.com/a/31912541 for creating a datepicker in an alertcontroller
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIDatePicker *picker = [[UIDatePicker alloc] init];
    [picker setDatePickerMode:UIDatePickerModeDate];
    [alertController.view addSubview:picker];
    NSDate *todaysDate = [NSDate date];
    // If orientation day is set, set that as the picker date value
    if(orientationDate != nil) {
        [picker setDate:orientationDate];
    }
    [picker setMinimumDate:todaysDate];
    [alertController addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            // Sets the oreitnation date in nsuserdefaults
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:picker.date forKey:@"orientationDate"];
            [defaults synchronize];
            [self.gamification increasePointsByDoubleValue:5];
            [self.tableView reloadData];
        }];
        action;
    })];
    [alertController addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        }];
        action;
    })];
    // To support iPad
    alertController.popoverPresentationController.sourceView = self.view;
    
    [self presentViewController:alertController  animated:YES completion:nil];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"showNotificationsPageSegue"]) {
        ThemedNavigationViewController* navController = (ThemedNavigationViewController *)segue.destinationViewController;
        NotificationsTableViewController* notificationsTableViewController = (NotificationsTableViewController*)navController.topViewController;
        
        // Increase users points
        [self.gamification increasePointsByDoubleValue:10];
        
        // Set navigation back button
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style: UIBarButtonItemStylePlain target:self action:@selector(closeViewController)];
        backButton.tintColor = [UIColor whiteColor];
        notificationsTableViewController.navigationItem.leftBarButtonItem = backButton;
        notificationsTableViewController.navigationItem.leftItemsSupplementBackButton = YES;
        [notificationsTableViewController setTitle:@"Notifications"];
    }
}

- (void)closeViewController
{
    [self dismissViewControllerAnimated:NO completion:nil];
}


#pragma ProfileTableViewDelegate
-(void)reloadProfileTableView {
    [self.tableView reloadData];
}

-(void)presentAlertUsingAlertController:(UIAlertController *)alertController {
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)showPopoverForSharingFSUPoints {
    UIAlertController* additionalOptions = [UIAlertController alertControllerWithTitle:nil
                                                                               message:nil
                                                                        preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* shareAction = [UIAlertAction
                                  actionWithTitle:@"Share"
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction * action) {
                                      UIActivityViewController *activityViewController = [[UIActivityViewController alloc]
                                                                                          initWithActivityItems:@[[UIImage imageNamed:@"fsuPoints"], [NSString stringWithFormat:@"I've got %ld FSU Points on the FSU Guide app!", self.gamification.points]]
                                                                                          applicationActivities:nil];
                                      [self presentViewController:activityViewController animated:YES completion:nil];
                                  }];
    UIAlertAction* cancelAction = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction * action) {}];
    [additionalOptions addAction:shareAction];
    [additionalOptions addAction:cancelAction];
    [self presentViewController:additionalOptions animated:YES completion:nil];
}

#pragma Lazy Loading
-(Gamification *)gamification {
    if(_gamification == nil) {
        _gamification = [[Gamification alloc] init];
    }
    return _gamification;
}

@end
