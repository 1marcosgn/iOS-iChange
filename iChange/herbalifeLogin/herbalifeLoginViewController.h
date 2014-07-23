//
//  herbalifeLoginViewController.h
//  iChange
//
//  Created by Marcos Garcia on 7/11/14.
//  Copyright (c) 2014 Herbalife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectionViewController.h"


@interface herbalifeLoginViewController : UIViewController <UITextFieldDelegate, ConnectionDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtDistributorID;
@property (weak, nonatomic) IBOutlet UITextField *txtDistributorPIN;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIView *viewID;
@property (weak, nonatomic) IBOutlet UIView *viewPIN;
@property (weak, nonatomic) IBOutlet UIView *viewContainer;
@property (weak, nonatomic) IBOutlet UIButton *btnHerbalifeTerms;

- (IBAction)loginAction:(id)sender;
- (IBAction)goToLogin:(id)sender;
- (IBAction)gotoTerms:(id)sender;

@end
