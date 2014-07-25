//
//  iChangeViewController.m
//  iChange
//
//  Created by Marcos Garcia on 7/10/14.
//  Copyright (c) 2014 Herbalife. All rights reserved.
//

#import "iChangeViewController.h"
#import "SWRevealViewController.h"

@interface iChangeViewController ()

@end

@implementation iChangeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    
    
    [self.tabBarController.navigationController setNavigationBarHidden:YES];
    
    
    
    UIColor *backColor = [UIColor colorWithRed:151.0f/255.0f green:192.0f/255.0f blue:63.0f/255.0f alpha:1.0f];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Futura-medium" size:18], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithTitle:@"Settings" style:UIBarButtonItemStyleBordered target:self.revealViewController action:@selector(revealToggle:)];
    
    [cancelButton setTitleTextAttributes:attributes forState:UIControlStateNormal];

    self.navigationItem.leftBarButtonItem = cancelButton;
    
    
    
    self.navigationController.navigationBar.barTintColor = backColor;
    
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    [self.navigationItem setTitle:@"Home"];
    
    //[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    

    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}






@end
