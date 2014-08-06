//
//  userInputValidator.m
//  iChange
//
//  Created by Vahak Matavosian on 7/31/14.
//  Copyright (c) 2014 Herbalife. All rights reserved.
//

#import "userInputValidator.h"

#define allTrim( object ) [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]

@implementation userInputValidator

+ (BOOL)validate:(NSMutableArray **)inputs errorIndexAt:(NSInteger *)index
{
    BOOL valid = true;
    NSMutableDictionary *password = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *retypepassword = [[NSMutableDictionary alloc] init];
    int passwordIndex = 0;
    int retypePasswordIndex = 0;

    for(int idx = 0; idx < [*inputs count]; idx++)
    {
        NSMutableDictionary *element = [*inputs objectAtIndex:idx];
        
        NSString *type = [element objectForKey:@"type"];
        NSString *text = [element objectForKey:@"text"];
        
        if ([type isEqualToString:@"username"] ||
            [type isEqualToString:@"first_name"] ||
            [type isEqualToString:@"last_name"]) {
            if (![userInputValidator validateExistance:text]) {
                element[@"validation_error"] = @"true";
                valid = false;
            }
        } else if ([type isEqualToString:@"mobile_phone"]) {
            if (![userInputValidator validatePhone:text]) {
                element[@"validation_error"] = @"true";
                valid = false;
            }
        } else if ([type isEqualToString:@"weight"]) {
            if (![userInputValidator validateWeight:text]) {
                element[@"validation_error"] = @"true";
                valid = false;
            }
        } else if ([type isEqualToString:@"height"]) {
            if (![userInputValidator validateHeight:text]) {
                element[@"validation_error"] = @"true";
                valid = false;
            }
        } else if ([type isEqualToString:@"birth_date"]) {
            if (![userInputValidator validateBirthdate:text]) {
                element[@"validation_error"] = @"true";
            }
        } else if ([type isEqualToString:@"password"]) {
            password = element;
            passwordIndex = idx;
        } else if ([type isEqualToString:@"retypepassword"]) {
            retypepassword = element;
            retypePasswordIndex = idx;
        }
        if (*index < 0 && !valid) {
            *index = idx;
        }
        
    }
    if (![userInputValidator validatePasswords: password retypePassword: retypepassword]) {
        [[*inputs objectAtIndex:passwordIndex] setObject:@"true" forKey:@"password"];
        [[*inputs objectAtIndex:retypePasswordIndex] setObject:@"true" forKey:@"retypepassword"];
        valid = false;
        if (*index < 0) {
            *index = passwordIndex;
        }
    }
    return false;
}

+ (BOOL)validatePasswords:(NSMutableDictionary *)password retypePassword:(NSMutableDictionary *) retypePassword
{
    NSString *passwordStr = [password objectForKey:@"text"];
    NSString *retypePasswordStr = [retypePassword objectForKey:@"text"];
    if ( [passwordStr length] == 0 ||
        [retypePasswordStr length] == 0 ||
        ![passwordStr isEqualToString:retypePasswordStr]) {
        password[@"validation_error"] = @"true";
        retypePassword[@"validation_error"] = @"true";

        return false;
    }
    return true;
}

+ (BOOL)validateEmail:(NSString *)email
{
    if ( [email length] == 0)
        return false;

    NSString *regexString = @"^[+\\w\\.\\-']+@[a-zA-Z0-9-]+(\\.[a-zA-Z0-9-]+)*(\\.[a-zA-Z]{2,})+$";
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexString];
    
    return [emailPredicate evaluateWithObject:email];
}

+ (BOOL)validateExistance:(NSString *)username
{
    if ( [username length] == 0)
        return false;
    
    return true;
}

+ (BOOL)validatePhone:(NSString *)phone
{
    if ( [phone length] == 0)
        return false;
    
    return true;
}

+ (BOOL)validateWeight:(NSString *)weight
{
    int weightFloat = [weight floatValue];
    
    if (weightFloat < 1.0 || weightFloat > 500)
        return false;
    
    return true;
}

+ (BOOL)validateHeight:(NSString *)height
{
    int heightFloat = [height floatValue];
#warning height validation needs more work
    if (heightFloat < 1.0 || heightFloat > 500)
        return false;
    
    return true;
}

+ (BOOL)validateBirthdate:(NSString *)birthDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    NSDate * birthDateFromString = [dateFormatter dateFromString:birthDate];
#warning height validation needs more work
    if (nil == birthDateFromString)
        return false;
    
    return true;
}

@end

