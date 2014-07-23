//
//  ichangeLoginViewController.h
//  iChange
//
//  Created by Marcos Garcia on 7/11/14.
//  Copyright (c) 2014 Herbalife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectionViewController.h"

@interface ichangeLoginViewController : UIViewController <UITextFieldDelegate, ConnectionDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIView *viewUSER;
@property (weak, nonatomic) IBOutlet UIView *viewPASSWORD;
@property (weak, nonatomic) IBOutlet UIView *viewContainer;

- (IBAction)loginAction:(id)sender;
- (IBAction)goToSignUp:(id)sender;

@end
