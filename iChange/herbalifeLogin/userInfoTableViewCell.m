//
//  userInfoTableViewCell.m
//  iChange
//
//  Created by Marcos Garcia on 7/15/14.
//  Copyright (c) 2014 Herbalife. All rights reserved.
//

#import "userInfoTableViewCell.h"

@implementation userInfoTableViewCell

@synthesize delegate;

- (void)awakeFromNib
{
    // Initialization code
    [self.txtInformation setDelegate:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.txtInformation resignFirstResponder];
    [self.delegate resetTablePosition];
    return YES;
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if ([textField.placeholder isEqualToString:@"Password (required)"] || [textField.placeholder isEqualToString:@"Re-type password (To confirm)"] ) {
        [textField setSecureTextEntry:YES];
        [self.delegate changeTablePosition];
    }
    else if ([textField.placeholder isEqualToString:@"Mobile Phone"]){
        [textField setKeyboardType:UIKeyboardTypePhonePad];
    }
    else{
        [textField setKeyboardType:UIKeyboardTypeAlphabet];
    }
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    if ([textField.placeholder isEqualToString:@"Re-type password (To confirm)"]) {
        [textField resignFirstResponder];
    }
    
}





@end
