//
//  initialiChangeViewController.m
//  iChange
//
//  Created by Marcos Garcia on 7/24/14.
//  Copyright (c) 2014 Herbalife. All rights reserved.
//

#import "initialiChangeViewController.h"
#import "herbalifeLoginViewController.h"
#import "SSKeychain.h"
#import "JSON.h"
#import "iChangeViewController.h"
#import "RNCryptor.h"
#import "RNEncryptor.h"
#import "RNDecryptor.h"

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

-(void)connectionFinish:(NSDictionary *)JSONObject succes:(BOOL)success serviceName:(NSString *)name{
    
    NSLog(@"%@: ---- %@", name, JSONObject);
    
    if (success) {
        
        //if(webservice)
        if ([name isEqualToString:@"login"]) {
            
            //replace 'token' in the keychain and present the 'tabbarviewcontroller'
            [SSKeychain deletePasswordForService:@"iChangeUserToken" account:@"iChange"];
            BOOL storeToken = [SSKeychain setPassword:[[JSONObject objectForKey:@"data"] valueForKey:@"token"] forService:@"iChangeUserToken" account:@"iChange"];
            
            if (storeToken) {
                UIStoryboard * mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                iChangeViewController * iChangeVC = (iChangeViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"tabBarController"];
                [self presentViewController:iChangeVC animated:YES completion:nil];
            }
            else{
                //present current viewcontroller...
            }
        }
        else{
            
            //else{
            //present 'ichangeLoginViewController' and message 'please confirm user and password...'
            NSLog(@"Connection error");
        }
        
        
    }
    
    
}

-(void)callLogin:(NSString *)user password:(NSString *)password{
    
    //New 'ConnectionViewController' instance to manage the web service connections
    ConnectionViewController *connection = [[ConnectionViewController alloc]init];
    [connection setDelegate:self];
    [self.view insertSubview:connection.view atIndex:[[self.view subviews]count]];
    [connection start];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *paramFinal = [NSMutableDictionary dictionary];
    
    //'SBJsonWriter' allows to create the correct format for the payload request
    SBJsonWriter *JSONWriter = [SBJsonWriter alloc];
    
    [params setValue:user forKeyPath:@"username"];
    [params setValue:password forKeyPath:@"password"];
    [paramFinal setObject:params forKey:@"data"];
    
    NSString *prevString = [JSONWriter stringWithObject:paramFinal];
    NSData *jsonData = [prevString dataUsingEncoding:NSUTF8StringEncoding];
    
    //Method to consume a certain web service (you will have to send the headers as parameters only if it's required
    [connection executeService:@"login" withData:jsonData type:@"POST" headers:nil];
    
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
    
    //Check if password and username already exists in the current device --
    NSString *password = [SSKeychain passwordForService:@"iChangeUserPassword" account:@"iChange"];
    NSString *username = [SSKeychain passwordForService:@"iChangeUserName" account:@"iChange"];
    
    /*
    NSData *dataUsername = [username dataUsingEncoding:NSASCIIStringEncoding];
    NSData *decryptedDatausername = [RNDecryptor decryptData:dataUsername withSettings:kRNCryptorAES256Settings password:@"ichange" error:nil];
    NSString *strDecryptedusername = [[NSString alloc]initWithData:decryptedDatausername encoding:NSASCIIStringEncoding];
    username = strDecryptedusername;
    
    NSData *dataPassword = [username dataUsingEncoding:NSASCIIStringEncoding];
    NSData *decryptedDatapassword = [RNDecryptor decryptData:dataPassword withSettings:kRNCryptorAES256Settings password:@"ichange" error:nil];
    NSString *strDecryptedpassword = [[NSString alloc]initWithData:decryptedDatapassword encoding:NSASCIIStringEncoding];
    password = strDecryptedpassword;*/
    
    if (username != nil && password != nil) {
        //get the 'username' and 'password' from keychain
        //consume 'login' webservice
        [self callLogin:username password:password];
    }
    
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
