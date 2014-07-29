//
//  herbalifeLoginViewController.m
//  iChange
//
//  Created by Marcos Garcia on 7/11/14.
//  Copyright (c) 2014 Herbalife. All rights reserved.
//

#import "herbalifeLoginViewController.h"
#import "SBJsonWriter.h"
#import "userDetailsViewController.h"

@interface herbalifeLoginViewController (){
    NSString *theToken;
}
@end

@implementation herbalifeLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
}

- (IBAction)loginAction:(id)sender {
    
    if ([self loginParametersCorrect]) {
        [self dismissKeyboard];
        
        //New 'ConnectionViewController' instance to manage the web service connections
        ConnectionViewController *connection = [[ConnectionViewController alloc]init];
        [connection setDelegate:self];
        [self.view insertSubview:connection.view atIndex:[[self.view subviews]count]];
        [connection start];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        NSMutableDictionary *paramFinal = [NSMutableDictionary dictionary];
        SBJsonWriter *JSONWriter = [SBJsonWriter alloc];
        
        [params setValue:self.txtDistributorID.text forKeyPath:@"dsid"];
        [params setValue:self.txtDistributorPIN.text forKeyPath:@"pin"];
        [paramFinal setObject:params forKey:@"data"];
        
        NSString *prevString = [JSONWriter stringWithObject:paramFinal];
        NSData *jsonData = [prevString dataUsingEncoding:NSUTF8StringEncoding];
        [connection executeService:@"hlf_login" withData:jsonData type:@"POST" headers:nil];
    }
    else{
        UIAlertView *alertLogin = [[UIAlertView alloc]initWithTitle:nil message:@"Please enter a Distributor ID and PIN to continue." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertLogin show];
    }
    
}

- (IBAction)goToLogin:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)gotoTerms:(id)sender {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://www.ichange.com/terms"]];
}

-(void)setViewItems{
    
    [self.viewContainer setBackgroundColor:[UIColor clearColor]];
    [self.txtDistributorID setDelegate:self];
    [self.txtDistributorPIN setDelegate:self];

    UIImage *backgroundImage = [UIImage imageNamed:@"backSignup.png"];
    UIColor *backgorund = [[UIColor alloc] initWithPatternImage:backgroundImage];
    [self.view setBackgroundColor:backgorund];
    
    UITapGestureRecognizer *gestureDismiss = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:gestureDismiss];
    
    
    self.btnLogin.layer.cornerRadius = self.btnLogin.frame.size.height / 2;
    self.btnLogin.layer.masksToBounds = YES;
    
    [self.txtDistributorID setBackgroundColor:[UIColor clearColor]];
    [self.txtDistributorPIN setBackgroundColor:[UIColor clearColor]];
    
    UIColor *color = [UIColor whiteColor];
    
    self.txtDistributorID.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"iChange Username" attributes:@{NSForegroundColorAttributeName: [color colorWithAlphaComponent:0.4]}];
    
    self.txtDistributorPIN.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: [color colorWithAlphaComponent:0.4]}];
    
    [self.txtDistributorPIN.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.txtDistributorPIN.layer setBorderWidth:2.0f];
    self.txtDistributorPIN.layer.cornerRadius = self.txtDistributorPIN.frame.size.height / 2;
    self.txtDistributorPIN.layer.masksToBounds = YES;
    
    [self.txtDistributorID.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.txtDistributorID.layer setBorderWidth:2.0f];
    self.txtDistributorID.layer.cornerRadius = self.txtDistributorID.frame.size.height / 2;
    self.txtDistributorID.layer.masksToBounds = YES;
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    
    UINavigationBar *navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 55)];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Futura-medium" size:18], NSFontAttributeName, [UIColor grayColor], NSForegroundColorAttributeName, nil];
    NSDictionary *attributesTitle = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Futura-medium" size:18], NSFontAttributeName, [UIColor grayColor], NSForegroundColorAttributeName, nil];
    
    //UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
    
    //backButton.tintColor = [UIColor whiteColor];
    //[backButton setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"backArrow.png"] forState:UIControlStateNormal];
    button.frame=CGRectMake(0,0, 29, 29);
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.leftBarButtonItem = backButton;
    
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    UINavigationItem *itemNext = [[UINavigationItem alloc]initWithTitle:@"Sign Up"];
    
    itemNext.leftBarButtonItem = backButton;
    navBar.items = [NSArray arrayWithObject:itemNext];
    [navBar setTitleTextAttributes:attributesTitle];
    
    navBar.barStyle = UIBarStyleBlackTranslucent;
    
    [navBar setOpaque:NO];
    
    [self.view addSubview:navBar];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
    [swipeRight setDirection:(UISwipeGestureRecognizerDirectionRight)];
    
    [self.view addGestureRecognizer:swipeRight];

    
    
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
    
}

