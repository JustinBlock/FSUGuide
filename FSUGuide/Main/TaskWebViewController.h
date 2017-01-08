//
//  TaskWebViewController.h
//  FSUGuide
//
//  Created by Justin Block on 6/16/16.
//  Copyright © 2016 Justin Block. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "URLBarButtonItem.h"

@interface TaskWebViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSString* urlToLoad;

-(void)shareURL:(URLBarButtonItem*)sender;

@end
