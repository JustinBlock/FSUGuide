//
//  MainTabBarViewController.m
//  FSUGuide
//
//  Created by Justin Block on 6/16/16.
//  Copyright © 2016 Justin Block. All rights reserved.
//

#import "MainTabBarViewController.h"
#import "UIColor+FSUGuideColors.h"

@interface MainTabBarViewController ()

@end

@implementation MainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Tab bar style
    self.tabBar.barTintColor =  [UIColor fsuGarnetColor];
    [[UITabBar appearance] setTintColor:[UIColor fsuGoldColor]];
    
    // Set title colors
    [UITabBarItem.appearance setTitleTextAttributes: @{NSForegroundColorAttributeName : [UIColor whiteColor]}
                                           forState:UIControlStateNormal];
    [UITabBarItem.appearance setTitleTextAttributes: @{NSForegroundColorAttributeName : [UIColor fsuGoldColor]}
                                           forState:UIControlStateSelected];
    
    // Set tab bar image and colors
    UITabBar *tabBar = self.tabBar;
    // First tab
    UITabBarItem *tab = [tabBar.items objectAtIndex:0];
    tab.image = [[UIImage imageNamed:@"homeImage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tab.selectedImage = [[UIImage imageNamed:@"homeImage"]imageWithRenderingMode:UIImageRenderingModeAutomatic];
    // Second tab
    tab = [tabBar.items objectAtIndex:1];
    tab.image = [[UIImage imageNamed:@"exploreIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tab.selectedImage = [[UIImage imageNamed:@"exploreIcon"]imageWithRenderingMode:UIImageRenderingModeAutomatic];
    // Third tab
    tab = [tabBar.items objectAtIndex:2];
    tab.image = [[UIImage imageNamed:@"tipsIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tab.selectedImage = [[UIImage imageNamed:@"tipsIcon"]imageWithRenderingMode:UIImageRenderingModeAutomatic];
    // Fourth tab
    tab = [tabBar.items objectAtIndex:3];
    tab.image = [[UIImage imageNamed:@"profileTabBarIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tab.selectedImage = [[UIImage imageNamed:@"profileTabBarIcon"]imageWithRenderingMode:UIImageRenderingModeAutomatic];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