-(void)back{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.35;
    transition.timingFunction =
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromLeft;
    
    UIView *containerView = self.view.window;
    [containerView.layer addAnimation:transition forKey:nil];
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    
    [self.txtDistributorPIN setText:@""];
    
}

#pragma mark - UITextField Delegates
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [self animationMoveTo:@"UP"];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.txtDistributorID resignFirstResponder];
    [self.txtDistributorPIN resignFirstResponder];
    [self animationMoveTo:@"DOWN"];
    return YES;
    
}

-(void)dismissKeyboard{
    
    [self.txtDistributorID resignFirstResponder];
    [self.txtDistributorPIN resignFirstResponder];
    [self animationMoveTo:@"DOWN"];
    
}


#pragma mark - Animations
-(void)animationMoveTo:(NSString *)moveTo{
    
    int positionY = 210;
    if ([moveTo isEqualToString:@"UP"]) {
        positionY = 141;
    }
    else if ([moveTo isEqualToString:@"DOWN"]){
        positionY = 210;
    }
    [UIView animateWithDuration:0.35 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.viewContainer setFrame:CGRectMake(12, positionY, self.viewContainer.frame.size.width, self.viewContainer.frame.size.height)];
    }completion:^(BOOL finished){
        //NSLog(@"Done!!");
    }];

}

#pragma mark - Login Validations
-(BOOL)loginParametersCorrect{
    
    BOOL correct = YES;
    if ([self.txtDistributorID.text length] == 0 || [self.txtDistributorPIN.text length] == 0) {
        correct = NO;
    }
    else{
        correct = YES;
    }
    return correct;
    
}

#pragma mark - Connection Delegates
-(void)connectionFinish:(NSDictionary *)JSONObject succes:(BOOL)success serviceName:(NSString *)name{
    
    if (success) {
        NSLog(@"%@: ---- %@", name, JSONObject);
        NSString *status = [[JSONObject valueForKey:@"status"] stringValue];
        
        if ([status isEqualToString:@"500"]) {
            UIAlertView *alertStatus = [[UIAlertView alloc]initWithTitle:@"Login Herbalife" message:[JSONObject valueForKey:@"error"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertStatus show];
        }
        else if ([status isEqualToString:@"200"]){
#warning Store user token
            //Store user token
            //NSString *token = [[JSONObject objectForKey:@"data"] valueForKey:@"token"];
            //Show the next view 'UserInfo'
            
            userDetailsViewController *userDetails = [[userDetailsViewController alloc]initWithNibName:@"userDetailsViewController" bundle:nil];
            userDetails.TOKEN_TMP_ = [[JSONObject objectForKey:@"data"]valueForKey:@"token"];
            UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:userDetails];
            [self presentViewController:navController animated:YES completion:nil];
            
            /*
            UserInfoViewController *userInfo = [[UserInfoViewController alloc] initWithNibName:nil bundle:nil];
            userInfo.TOKEN_TMP = [[JSONObject objectForKey:@"data"]valueForKey:@"token"];
            userInfo.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            [self presentViewController:userInfo animated:YES completion:nil];
            */
            
        }
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Connection fail" message:@"Try again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

@end
