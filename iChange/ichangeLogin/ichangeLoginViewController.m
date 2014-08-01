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
#import "SSKeychain.h"
#import "iChangeAppDelegate.h"
#import "RNCryptor.h"
#import "RNEncryptor.h"

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
        
        //Method to consume a certain web service (you will have to send the headers as parameters only if it's required
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
    
    [self.navigationController setNavigationBarHidden:NO];
    
    loginSuccess = NO;
    
    [self.viewContainer setBackgroundColor:[UIColor clearColor]];
    [self.txtUsername setDelegate:self];
    [self.txtPassword setDelegate:self];
    
    UIImage *backgroundImage = [UIImage imageNamed:@"newLogback.png"];
    UIColor *background = [[UIColor alloc] initWithPatternImage:backgroundImage];
    [self.view setBackgroundColor:background];
    
    UITapGestureRecognizer *gestureDismiss = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:gestureDismiss];
    
    self.btnLogin.layer.cornerRadius = self.btnLogin.frame.size.height / 2;
    self.btnLogin.layer.masksToBounds = YES;
    
    [self.txtUsername setBackgroundColor:[UIColor clearColor]];
    [self.txtPassword setBackgroundColor:[UIColor clearColor]];

    UIColor *color = [UIColor whiteColor];
    
    self.txtUsername.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"iChange Username" attributes:@{NSForegroundColorAttributeName: [color colorWithAlphaComponent:0.4]}];

    self.txtPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: [color colorWithAlphaComponent:0.4]}];
    
    [self.txtPassword.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.txtPassword.layer setBorderWidth:2.0f];
    self.txtPassword.layer.cornerRadius = self.txtPassword.frame.size.height / 2;
    self.txtPassword.layer.masksToBounds = YES;
    
    [self.txtUsername.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.txtUsername.layer setBorderWidth:2.0f];
    self.txtUsername.layer.cornerRadius = self.txtUsername.frame.size.height / 2;
    self.txtUsername.layer.masksToBounds = YES;
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    [self.navigationController.navigationBar setOpaque:NO];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Futura-medium" size:18], NSFontAttributeName, [UIColor grayColor], NSForegroundColorAttributeName, nil];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"backArrow.png"] forState:UIControlStateNormal];
    button.frame=CGRectMake(0,0, 29, 29);
    [button addTarget:self action:@selector(returnPrevious) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.leftBarButtonItem = backButton;
    
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];

    [self.navigationItem setTitle:@"Log in"];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(returnPrevious)];
    [swipeRight setDirection:(UISwipeGestureRecognizerDirectionRight)];
    
    [self.view addGestureRecognizer:swipeRight];
    
    
}

-(void)returnPrevious{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
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
            
            //Encrypt info before store in keychain
            /*NSData *encryptUser = [RNEncryptor encryptData:[self.txtUsername.text dataUsingEncoding:NSUTF8StringEncoding] withSettings:kRNCryptorAES256Settings password:@"ichange" error:nil];
            NSData *encryptPassword = [RNEncryptor encryptData:[self.txtPassword.text dataUsingEncoding:NSUTF8StringEncoding] withSettings:kRNCryptorAES256Settings password:@"ichange" error:nil];
            NSData *encryptToken = [RNEncryptor encryptData:[[[JSONObject objectForKey:@"data"] valueForKey:@"token"] dataUsingEncoding:NSUTF8StringEncoding] withSettings:kRNCryptorAES256Settings password:@"ichange" error:nil];
            
            NSString *strUser = [[NSString alloc] initWithData:encryptUser encoding:NSASCIIStringEncoding];
            NSString *strPass = [[NSString alloc] initWithData:encryptPassword encoding:NSASCIIStringEncoding];
            NSString *strTok = [[NSString alloc] initWithData:encryptToken encoding:NSASCIIStringEncoding];
            
            BOOL storeUsername = [SSKeychain setPassword:strUser forService:@"iChangeUserName" account:@"iChange"];
            BOOL storePassword = [SSKeychain setPassword:strPass forService:@"iChangeUserPassword" account:@"iChange"];
            BOOL storeToken = [SSKeychain setPassword:strTok forService:@"iChangeUserToken" account:@"iChange"];*/
            
            //Store user token in Keychain
            BOOL storeUsername = [SSKeychain setPassword:self.txtUsername.text forService:@"iChangeUserName" account:@"iChange"];
            BOOL storePassword = [SSKeychain setPassword:self.txtPassword.text forService:@"iChangeUserPassword" account:@"iChange"];
            BOOL storeToken = [SSKeychain setPassword:[[JSONObject objectForKey:@"data"] valueForKey:@"token"] forService:@"iChangeUserToken" account:@"iChange"];

            if (storeUsername == YES && storePassword == YES && storeToken == YES) {
                //TODO: create timestamp for the token (24hrs)
                //iChangeAppDelegate *mainDelegate = (iChangeAppDelegate *)[[UIApplication sharedApplication]delegate];
                //mainDelegate.timeStamp = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(newToken) userInfo:nil repeats:YES];
                
                loginSuccess = YES;
                [self performSegueWithIdentifier:@"login_success" sender:nil];
            }
            else{
                NSLog(@"Impossible to store all the fields in keychain =(");
            }
        }
    }
    else{
        UIAlertView *alertStatus = [[UIAlertView alloc]initWithTitle:@"Connection fail" message:@"Try again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertStatus show];
    }
    
}

/*
-(void)newToken{
    NSLog(@"Token is expiring");
    [SSKeychain deletePasswordForService:@"iChangeUserToken" account:@"iChange"];
    [SSKeychain deletePasswordForService:@"iChangeUserPassword" account:@"iChange"];
    [SSKeychain deletePasswordForService:@"iChangeUserName" account:@"iChange"];
}*/

- (IBAction)goToSignUp:(id)sender {

    herbalifeLoginViewController *herbalifeLogIn = [[herbalifeLoginViewController alloc]initWithNibName:nil bundle:nil];
    herbalifeLogIn.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:herbalifeLogIn animated:YES completion:nil];

}

- (IBAction)gotoTerms:(id)sender {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://www.ichange.com/terms"]];
}

@end

