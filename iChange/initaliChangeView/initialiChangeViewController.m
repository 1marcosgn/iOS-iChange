//
//  initialiChangeViewController.m
//  iChange
//
//  Created by Marcos Garcia on 7/24/14.
//  Copyright (c) 2014 Herbalife. All rights reserved.
//

#import "initialiChangeViewController.h"
#import "herbalifeLoginViewController.h"

@interface initialiChangeViewController ()

@end

@implementation initialiChangeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setViewItems];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)signUp:(id)sender {
    
    herbalifeLoginViewController *herbalifeLogIn = [[herbalifeLoginViewController alloc]initWithNibName:nil bundle:nil];
    herbalifeLogIn.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:herbalifeLogIn animated:YES completion:nil];
    
}


- (IBAction)goHerbalifeTerms:(id)sender {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://www.ichange.com/terms"]];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)setViewItems{
    
    [self.navigationController setNavigationBarHidden:YES];
    
    self.btnSignup.layer.cornerRadius = self.btnSignup.frame.size.height / 2;
    self.btnSignup.layer.masksToBounds = YES;
    
    self.viewLogin.layer.cornerRadius = self.viewLogin.frame.size.height / 2;
    self.viewLogin.layer.masksToBounds = YES;
    
    UIImage *backgroundImage = [UIImage imageNamed:@"backGreen.png"];
    UIColor *background = [[UIColor alloc]initWithPatternImage:backgroundImage];
    [self.view setBackgroundColor:background];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
    
}


@end
