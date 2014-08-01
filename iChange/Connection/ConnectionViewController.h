//
//  ConnectionViewController.h
//  iChange
//
//  Created by Marcos Garcia on 7/11/14.
//  Copyright (c) 2014 Herbalife. All rights reserved.
//

#import <UIKit/UIKit.h>

//Protocol for connection
@protocol ConnectionDelegate <NSObject>

-(void)connectionFinish:(NSDictionary *)JSONObject succes:(BOOL)success serviceName:(NSString *)name;

@end

@interface ConnectionViewController : UIViewController <NSURLConnectionDataDelegate>{
    NSMutableData *webData;
    NSURLConnection *connection;
    NSString *webServiceName;
    id<ConnectionDelegate> delegate;
}

@property (nonatomic, retain) id <ConnectionDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (nonatomic, retain) NSString *webServiceName;

-(void)connect:(NSMutableURLRequest *)req;
-(void)executeService:(NSString *)nameWebService withData:(NSData *)jsonData type:(NSString *)type headers:(NSMutableDictionary *)headers;
-(void)start;
-(void)finish;
-(void)setPositionFromFrame:(CGRect)frame;
-(void)errorAlert:(NSString *)title :(NSString *)message;

@end
