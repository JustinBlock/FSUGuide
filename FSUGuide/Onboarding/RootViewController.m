//
//  RootViewController.m
//  FSUGuide
//
//  Created by Justin Block on 6/15/16.
//  Copyright © 2016 Justin Block. All rights reserved.
//

#import "RootViewController.h"
#import <Parse/Parse.h>

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor fsuGarnetColor];

    // Style buttons
    [self styleFSUButton:self.brandNewStudentButton];
    [self styleFSUButton:self.existingStudentButton];
    
    // Creates an anonymous user in Parse
    [PFUser enableAutomaticUser];
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    }];
}

/*
 Changes text of status bar at top (shows carrier information etc)
 */
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)newStudentButttonPressed:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"isNewStudent"];
    [defaults setBool:YES forKey:@"isOnboardingComplete"];
    [defaults synchronize];
    [self performSegueWithIdentifier:@"segueToHomePage" sender:self];
}

- (IBAction)existingStudentButtonPressed:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:@"isNewStudent"];
    [defaults setBool:YES forKey:@"isOnboardingComplete"];
    [defaults synchronize];
    [self performSegueWithIdentifier:@"segueToHomePage" sender:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma Styling
- (void)styleFSUButton:(UIButton *)button {
    button.backgroundColor = [UIColor fsuGoldColor];
    button.contentEdgeInsets = UIEdgeInsetsMake(0.0f, 30.0f, 0.0f, 30.0f);
    [button setTitleColor:[UIColor fsuGarnetColor] forState:UIControlStateNormal];
}

@end
