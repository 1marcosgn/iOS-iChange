//
//  initialiChangeViewController.h
//  iChange
//
//  Created by Marcos Garcia on 7/24/14.
//  Copyright (c) 2014 Herbalife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectionViewController.h"

@interface initialiChangeViewController : UIViewController <ConnectionDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblCreateiChange;
@property (weak, nonatomic) IBOutlet UIButton *btnSignup;
@property (weak, nonatomic) IBOutlet UILabel *lblAlreadyHaveAccount;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIImageView *imgUser;
@property (weak, nonatomic) IBOutlet UIView *viewLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnHerbalifeTerms;

- (IBAction)signUp:(id)sender;
- (IBAction)goHerbalifeTerms:(id)sender;

@end
