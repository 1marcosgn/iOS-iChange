//
//  ConnectionViewController.m
//  iChange
//
//  Created by Marcos Garcia on 7/11/14.
//  Copyright (c) 2014 Herbalife. All rights reserved.
//

#import "ConnectionViewController.h"

@interface ConnectionViewController ()

@end

static NSString *SERVICES_ADDRESS = @"http://staging-api.ichange.com";
//static NSString *SERVICES_ADDRESS = @"http://external-lb-icm-stg-392144852.us-east-1.elb.amazonaws.com";

@implementation ConnectionViewController

@synthesize indicator;
@synthesize delegate;
@synthesize webServiceName;

#pragma mark - WebService Methods
-(NSString *)getPath:(NSString *)serviceName{
    
    NSString *path = @"";
    
    //Herbalife iChange webServices...
    if ([serviceName isEqualToString:@"hlf_login"]) {
        path = [NSString stringWithFormat:@"%@/hlf/login", SERVICES_ADDRESS];
    }
    
    else if ([serviceName isEqualToString:@"login"]){
        path = [NSString stringWithFormat:@"%@/login", SERVICES_ADDRESS];
    }
    
    else if ([serviceName isEqualToString:@"users"]){
        path = [NSString stringWithFormat:@"%@/users", SERVICES_ADDRESS];
    }
    //else if (...Another webservice name...)
    return path;
    
}

#pragma mark - Connection Methods
-(void)executeService:(NSString *)nameWebService withData:(NSData *)jsonData type:(NSString *)type headers:(NSMutableDictionary *)headers{
    
    webServiceName = nameWebService;
    NSString *url = [self getPath:nameWebService];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    if ([type isEqualToString:@"POST"]) {
        
        [urlRequest setHTTPMethod:type];
        [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//Get all the keys and values of the header and send it as a parameter for the HTTP header
        if (headers != nil) {
            //[self getKeyandValuesfromHeader:headers];
            //[urlRequest setValue:[headers allKeys] forHTTPHeaderField:[headers allValues]];
            NSString *token = [headers valueForKey:@"X-USER-TOKEN"];
            [urlRequest setValue:token forHTTPHeaderField:@"X-USER-TOKEN"];
        }
        [urlRequest setHTTPBody:jsonData];
    }
    else if ([type isEqualToString:@"GET"]){
        //Stuff to send a 'GET' webservice here
    }
    else{
        //Other cases here... (maybe logout??)
    }
    [self connect:urlRequest];
    
}

-(void)connect:(NSMutableURLRequest *)req{
    
    connection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    if (connection) {
        webData = [NSMutableData data];
    }
    
}

-(void)start{
    
    [indicator startAnimating];
    
}

-(void)finish{
    
    [indicator stopAnimating];
    [self.view removeFromSuperview];
    
}

-(void)setPositionFromFrame:(CGRect)frame{
    
    CGRect frCnx = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    frCnx.origin.x = (frame.size.width - frCnx.size.width)/2.0;
    frCnx.origin.y = (frame.size.height - frCnx.size.height)/2.0;
    [self.view setFrame:frCnx];
    
}

#pragma mark - Connection Delegates
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    [webData appendData:data];
    
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
    [webData setLength:0];
    
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    [self finish];
    [delegate connectionFinish:nil succes:NO serviceName:webServiceName];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Connection fail" message:@"Try again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
    
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    NSMutableDictionary *dictionaryContent = [NSMutableDictionary dictionary];
    id JSON = [NSJSONSerialization JSONObjectWithData:webData options:0 error:nil];
    dictionaryContent = JSON;
    [self finish];
    
    if (dictionaryContent != NULL) {
        [delegate connectionFinish:dictionaryContent succes:YES serviceName:webServiceName];
    }
    else{
        [delegate connectionFinish:dictionaryContent succes:NO serviceName:webServiceName];
    }
    
}

#pragma mark - View Methods
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
