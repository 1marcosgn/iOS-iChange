//
//  UserInfoViewController.h
//  iChange
//
//  Created by Marcos Garcia on 7/11/14.
//  Copyright (c) 2014 Herbalife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "userInfoTableViewCell.h"

@interface UserInfoViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, CellDelegate>{
    NSString *TOKEN_TMP;
}

@property (weak, nonatomic) IBOutlet UITableView *tableUser;
@property(nonatomic, retain) NSString *TOKEN_TMP;

@end
