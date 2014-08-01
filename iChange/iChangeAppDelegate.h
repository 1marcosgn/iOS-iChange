//
//  iChangeAppDelegate.h
//  iChange
//
//  Created by Marcos Garcia on 7/10/14.
//  Copyright (c) 2014 Herbalife. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iChangeAppDelegate : UIResponder <UIApplicationDelegate>{
    
    NSTimer *timeStamp;
    
}

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain) NSTimer *timeStamp;

@end
