//
//  userDetailsCellTableViewCell.h
//  iChange
//
//  Created by Marcos Garcia on 7/16/14.
//  Copyright (c) 2014 Herbalife. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface userDetailsCellTableViewCell : UITableViewCell <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imgCell;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet UITextField *txtInformation;


@end
