//
//  UserInfoViewController.m
//  iChange
//
//  Created by Marcos Garcia on 7/11/14.
//  Copyright (c) 2014 Herbalife. All rights reserved.
//

#import "UserInfoViewController.h"
#import "userDetailsViewController.h"

@interface UserInfoViewController ()
@end

@implementation UserInfoViewController

@synthesize TOKEN_TMP;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableUser setDelegate:self];
    [self.tableUser setDataSource:self];
    [self.tableUser reloadData];
    [self setViewItems];
}

-(void)setViewItems{
    
    UINavigationBar *navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 55)];
    
    UIColor *backColor = [UIColor colorWithRed:151.0f/255.0f green:192.0f/255.0f blue:63.0f/255.0f alpha:1.0f];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Futura-medium" size:18], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
    UIBarButtonItem *actionButton = [[UIBarButtonItem alloc] initWithTitle:@"| NEXT" style:UIBarButtonItemStyleBordered target:self action:@selector(next)];
    actionButton.tintColor = [UIColor whiteColor];
    [actionButton setTitleTextAttributes:attributes forState:UIControlStateNormal];

    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"BACK |" style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
    backButton.tintColor = [UIColor whiteColor];
    [backButton setTitleTextAttributes:attributes forState:UIControlStateNormal];

    navBar.topItem.rightBarButtonItem = actionButton;
    navBar.topItem.leftBarButtonItem = backButton;
   
    UINavigationItem *itemNext = [[UINavigationItem alloc]initWithTitle:@"Create Account"];
    
    itemNext.rightBarButtonItem = actionButton;
    itemNext.leftBarButtonItem = backButton;
    navBar.items = [NSArray arrayWithObject:itemNext];
    
    NSDictionary *attributesTitle = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Futura-medium" size:20], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
    [navBar setTitleTextAttributes:attributesTitle];
    navBar.barTintColor = backColor;
    
    [self.view addSubview:navBar];
    [self setNeedsStatusBarAppearanceUpdate];
    
}

-(void)back{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
    
}

//Determines if all the values are correctly filled
-(void)next{
    
    NSMutableDictionary *tmpDictionary = [NSMutableDictionary dictionary];
    
    for (UIView *view in self.tableUser.subviews) {
        for (userInfoTableViewCell *cell in view.subviews) {
            NSString *tagText = [NSString stringWithFormat:@"%ld", (long)cell.txtInformation.tag];
            NSString *textFieldInfo = cell.txtInformation.text;
            [tmpDictionary setObject:textFieldInfo forKey:tagText];
        }
    }
    
    BOOL goToNext = YES;
    
    for (int i = 0; i < [tmpDictionary count]; i++) {
        if ([[tmpDictionary valueForKeyPath:[NSString stringWithFormat:@"%d", i]] isEqualToString:@""]) {
            goToNext = NO;
        }
    }
    
    if (goToNext) {
        userDetailsViewController *userDetails = [[userDetailsViewController alloc]initWithNibName:@"userDetailsViewController" bundle:nil];
        userDetails.TOKEN_TMP_ = TOKEN_TMP;
        userDetails.dictionaryInformation = tmpDictionary;
        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:userDetails];
        [self presentViewController:navController animated:YES completion:nil];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Please complete all the information before continue" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

-(BOOL)validateFields{

    return YES;
    
}

-(void)changeTablePosition{

    [self.tableUser scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    CGPoint point = self.tableUser.contentOffset;
    point .y += self.tableUser.rowHeight + 13;
    self.tableUser.contentOffset = point;
    
}

-(void)resetTablePosition{
    
    [self.tableUser scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    CGPoint point = self.tableUser.contentOffset;
    point .y -= self.tableUser.rowHeight - 40;
    self.tableUser.contentOffset = point;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - TableView Delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //Identifier
    NSString *cellIdentifier = @"userInfoCell";
    //Cells
    userInfoTableViewCell *cell = (userInfoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    switch (indexPath.row) {
        
        case 0:
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"userInfoTableViewCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
                [cell.imgIcon setImage:[UIImage imageNamed:@"userinfoCell.png"]];
                [cell.txtInformation setPlaceholder:@"Mobile Phone"];
                [cell.txtInformation setTag:0];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            return cell;
            break;
            
        case 1:
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"userInfoTableViewCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
                [cell.imgIcon setImage:[UIImage imageNamed:@"userinfoUser.png"]];
                [cell.txtInformation setPlaceholder:@"Username (unique username)"];
                [cell.txtInformation setTag:1];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            return cell;
            break;
            
        case 2:
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"userInfoTableViewCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
                [cell.imgIcon setImage:[UIImage imageNamed:@"userinfoPass.png"]];
                [cell.txtInformation setPlaceholder:@"Password (required)"];
                [cell.txtInformation setTag:2];
                [cell setDelegate:self];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            return cell;
            break;
            
        case 3:
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"userInfoTableViewCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
                [cell.imgIcon setImage:[UIImage imageNamed:@"bulb.png"]];
                [cell.txtInformation setPlaceholder:@"Re-type password (To confirm)"];
                [cell.txtInformation setTag:3];
                [cell setDelegate:self];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            return cell;
            break;
            
        default:
            break;
    }
    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 56;
}

@end
