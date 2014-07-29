//
//  userDetailsCellTableViewCell.h
//  iChange
//
//  Created by Marcos Garcia on 7/16/14.
//  Copyright (c) 2014 Herbalife. All rights reserved.
//

#import <UIKit/UIKit.h>

//Protocol for the position of tableview - add this code
@protocol CellDelegate_Detail <NSObject>

-(void)changeTablePosition:(int)tag;
-(void)resetTablePosition;

@end

@interface userDetailsCellTableViewCell : UITableViewCell <UITextFieldDelegate>{
    
    id<CellDelegate_Detail>delegate;
    
}

@property (weak, nonatomic) IBOutlet UIImageView *imgCell;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet UITextField *txtInformation;
@property (nonatomic, retain) id <CellDelegate_Detail> delegate;

@end
