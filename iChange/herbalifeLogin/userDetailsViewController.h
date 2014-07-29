//
//  userDetailsViewController.h
//  iChange
//
//  Created by Marcos Garcia on 7/15/14.
//  Copyright (c) 2014 Herbalife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "userDetailsCellTableViewCell.h"
#import "ConnectionViewController.h"
#import "SBJsonWriter.h"

@interface userDetailsViewController : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, ConnectionDelegate, CellDelegate_Detail>{

    NSMutableDictionary *dictionaryInformation;
    NSString *TOKEN_TMP_;

}

@property (weak, nonatomic) IBOutlet UIImageView *imgCover;
@property (weak, nonatomic) IBOutlet UIButton *btnTakeaSelfie;
@property (weak, nonatomic) IBOutlet UITableView *tableUserDetails;
@property (nonatomic, retain) NSMutableDictionary *dictionaryInformation;
@property (weak, nonatomic) IBOutlet UILabel *lblUsername;
@property(nonatomic, retain) NSString *TOKEN_TMP_;

- (IBAction)letmeTakeaSelfie:(id)sender;

@end
