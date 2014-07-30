//
//  userDetailsViewController.m
//  iChange
//
//  Created by Marcos Garcia on 7/15/14.
//  Copyright (c) 2014 Herbalife. All rights reserved.
//

#import "userDetailsViewController.h"

@interface userDetailsViewController (){
    
    UITextField *textGlobal;
    NSMutableDictionary *dictionaryGlobal;
    NSString *gender;
    NSString *height;
    NSMutableArray *modelArray;
}

@end

@implementation userDetailsViewController
@synthesize dictionaryInformation;
@synthesize TOKEN_TMP_;

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
    [self.tableUserDetails setDelegate:self];
    [self.tableUserDetails setDataSource:self];
    [self.tableUserDetails reloadData];
    [self setViewItems];
}

-(void)setViewItems{
    
    modelArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < 10; i++) {
        [modelArray addObject:@""];
    }
    
    dictionaryGlobal = [NSMutableDictionary dictionary];
    gender = @"female";

    CGRect frame = CGRectMake(0, 0, 70, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Futura-medium" size:18];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [[UIColor whiteColor]colorWithAlphaComponent:0.5];
    label.text = @"Create Account";
    self.navigationItem.titleView = label;
    
    
    UIColor *backColor = [UIColor colorWithRed:124.0f/255.0f green:124.0f/255.0f blue:124.0f/255.0f alpha:1.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Futura-medium" size:18], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    UIBarButtonItem *actionButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(done)];
   
    
    //UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:@"BACK |" style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"backArrow.png"] forState:UIControlStateNormal];
    button.frame=CGRectMake(0,0, 29, 29);
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    [actionButton setTitleTextAttributes:attributes forState:UIControlStateNormal];
    //[backButton setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    self.navigationItem.leftBarButtonItem = backButton;
    self.navigationItem.rightBarButtonItem = actionButton;
    
    self.navigationController.navigationBar.barTintColor = backColor;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
    [swipeRight setDirection:(UISwipeGestureRecognizerDirectionRight)];
    
    [self.view addGestureRecognizer:swipeRight];
    

    [self roundImage];
    
}

-(void)roundImage{
    
    self.btnTakeaSelfie.layer.cornerRadius = self.btnTakeaSelfie.frame.size.height / 2;
    self.btnTakeaSelfie.layer.masksToBounds = YES;
    self.btnTakeaSelfie.layer.borderColor = [[UIColor whiteColor]CGColor];
    self.btnTakeaSelfie.layer.borderWidth = 2;
    
}


-(void)back{
    
    //[self dismissViewControllerAnimated:YES completion:nil];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.35;
    transition.timingFunction =
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromLeft;
    
    UIView *containerView = self.view.window;
    [containerView.layer addAnimation:transition forKey:nil];
    [self dismissViewControllerAnimated:NO completion:nil];
    
}

-(BOOL)validateFields{
    BOOL infoIsComplete = YES;
    if ([modelArray count] == 10) {
        for (int i = 0; i<[modelArray count]; i++) {
            if ([[modelArray objectAtIndex:i] isEqualToString:@""]) {
                infoIsComplete = NO;
            }
        }
    }
    return infoIsComplete;
}

-(void)done{
    //Check if all the fields are complete..
    if ([self validateFields]) {
        [self createAccount];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Please complete all the information before continue" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)createAccount{
    
    //NSLog(@"Info model is: %@", modelArray);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableArray *keys = [[NSMutableArray alloc]init];
    
    [keys addObject:@"username"];
    [keys addObject:@"password"];
    [keys addObject:@"retypepassword"];
    [keys addObject:@"mobile_phone"];
    [keys addObject:@"first_name"];
    [keys addObject:@"last_name"];
    [keys addObject:@"height"];
    [keys addObject:@"weight"];
    [keys addObject:@"birthdate"];
    [keys addObject:@"gender"];
    
    for (int i = 0; i < [modelArray count]; i++) {
        [parameters setObject:[modelArray objectAtIndex:i] forKey:[keys objectAtIndex:i]];
    }
    
    //missing info..
    [parameters setObject:@"" forKey:@"email"];
    [parameters setObject:@"USA" forKey:@"country"];
    [parameters setObject:@"" forKey:@"timezone"];
    [parameters setObject:@"" forKey:@"zipcode"];
    [parameters setObject:@"" forKey:@"age"];
    [parameters removeObjectForKey:@"retypepassword"];
    [parameters setObject:@"" forKey:@"units_of_measure"];
    [parameters setObject:@"" forKey:@"picture"];
    //[parameters setObject:@"[""72x72"",""100x100""]" forKey:@"thumbnails"];
    //[parameters setObject:@"" forKey:@"thumbnails"];
    
    ConnectionViewController *connection = [[ConnectionViewController alloc]init];
    [connection setDelegate:self];
    [self.view insertSubview:connection.view atIndex:[[self.view subviews]count]];
    [connection start];
    
    NSMutableDictionary *paramsFinal = [NSMutableDictionary dictionary];
    SBJsonWriter *JSONWriter = [SBJsonWriter alloc];
    
    [paramsFinal setObject:parameters forKey:@"data"];
    NSString *prevString = [JSONWriter stringWithObject:paramsFinal];
    NSData *jsonData = [prevString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *headersDictionary = [NSMutableDictionary dictionary];
    [headersDictionary setObject:TOKEN_TMP_ forKey:@"X-USER-TOKEN"];
    [headersDictionary setObject:@"one_Object" forKey:@"one_Key"];
    [headersDictionary setObject:@"another_Object" forKey:@"another_Key"];
    
    [connection executeService:@"users" withData:jsonData type:@"POST" headers:headersDictionary];
    
}

-(void)connectionFinish:(NSDictionary *)JSONObject succes:(BOOL)success serviceName:(NSString *)name{
    
    if (success) {
        NSString *status = [[JSONObject valueForKey:@"status"] stringValue];
        
        if ([status isEqualToString:@"201"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Success" message:@"The user account was created successfully" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            
            [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Try again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    else{
        UIAlertView *alertStatus = [[UIAlertView alloc]initWithTitle:@"Connection fail" message:@"Try again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertStatus show];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)letmeTakeaSelfie:(id)sender {
    
    NSString *actionSheetTitle = @"Change profile picture";
    NSString *takeSelfie = @"Take a Selfie";
    NSString *library = @"Choose from Library";
    NSString *cancelSheet = @"Cancel";
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:actionSheetTitle delegate:self cancelButtonTitle:cancelSheet destructiveButtonTitle:nil otherButtonTitles:takeSelfie, library, nil];
    [actionSheet showInView:self.view];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:
            [self takeSelfie];
            break;
        case 1:
            [self selectPicture];
            break;
        default:
            break;
    }

}

-(void)takeSelfie{
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"The camera is not available" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }

}

-(void)selectPicture{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
   
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.btnTakeaSelfie.imageView.image = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}


#pragma mark - UITableview delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 4;
    }
    else if (section == 1){
        return 6;
    }
    else{
        return 0;
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    UILabel *lblTitleforSection = [[UILabel alloc]initWithFrame:CGRectMake(12, 12, 161, 30)];
    [lblTitleforSection setFont:[UIFont fontWithName:@"Futura-medium" size:18]];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 80)];
    [headerView.layer setBorderColor:[UIColor grayColor].CGColor];
    headerView.layer.borderWidth = 0.3;
    
    [headerView addSubview:lblTitleforSection];
    
    [lblTitleforSection setTextColor:[UIColor grayColor]];
    UIColor *backColor = [UIColor colorWithRed:240.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
    
    if (section == 0){
        [headerView setBackgroundColor:backColor];
        [lblTitleforSection setText:@"ACCOUNT"];
    }
    else if(section == 1){
        [headerView setBackgroundColor:backColor];
        [lblTitleforSection setText:@"ABOUT ME"];
    }
    return headerView;
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self storeModelInfo];
    
}

-(void)storeModelInfo{
    
    NSArray *cells = [self.tableUserDetails visibleCells];
    
    for (userDetailsCellTableViewCell *element in cells) {
        NSString *tagText = [NSString stringWithFormat:@"%ld", (long)element.txtInformation.tag];
        [modelArray replaceObjectAtIndex:[tagText intValue] withObject:element.txtInformation.text];
    }
    //NSLog(@"%@", modelArray);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    //Identifier
    NSString *cellIdentifier = @"userInfoCell";
    //Cells
    userDetailsCellTableViewCell *cell = (userDetailsCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSInteger section = [indexPath section];
    
    switch (indexPath.row) {
        case 0:
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"userDetailsCellTableViewCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                
                if (section == 0) {
                    [cell.txtInformation setTag:0];
                    [cell.lblDescription setText:@"Username"];
                    [cell.txtInformation setPlaceholder:@"Type your username"];
                    cell.txtInformation.text = [modelArray objectAtIndex:0];
                    cell.delegate = self;
                    
                }
                else if (section == 1){
                    [cell.txtInformation setTag:4];
                    [cell.lblDescription setText:@"First Name"];
                    [cell.txtInformation setPlaceholder:@"Type your name"];
                    cell.txtInformation.text = [modelArray objectAtIndex:4];
                    cell.delegate = self;
                    
                }
                
                
            }
            return cell;
            break;
            
        case 1:
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"userDetailsCellTableViewCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
                
                if (section == 0) {
                    [cell.txtInformation setTag:1];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    [cell.lblDescription setText:@"Password"];
                    [cell.txtInformation setPlaceholder:@"Type your password"];
                    cell.txtInformation.text = [modelArray objectAtIndex:1];
                    cell.delegate = self;
                    
                }
                else if(section == 1){
                    [cell.txtInformation setTag:5];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    [cell.lblDescription setText:@"Last Name"];
                    [cell.txtInformation setPlaceholder:@"Type your last name"];
                    cell.txtInformation.text = [modelArray objectAtIndex:5];
                    cell.delegate = self;
                    
                }
                
            }
            return cell;
            break;
            
        case 2:
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"userDetailsCellTableViewCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
                if (section == 0) {
                    [cell.txtInformation setTag:2];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    [cell.lblDescription setText:@"Confirm Password"];
                    [cell.txtInformation setPlaceholder:@"re-type your password"];
                    cell.txtInformation.text = [modelArray objectAtIndex:2];
                    cell.delegate = self;
                    
                }
                else if (section == 1){
                    [cell.txtInformation setTag:6];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    [cell.lblDescription setText:@"Height"];
                    [cell.txtInformation setPlaceholder:@"ft. in."];
                    cell.txtInformation.text = [modelArray objectAtIndex:6];
                    cell.delegate = self;
                    
                }
                
            }
            return cell;
            break;
            
        case 3:
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"userDetailsCellTableViewCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
                if (section == 0) {
                    [cell.txtInformation setTag:3];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    [cell.lblDescription setText:@"Mobile Phone"];
                    [cell.txtInformation setPlaceholder:@"xxx-xxx-xxx"];
                    cell.txtInformation.text = [modelArray objectAtIndex:3];
                    cell.delegate = self;
                    
                }
                else if (section == 1){
                    [cell.txtInformation setTag:7];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    [cell.lblDescription setText:@"Starting Weight"];
                    [cell.txtInformation setPlaceholder:@"lb."];
                    cell.txtInformation.text = [modelArray objectAtIndex:7];
                    cell.delegate = self;
                    
                }
            }
            return cell;
            break;
            
        case 4:
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"userDetailsCellTableViewCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
                if (section == 0) {
                    break;
                }
                else if (section == 1){
                    [cell.txtInformation setTag:8];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    [cell.lblDescription setText:@"Date of Birth"];
                    [cell.txtInformation setPlaceholder:@"mm/dd/yyyy"];
                    cell.txtInformation.text = [modelArray objectAtIndex:8];
                    cell.delegate = self;
                    
                }
            }
            return cell;
            break;
            
        case 5:
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"userDetailsCellTableViewCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
                if (section == 0) {
                    break;
                }
                else if (section == 1){
                    [cell.txtInformation setTag:9];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    [cell.lblDescription setText:@"Gender"];
                    [cell.txtInformation setPlaceholder:@"female/male"];
                    cell.txtInformation.text = [modelArray objectAtIndex:9];
                    cell.delegate = self;
                    
                }
            }
            return cell;
            break;

            
        default:
            break;
    }
    return cell;
        
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 62;
}

