//
//  MoreInformationViewController.m
//  FSUGuide
//
//  Created by Justin Block on 6/17/16.
//  Copyright © 2016 Justin Block. All rights reserved.
//

#import "MoreInformationViewController.h"
#import "UIColor+FSUGuideColors.h"

@interface MoreInformationViewController ()

@end

@implementation MoreInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.informationImage setImage:self.imageToLoad];
    [self.informationTitle setText:self.titleToLoad];
    
    [self.informationText setText:self.textToLoad];
    self.informationText.linkTextAttributes = @{NSForegroundColorAttributeName:[UIColor fsuGarnetColor]};
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setViewControllerWithImage:(UIImage *)image andTitle:(NSString *)title andMessageBody:(NSString *)messageBody {
    self.imageToLoad = image;
    self.titleToLoad = title;
    self.textToLoad = messageBody;
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
