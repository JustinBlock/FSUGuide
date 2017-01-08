//
//  ExploreTableViewController.m
//  FSUGuide
//
//  Created by Justin Block on 6/17/16.
//  Copyright © 2016 Justin Block. All rights reserved.
//

#import "ExploreTableViewController.h"
#import "PointsOfInterestTableViewCell.h"
#import "UIColor+FSUGuideColors.h"
#import "MoreInformationViewController.h"
#import "ThemedNavigationViewController.h"
#import "Gamification.h"

#define NUMBER_OF_SECTIONS 2
#define SECTION_NUM_FOR_POINTS_OF_INTEREST 0
#define SECTION_NUM_FOR_MORE_INFORMATION 1

@interface ExploreTableViewController ()
@property (nonatomic) NSArray* informationArticles;
@property (nonatomic, strong) Gamification* gamification;
@end

@implementation ExploreTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Makes the table view not cover up the status bar
    self.tableView.contentInset = UIEdgeInsetsMake(20.0f, 0.0f, 50.0f, 0.0f);
}

-(void)viewDidAppear:(BOOL)animated {
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return NUMBER_OF_SECTIONS;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case SECTION_NUM_FOR_POINTS_OF_INTEREST:
            return @"Points of Interest";
            break;
        case SECTION_NUM_FOR_MORE_INFORMATION:
            return @"More Information";
            break;
    }
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case SECTION_NUM_FOR_POINTS_OF_INTEREST:
            return 1;
            break;
        case SECTION_NUM_FOR_MORE_INFORMATION:
            return [self.informationArticles count];
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // If point of interest
    if(indexPath.section == SECTION_NUM_FOR_POINTS_OF_INTEREST) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PointsOfInterestTableViewCell" owner:self options:nil];
        PointsOfInterestTableViewCell *cell = [nib objectAtIndex:0];
        return cell;
    }
    // If more information section
    else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"exploreCell" forIndexPath:indexPath];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        cell.textLabel.text = [[self.informationArticles objectAtIndex:indexPath.row] valueForKey:@"title"];
        return cell;
    }
}

#pragma UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Change the height of the cells
    switch (indexPath.section) {
        case SECTION_NUM_FOR_POINTS_OF_INTEREST:
            return 245;
            break;
        case SECTION_NUM_FOR_MORE_INFORMATION:
            return 44;
            break;
    }
    
    return 44; // Default value
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Text color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];
    
    // Background color of header
    view.tintColor = [UIColor fsuGarnetColor];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // If a more information object is clicked
    if(indexPath.section == SECTION_NUM_FOR_MORE_INFORMATION) {
        [self performSegueWithIdentifier:@"exploreFSUDetailSegue" sender:self];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"exploreFSUDetailSegue"]) {
        ThemedNavigationViewController* navController = (ThemedNavigationViewController *)segue.destinationViewController;
        MoreInformationViewController* moreInformationViewController = (MoreInformationViewController*)navController.topViewController;
        
        // Sets the title
        [moreInformationViewController setTitle:[[self.informationArticles
                                                 objectAtIndex:[self.tableView indexPathForSelectedRow].row] valueForKey:@"title"]];
        
        // Set navigation back button
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style: UIBarButtonItemStylePlain target:self action:@selector(closeViewController)];
        backButton.tintColor = [UIColor whiteColor];
        moreInformationViewController.navigationItem.leftBarButtonItem = backButton;
        moreInformationViewController.navigationItem.leftItemsSupplementBackButton = YES;
        [moreInformationViewController setViewControllerWithImage:[UIImage imageNamed:[[self.informationArticles
                                                                                        objectAtIndex:[self.tableView indexPathForSelectedRow].row] valueForKey:@"imageName"]]
                                                         andTitle:[[self.informationArticles
                                                                    objectAtIndex:[self.tableView indexPathForSelectedRow].row] valueForKey:@"title"]
                                                   andMessageBody:[[self.informationArticles
                                                                    objectAtIndex:[self.tableView indexPathForSelectedRow].row] valueForKey:@"textBody"]];
    }
}

- (IBAction)closeViewController
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma Lazy loading
-(NSArray *)informationArticles {
    if(_informationArticles == nil) {
        _informationArticles = [[NSArray alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"MoreInformationArticles" ofType:@"plist"]];
    }
    return _informationArticles;
}

-(Gamification *)gamification {
    if(_gamification == nil) {
        _gamification = [[Gamification alloc] init];
    }
    return _gamification;
}


@end
