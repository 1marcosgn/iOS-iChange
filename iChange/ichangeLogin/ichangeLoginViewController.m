//
//  ichangeLoginViewController.m
//  iChange
//
//  Created by Marcos Garcia on 7/11/14.
//  Copyright (c) 2014 Herbalife. All rights reserved.
//

#import "ichangeLoginViewController.h"
#import "SBJsonWriter.h"
#import "herbalifeLoginViewController.h"
#import "iChangeViewController.h"

@interface ichangeLoginViewController (){
    BOOL loginSuccess;
}

@end

@implementation ichangeLoginViewController

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
        
        //'SBJsonWriter' allows to create the correct format for the payload request
        SBJsonWriter *JSONWriter = [SBJsonWriter alloc];
        
        [params setValue:self.txtUsername.text forKeyPath:@"username"];
        [params setValue:self.txtPassword.text forKeyPath:@"password"];
        [paramFinal setObject:params forKey:@"data"];
        
        NSString *prevString = [JSONWriter stringWithObject:paramFinal];
        NSData *jsonData = [prevString dataUsingEncoding:NSUTF8StringEncoding];
        
        //Method to consume a certain web service (you will have to send the headers as paraneters only if it's required
        [connection executeService:@"login" withData:jsonData type:@"POST" headers:nil];
        
    }
    else{
        UIAlertView *alertLogin = [[UIAlertView alloc]initWithTitle:nil message:@"Please enter a USERNAME and PASSWORD to continue." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertLogin show];
        loginSuccess = NO;
    }
    
}

//Set the basic initial properties for the viewController
-(void)setViewItems{
    
    loginSuccess = NO;
    
    [self.viewContainer setBackgroundColor:[UIColor clearColor]];
    [self.txtUsername setDelegate:self];
    [self.txtPassword setDelegate:self];
    
    UIImage *backgroundImage = [UIImage imageNamed:@"loginBack.png"];
    UIColor *backgorund = [[UIColor alloc] initWithPatternImage:backgroundImage];
    [self.view setBackgroundColor:backgorund];
    
    UITapGestureRecognizer *gestureDismiss = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:gestureDismiss];

}



#pragma mark - UITextField Delegates
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [self animationMoveTo:@"UP"];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.txtUsername resignFirstResponder];
    [self.txtPassword resignFirstResponder];
    [self animationMoveTo:@"DOWN"];
    return YES;
    
}

-(void)dismissKeyboard{
    
    [self.txtUsername resignFirstResponder];
    [self.txtPassword resignFirstResponder];
    [self animationMoveTo:@"DOWN"];
    
}

//Change the position of the User Interface elements
#pragma mark - Animations
-(void)animationMoveTo:(NSString *)moveTo{

#warning animation of keyoboard's motion
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
    }];
    
}

#pragma mark - Login Validations
-(BOOL)loginParametersCorrect{
    //Simple login validation
    BOOL correct = YES;
    if ([self.txtUsername.text length] == 0 || [self.txtPassword.text length] == 0) {
        correct = NO;
    }
    else{
        correct = YES;
    }
    return correct;
    
}

//Connection delegate - returns: a dictionary with the Json object, succes or not, and the webservice name
#pragma mark - Connection Delegates
-(void)connectionFinish:(NSDictionary *)JSONObject succes:(BOOL)success serviceName:(NSString *)name{
    
    if (success) {
        NSLog(@"%@: ---- %@", name, JSONObject);
        NSString *status = [[JSONObject valueForKey:@"status"] stringValue];
        
        if ([status isEqualToString:@"500"]) {
            UIAlertView *alertStatus = [[UIAlertView alloc]initWithTitle:@"Login" message:[JSONObject valueForKey:@"error"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertStatus show];
        }
        else if ([status isEqualToString:@"200"]){
            
#warning Store user token and present next modal elements in the storyboard...
            //Store user token
            //NSString *token = [[JSONObject objectForKey:@"data"] valueForKey:@"token"];
            NSLog(@"Welcome...");
            loginSuccess = YES;
            //[self shouldPerformSegueWithIdentifier:nil sender:nil];
            [self performSegueWithIdentifier:@"login_success" sender:nil];
            
        }
    }
    else{
        NSLog(@"Error");
    }
    
}

- (IBAction)goToSignUp:(id)sender {

    herbalifeLoginViewController *herbalifeLogIn = [[herbalifeLoginViewController alloc]initWithNibName:nil bundle:nil];
    herbalifeLogIn.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:herbalifeLogIn animated:YES completion:nil];

}

@end

