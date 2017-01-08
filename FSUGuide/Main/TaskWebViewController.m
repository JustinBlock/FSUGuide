//
//  TaskWebViewController.m
//  FSUGuide
//
//  Created by Justin Block on 6/16/16.
//  Copyright © 2016 Justin Block. All rights reserved.
//

#import "TaskWebViewController.h"
#import "SafariURLActivity.h"

@interface TaskWebViewController ()

@end

@implementation TaskWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated {
    [self.webView setScalesPageToFit:YES];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:_urlToLoad]];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 Give share options for the URL of the selected cell in the table view
 */
-(void)shareURL:(URLBarButtonItem*)sender {
    NSArray *safariAppActivity = [NSArray arrayWithObjects:[[SafariURLActivity alloc] init], nil];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]
                                                        initWithActivityItems:@[sender.url]
                                                        applicationActivities:safariAppActivity];
    [self presentViewController:activityViewController animated:YES completion:nil];
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
