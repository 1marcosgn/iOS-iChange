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
    
    dictionaryGlobal = [NSMutableDictionary dictionary];
    gender = @"female";

    CGRect frame = CGRectMake(0, 0, 70, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Futura-medium" size:18];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = @"Create Account";
    self.navigationItem.titleView = label;
    
    UIColor *backColor = [UIColor colorWithRed:151.0f/255.0f green:192.0f/255.0f blue:63.0f/255.0f alpha:1.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Futura-medium" size:18], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
    UIBarButtonItem *actionButton = [[UIBarButtonItem alloc] initWithTitle:@"| DONE" style:UIBarButtonItemStyleBordered target:self action:@selector(done)];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:@"BACK |" style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
    
    [actionButton setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [backButton setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    self.navigationItem.leftBarButtonItem = backButton;
    self.navigationItem.rightBarButtonItem = actionButton;
    
    self.navigationController.navigationBar.barTintColor = backColor;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

    [self roundImage];
    
}

-(void)roundImage{
    
    self.btnTakeaSelfie.layer.cornerRadius = self.btnTakeaSelfie.frame.size.height / 2;
    self.btnTakeaSelfie.layer.masksToBounds = YES;
    self.btnTakeaSelfie.layer.borderColor = [[UIColor whiteColor]CGColor];
    self.btnTakeaSelfie.layer.borderWidth = 2;
    
}


-(void)back{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)done{
    //Check if all the fields are complete..
    if ([dictionaryGlobal count] == 4) {
        [self createAccount];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Please complete all the information before continue" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)createAccount{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSMutableArray *keys = [[NSMutableArray alloc]init];
    
    [keys addObject:@"mobile_phone"];
    [keys addObject:@"username"];
    [keys addObject:@"password"];
    [keys addObject:@"retypepassword"];
    [keys addObject:@"units_of_measure"];
    [keys addObject:@"height"];
    [keys addObject:@"weight"];
    [keys addObject:@"gender"];
    
    for (int i = 0; i < [dictionaryInformation count]; i++) {
        NSString *key = [NSString stringWithFormat:@"%d", i];
        [parameters setObject:[dictionaryInformation valueForKey:key] forKey:[keys objectAtIndex:i]];
    }

    for (int i = 0; i < [dictionaryGlobal count]; i++) {
        [parameters setObject:[dictionaryGlobal valueForKey:[NSString stringWithFormat:@"%d", i+4]] forKey:[keys objectAtIndex:i+4]];
    }
    
    //missing info..
    [parameters setObject:@"UserTestName" forKey:@"first_name"];
    [parameters setObject:@"UserTestLastName" forKey:@"last_name"];
    [parameters setObject:@"" forKey:@"email"];
    [parameters setObject:@"" forKey:@"image_path"];
    [parameters setObject:@"" forKey:@"image_content_type"];
    [parameters setObject:@"" forKey:@"size"];
    [parameters setObject:@"1970-01-22T16:36:59Z" forKey:@"birthdate"];
    [parameters setObject:@"USA" forKey:@"country"];
    [parameters setObject:@"" forKey:@"timezone"];
    [parameters setObject:@"" forKey:@"zipcode"];
    [parameters setObject:@"" forKey:@"age"];
    [parameters removeObjectForKey:@"retypepassword"];
    
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
    [headersDictionary setObject:TOKEN_TMP_ forKey:@"X_USER_TOKEN"];
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
#warning find the message for the webservice error...
            NSLog(@"Error...");
        }
    }
    else{
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
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //Identifier
    NSString *cellIdentifier = @"userInfoCell";
    //Cells
    userDetailsCellTableViewCell *cell = (userDetailsCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    switch (indexPath.row) {
        case 0:
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"userDetailsCellTableViewCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
                
                [cell.imgCell setImage:[UIImage imageNamed:@"units.png"]];
                [cell.lblDescription setText:@"Units of Measure"];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                
                //Create Uitextfield
                UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 174, 40)];
                textField.font = [UIFont fontWithName:@"Futura-medium" size:14];
                textField.placeholder = @"Imperial (US)";
                textField.textAlignment = NSTextAlignmentCenter;
                [textField setDelegate:self];
                [textField setTag:0];
                [cell.viewContainer addSubview:textField];
                
            }
            return cell;
            break;
            
        case 1:
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"userDetailsCellTableViewCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
                UIColor *borderColor = [UIColor colorWithRed:157.0f/255.0f green:157.0f/255.0f blue:157.0f/255.0f alpha:1.0f];
    
                [cell.imgCell setImage:[UIImage imageNamed:@"height.png"]];
                [cell.lblDescription setText:@"Height"];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                
                //Create Uitextfield Ft's
                UITextField *textFieldFt = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
                textFieldFt.borderStyle = UITextBorderStyleLine;
                textFieldFt.layer.borderColor = borderColor.CGColor;
                textFieldFt.font = [UIFont fontWithName:@"Futura-medium" size:14];
                textFieldFt.placeholder = @"ft";
                textFieldFt.textAlignment = NSTextAlignmentCenter;
                [textFieldFt setDelegate:self];
                [textFieldFt setKeyboardType:UIKeyboardTypeNumberPad];
                [textFieldFt setTag:1];
                [cell.viewContainer addSubview:textFieldFt];
                
                //Create Uitextfield in's
                UITextField *textFieldIn = [[UITextField alloc]initWithFrame:CGRectMake(94, 0, 80, 40)];
                textFieldIn.borderStyle = UITextBorderStyleLine;
                textFieldIn.layer.borderColor = borderColor.CGColor;
                textFieldIn.font = [UIFont fontWithName:@"Futura-medium" size:14];
                textFieldIn.placeholder = @"in";
                textFieldIn.textAlignment = NSTextAlignmentCenter;
                [textFieldIn setDelegate:self];
                [textFieldIn setKeyboardType:UIKeyboardTypeNumberPad];
                [textFieldIn setTag:2];
                [cell.viewContainer addSubview:textFieldIn];
                
            }
            return cell;
            break;
            
        case 2:
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"userDetailsCellTableViewCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
                [cell.imgCell setImage:[UIImage imageNamed:@"starting.png"]];
                [cell.lblDescription setText:@"Starting Weight"];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                
                //Create Uitextfield
                UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 174, 40)];
                //textField.borderStyle = UITextBorderStyleLine;
                textField.font = [UIFont fontWithName:@"Futura-medium" size:14];
                textField.placeholder = @"lbs";
                textField.textAlignment = NSTextAlignmentCenter;
                [textField setDelegate:self];
                [textField setKeyboardType:UIKeyboardTypeDecimalPad];
                [textField setTag:3];
                [cell.viewContainer addSubview:textField];
            }
            return cell;
            break;
            
        case 3:
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"userDetailsCellTableViewCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
                [cell.imgCell setImage:[UIImage imageNamed:@"gender.png"]];
                [cell.lblDescription setText:@"Gender"];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                
                //Segmented controll
                NSArray *itemsArray = [NSArray arrayWithObjects:@"Female", @"Male", nil];
                UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:itemsArray];
                segmentedControl.frame = CGRectMake(0, 6, 174, 29);
                //segmentedControl.segmentedControlStyle
                [segmentedControl addTarget:self action:@selector(selectFemaleMale:) forControlEvents:UIControlEventValueChanged];
                segmentedControl.selectedSegmentIndex = 0;
                UIColor *backColor = [UIColor colorWithRed:151.0f/255.0f green:192.0f/255.0f blue:63.0f/255.0f alpha:1.0f];
                [segmentedControl setTintColor:backColor];
                [cell.viewContainer addSubview:segmentedControl];
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


-(void)changeTablePosition:(int)position{
    
    [self.tableUserDetails scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    CGPoint point = self.tableUserDetails.contentOffset;
    point .y += self.tableUserDetails.rowHeight + position;
    self.tableUserDetails.contentOffset = point;
    
}

-(void)resetTablePosition{
    
    [self.tableUserDetails scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    CGPoint point = self.tableUserDetails.contentOffset;
    point .y -= self.tableUserDetails.rowHeight - 40;
    self.tableUserDetails.contentOffset = point;
    
}

@end
