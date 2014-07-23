//
//  userInfoTableViewCell.h
//  iChange
//
//  Created by Marcos Garcia on 7/15/14.
//  Copyright (c) 2014 Herbalife. All rights reserved.
//

#import <UIKit/UIKit.h>

//Protocol for the position of tableview
@protocol CellDelegate <NSObject>

-(void)changeTablePosition;
-(void)resetTablePosition;

@end

@interface userInfoTableViewCell : UITableViewCell <UITextFieldDelegate>{
    id<CellDelegate>delegate;
}

@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
@property (weak, nonatomic) IBOutlet UITextField *txtInformation;
@property (nonatomic, retain) id <CellDelegate> delegate;

@end