-(void)selectFemaleMale:(UISegmentedControl *)segment{
    
    if (segment.selectedSegmentIndex == 0) {
        gender = @"female";
    }
    else if (segment.selectedSegmentIndex == 1){
        gender = @"male";
    }
    [dictionaryGlobal setObject:gender forKey:@"7"];
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    textGlobal = textField;
    UITapGestureRecognizer *tapOutside = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tapOutside];
    
    if (textField.tag == 0) {
    }
    else if(textField.tag == 1 || textField.tag == 2){
        [self changeTablePosition:8];
    }
    else if (textField.tag == 3){
        [self changeTablePosition:73];
    }
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField.tag == 0) {
        [dictionaryGlobal setObject:textField.text forKey:@"4"];
    }
    if (textField.tag == 1) {
        height = textField.text;
    }
    if (textField.tag == 2) {
        height = [NSString stringWithFormat:@"%@.%@", height, textField.text];
        [dictionaryGlobal setObject:height forKey:@"5"];
    }
    if (textField.tag == 3) {
        [dictionaryGlobal setObject:textField.text forKey:@"6"];
    }
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    [self resetTablePosition];
    return YES;
    
}

-(void)dismissKeyboard{
    
    [textGlobal resignFirstResponder];
    [self resetTablePosition];
    
}
//add this code
-(void)changeTablePosition:(int)tag{
    int section;
    int index;
    if (tag <= 3) {
        section = 0;
        index = tag;
    }
    else{
        section = 1;
        index = tag - 4;
    }
    self.tableUserDetails.contentInset = UIEdgeInsetsMake(0, 0, 232, 0);
    [self.tableUserDetails scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    [self storeModelInfo];
}

-(void)resetTablePosition{
    
    [self.tableUserDetails scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    CGPoint point = self.tableUserDetails.contentOffset;
    point .y -= self.tableUserDetails.rowHeight - 40;
    self.tableUserDetails.contentOffset = point;
    
    [self storeModelInfo];
    
}

@end
