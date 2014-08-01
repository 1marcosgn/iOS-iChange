//
//  iChangeViewController.h
//  iChange
//
//  Created by Marcos Garcia on 7/10/14.
//  Copyright (c) 2014 Herbalife. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface iChangeViewController : UIViewController


@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealButton;

- (IBAction)getToken:(id)sender;
- (IBAction)clearKeyChain:(id)sender;


@end
