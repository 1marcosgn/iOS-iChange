//
//  userInputValidator.h
//  iChange
//
//  Created by Vahak Matavosian on 7/31/14.
//  Copyright (c) 2014 Herbalife. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface userInputValidator : NSObject

+ (BOOL)validate:(NSMutableArray **) inputs errorIndexAt:(NSInteger *)index;
@end

