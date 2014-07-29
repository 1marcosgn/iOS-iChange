//
//  userDetailsCellTableViewCell.m
//  iChange
//
//  Created by Marcos Garcia on 7/16/14.
//  Copyright (c) 2014 Herbalife. All rights reserved.
//

#import "userDetailsCellTableViewCell.h"


@implementation userDetailsCellTableViewCell

@synthesize delegate;

- (void)awakeFromNib
{
    [self.txtInformation setDelegate:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [self.delegate changeTablePosition];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.txtInformation resignFirstResponder];
    [self.delegate resetTablePosition];
    return YES;
    
}

@end
