//
//  postaddViewController.m
//  FAnsfoot
//
//  Created by Pankaj Sharma on 04/06/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import "postaddViewController.h"
#import "AppManager.h"


@interface postaddViewController ()
@property (strong, nonatomic) IBOutlet UITextView *AddTextView;
@end

@implementation postaddViewController

- (void)viewDidLoad

{
    
    bannerView.adUnitID = @"ca-app-pub-2063088545096347/2934377089";
    bannerView.rootViewController = self;
    [bannerView loadRequest:[GADRequest request]];
    
    ischeckBoxSelected=NO;
    
    [super viewDidLoad];
    
    _Dropdown_TableVW.scrollEnabled=NO;
    
    UIColor *color = [UIColor colorWithRed:184.0f/255.0f green:184.0f/255.0f blue:184.0f/255.0f alpha:1.0];
    txt_tags.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"  Tags" attributes:@{NSForegroundColorAttributeName: color}];
    txt_PostTitle.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"  Title" attributes:@{NSForegroundColorAttributeName: color}];
    category_lbl.textColor=[UIColor colorWithRed:184.0f/255.0f green:184.0f/255.0f blue:184.0f/255.0f alpha:1.0];
    
    if(IS_IPHONE_5)
    {
        _Dropdown_TableVW.frame=CGRectMake(16  ,402 , 288, 0);
    }
    else if (IS_IPHONE_6)
    {
        _Dropdown_TableVW.frame=CGRectMake(16, 473, 348, 0);
        
    }
    else if (IS_IPHONE_6_PLUS)
    {
        _Dropdown_TableVW.frame=CGRectMake(11, 745, 392, 0);
    }
    
    arr_category=[NSArray arrayWithObjects:@"Memes",@"Video",@"NSFW",@"Animated GIF", nil];
    
    self.view.backgroundColor=[UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    
   
    UIView *paddingVw_fstName = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    txt_PostTitle.leftView = paddingVw_fstName;
    txt_PostTitle.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingVw_fstName1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    txt_tags.leftView = paddingVw_fstName1;
    txt_tags.leftViewMode = UITextFieldViewModeAlways;
    
    [AppManager sharedManager].navCon = self.navigationController;
    
    self.tabBarController.tabBar.hidden=NO;
   [self loadAddress];
}



-(void)loadAddress
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
                                       @{
                                         }];
    
    
    [[AppManager sharedManager] getDataForUrl:@"http://fansfoot.com/mobile/web/?type=advertisment"
                                   parameters:parameters
                                      success:^(AFHTTPRequestOperation *operation, NSMutableDictionary * responseObject)
     {
         // Get response from server
         NSLog(@"JSON: %@", responseObject);
         if ([responseObject count]>0)
         {
             _AddTextView.text=[[[responseObject valueForKey:@"advertisements"] objectAtIndex:0]valueForKey:@"code "];
             NSLog(@"%@",[[[responseObject valueForKey:@"advertisements"] objectAtIndex:0]valueForKey:@"description "]);
         }
         else
         {
             alert(@"Alert", @"Null Data.");
             [[AppManager sharedManager]hideHUD];
         }
     }
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [[AppManager sharedManager]hideHUD];
     }];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    if (imagePICK==YES)
    {
        
        imagePICK=NO;
    }
    else
    {
        imageViewCam.image=nil;
        
        imageViewCam.image=[UIImage imageNamed:@"upload-container"];
        
        if (category_lbl.textColor == [UIColor blackColor])
        {
            category_lbl.textColor=[UIColor blackColor];
        }
        else
        {
            category_lbl.textColor=[UIColor colorWithRed:184.0f/255.0f green:184.0f/255.0f blue:184.0f/255.0f alpha:1.0];
        }
        
        txt_tags.text=nil;
        txt_PostTitle.text=nil;
        category_lbl.text=@" Category";
        
    }


}
-(void)viewDidDisappear:(BOOL)animated
{
    
}
-(void)viewDidUnload
{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)AddPostAction:(id)sender

{
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"alreadylogin"]==NO)
    {
        [kAppDelegate goToLoginView];
    }
    else
    {
        if (txt_PostTitle.text.length==0)
        {
            alert(@"Message", @"Please Enter Tag.");
            [txt_PostTitle becomeFirstResponder];
        }
        else if (category_lbl.text.length==0)
        {
            alert(@"Message", @"Please Enter Category.");
        }
        else if (txt_tags.text.length==0)
        {
            alert(@"Message", @"Please Enter Title.");
            
            [txt_tags becomeFirstResponder];
        }
        else
        {
            [self call];
        }
    }
}

-(void)call
{
    //quenelle.fansfoot.com/mobile/web/?type=add_post&user_id=5259&tag=abs&categories=hhhh&title=test
    
    //quenelle.fansfoot.com/mobile/web/?type=add_post&user_id=5259&tag=ankur1&categories=1&title=ankur&source=bansal
    
    str_user_id=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
    NSLog(@"%@",str_user_id);
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
                                       
                                       @{
                                         
                                         @"type" :@"add_post",
                                         @"user_id" :str_user_id,
                                         @"categories" :str_categorid,
                                         @"tag" :txt_tags.text,
                                         @"title" :txt_PostTitle.text,
                                         @"source" :@"abc"
                                         
                                         }];
    
    
    [[AppManager sharedManager] showHUD:@"Loading..."];
    
    // [appdelRef showProgress:@"Please wait.."];
    
    [[AppManager sharedManager] getDataForUrl:BASE_URL
     
                                   parameters:parameters
     
                                      success:^(AFHTTPRequestOperation *operation, id responseObject)
     
     {
         // Get response from server
         
         NSLog(@"JSON: %@", responseObject);
         
         if ([responseObject count]>0)
         {
             NSInteger Status=[[responseObject valueForKey:@"status"] integerValue];
             
             if(Status == 1)
             {
                 
                 if ([[responseObject valueForKey:@"message"] isEqualToString:@"Add Post Successfully."])
                 {
                     alert(@"Message", @"Post Added Successfully.");
                     
                     [[AppManager sharedManager]hideHUD];
                     
                     txt_tags.text=nil;
                     txt_PostTitle.text=nil;
                     imageViewCam.image=nil;
                     imageViewCam.image=[UIImage imageNamed:@"upload-container"];
                     category_lbl.textColor=[UIColor colorWithRed:184.0f/255.0f green:184.0f/255.0f blue:184.0f/255.0f alpha:1.0];
                     category_lbl.text=@"Category Type";
                     
                     if (btn_checkbox.selected==YES)
                     {
                         [btn_checkbox setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
                         btn_checkbox.selected=NO;
                         
                     }
                    
                     
                     
                     return;
                     
                 }
                 
             }
             else if (Status == 0)
             {
                 
                 alert(@"Alert", @"Invalid Data.");
                 
                 [[AppManager sharedManager]hideHUD];
                 
                 return;
             }
             
         }
         
         else
         {
             
             alert(@"Alert", @"Null Data.");
             [[AppManager sharedManager]hideHUD];
             
         }
         
     }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
     
     {
         
         NSLog(@"Error: %@", @"No internet connection.");
         
         // [appdelRef hideProgress];
         [[AppManager sharedManager]hideHUD];
         
         alert(@"Error",@"No internet connection.");
         
     }];
    
}


- (IBAction)TappedOnCamera:(id)sender
{
    [self movedown];
    
    _Dropdown_TableVW.frame=CGRectMake(_Dropdown_TableVW.frame.origin.x, _Dropdown_TableVW.frame.origin.y, _Dropdown_TableVW.frame.size.width, 0);
    
    //    rc = [btn_camera convertRect:rc toView:scrollView_Advers];
    //    pt = rc.origin;
    //    pt.x = 0;
    //    if(IS_IPHONE5)
    //    {
    //        pt.y=150;
    //    }
    //    else if (IS_IPHONE_6)
    //    {
    //        pt.y=150;
    //    }
    //    else if (IS_IPHONE_6_PLUS)
    //    {
    //        pt.y=180;
    //
    //    }
    //    [scrollView_Advers setContentOffset:pt animated:YES];
    
    [UIView commitAnimations];
    UIActionSheet *obj_ActionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Camera", nil),NSLocalizedString(@"Photo album", nil), nil];
    [obj_ActionSheet showInView:self.view];
}

#pragma mark  ActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
        {
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                UIImagePickerController *obj_ImagePicker=[[UIImagePickerController alloc]init];
                obj_ImagePicker.delegate=self;
                obj_ImagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                obj_ImagePicker.editing=YES;
                // obj_ImagePicker.videoQuality=UIImagePickerControllerQualityTypeHigh;
                [self.navigationController presentViewController:obj_ImagePicker animated:YES completion:nil];
            }
            else
            {
                UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Device has no camera" delegate:nil cancelButtonTitle:@"OK"                                                          otherButtonTitles: nil];
                [myAlertView show];
            }
        }
            break;
        case 1:
        {
            UIImagePickerController *obj_ImagePicker=[[UIImagePickerController alloc]init];
            obj_ImagePicker.delegate=self;
            obj_ImagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            obj_ImagePicker.editing=YES;
            [self.navigationController presentViewController:obj_ImagePicker animated:YES completion:nil];
        }
            break;
            
        case 2:
        {
            //   [scrollView_Advers setContentOffset:CGPointMake(0, 0) animated:YES];
            
        }
            break;
        default:
            break;
    }
}

#pragma mark  UIImagePickerController Delegates

- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info
{
    
    dataImage = UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerOriginalImage"],.1);
    encryptedString = [dataImage base64EncodedStringWithOptions:0];
    obj_imagePick=[info valueForKey:UIImagePickerControllerOriginalImage];
    
    //UIImage *image = [info
    //objectForKey:UIImagePickerControllerOriginalImage];
    //imageViewCam.image = image;
    
    //    [imageViewCam setContentMode:UIViewContentModeScaleAspectFit];
    imageViewCam.image=obj_imagePick;
    
    // [ btn_camera setBackgroundImage:obj_imagePick forState:UIControlStateNormal];
    
    imagePICK=YES;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - UITableViewDataSource implementation -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)tableView:(UITableView *)tableView  willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 25;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // [scrollView_Advers setUserInteractionEnabled:NO];
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.contentView.backgroundColor=[UIColor colorWithRed:239.0f/255.0f green:239.0f/255.0f blue:239.0f/255.0f alpha:0.5];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.textLabel.font=[UIFont systemFontOfSize:14];
    
    
    cell.textLabel.text = [arr_category objectAtIndex:indexPath.row];
    cell.textLabel.textColor=[UIColor blackColor];
    cell.textLabel.numberOfLines=4;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==_Dropdown_TableVW)
    {
        [UIView animateWithDuration:0.9f animations:^{
            
            _Dropdown_TableVW.frame=CGRectMake(_Dropdown_TableVW.frame.origin.x, _Dropdown_TableVW.frame.origin.y, _Dropdown_TableVW.frame.size.width, 0);
        }
                         completion:^(BOOL finished)
         {
             
             NSLog(@"FINISH");
             
         }];
        
        if ([[NSString stringWithFormat:@"%ld",(long)indexPath.row] isEqualToString:@"0"])
        {
            str_categorid=[NSString stringWithFormat:@"%d",1];
        }
     else if ([[NSString stringWithFormat:@"%ld",(long)indexPath.row] isEqualToString:@"1"])
        {
            str_categorid=[NSString stringWithFormat:@"%d",2];
        }
    else if ([[NSString stringWithFormat:@"%ld",(long)indexPath.row] isEqualToString:@"2"])
        {
            str_categorid=[NSString stringWithFormat:@"%d",5];
        }
   else if  ([[NSString stringWithFormat:@"%ld",(long)indexPath.row] isEqualToString:@"3"])
        {
            str_categorid=[NSString stringWithFormat:@"%d",7];
        }
        
        category_lbl.text=[arr_category objectAtIndex:indexPath.row];
        category_lbl.font = [UIFont systemFontOfSize:20.0f];
        category_lbl.textColor = [UIColor blackColor];
        [txt_tags becomeFirstResponder];
        
    }
    
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)ChooseCategoryAction:(id)sender
{
    [txt_PostTitle resignFirstResponder];
    [txt_tags resignFirstResponder];
    
    [UIView commitAnimations];
    if (_Dropdown_TableVW.frame.size.height==0)
    {
        [UIView animateWithDuration:0.9f animations:^{
            
            if(IS_IPHONE_5)
            {
                _Dropdown_TableVW.frame=CGRectMake(_Dropdown_TableVW.frame.origin.x, _Dropdown_TableVW.frame.origin.y, _Dropdown_TableVW.frame.size.width, [arr_category count]*26);
            }
            else if (IS_IPHONE_6)
            {
                _Dropdown_TableVW.frame=CGRectMake(_Dropdown_TableVW.frame.origin.x, _Dropdown_TableVW.frame.origin.y, _Dropdown_TableVW.frame.size.width, [arr_category count]*25);
            }
            else if (IS_IPHONE_6_PLUS)
            {
                _Dropdown_TableVW.frame=CGRectMake(_Dropdown_TableVW.frame.origin.x, _Dropdown_TableVW.frame.origin.y, _Dropdown_TableVW.frame.size.width, [arr_category count]*25);
            }
        }
                         completion:^(BOOL finished)
         {
         }];
        [_Dropdown_TableVW reloadData];
    }
    // else  if (tableVw_Search.frame.size.height==95 || tableVw_Search.frame.size.height==120 || tableVw_Search.frame.size.height==140)
    
    else  if (_Dropdown_TableVW.frame.size.height==  [arr_category count]*26 || _Dropdown_TableVW.frame.size.height==  [arr_category count]*25 || _Dropdown_TableVW.frame.size.height==  [arr_category count]*25)
        
    {
        [UIView animateWithDuration:0.9f animations:^{
            
            _Dropdown_TableVW.frame=CGRectMake(_Dropdown_TableVW.frame.origin.x, _Dropdown_TableVW.frame.origin.y, _Dropdown_TableVW.frame.size.width, 0);
        }
                         completion:^(BOOL finished)
         {
             
         }];
    }
}

#pragma mark - TextField Delegates
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations:@"MoveUP" context:Nil];
   
    [UIView setAnimationDuration:0.3];
    
    _Dropdown_TableVW.frame=CGRectMake(_Dropdown_TableVW.frame.origin.x, _Dropdown_TableVW.frame.origin.y, _Dropdown_TableVW.frame.size.width, 0);
    
    [self dismissViewControllerAnimated:YES completion:nil];

    
    if(textField==txt_PostTitle)
    {
        [self moveUP:txt_PostTitle];
    }
    else if(textField==txt_tags)
    {
        [self moveUP:txt_tags];
    }

    [UIView commitAnimations];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == txt_PostTitle)
    {
        [txt_PostTitle resignFirstResponder];
        
        [self movedown];
    }

  else if (textField == txt_tags)
     {
        [txt_tags resignFirstResponder];
        
        [self movedown];
    }
    
    return YES;
}

#pragma mark  View Animation
-(void)moveUP:(UITextField *)textField
{
    [UIView beginAnimations:@"MoveUP" context:Nil];
    [UIView setAnimationDuration:0.3];
    if(IS_IPHONE_5)
    {
        if(textField==txt_PostTitle)
        {
            self.view.frame=CGRectMake(0, -50, 320, self.view.frame.size.height);
        }
        else if(textField==txt_tags)
        {
            self.view.frame=CGRectMake(0, -145, 320, self.view.frame.size.height);
        }
    }
    
    else if (IS_IPHONE_6)
    {
        if(textField==txt_PostTitle)
        {
            self.view.frame=CGRectMake(0, -50, 375, self.view.frame.size.height);
        }
        else if(textField==txt_tags)
        {
            self.view.frame=CGRectMake(0, -135, 375, self.view.frame.size.height);
        }
        
    }
    else if (IS_IPHONE_6_PLUS)
    {
        if(textField==txt_PostTitle)
        {
            self.view.frame=CGRectMake(0, -50, 414, self.view.frame.size.height);
        }
        else if(textField==txt_tags)
        {
            self.view.frame=CGRectMake(0, -110, 414, self.view.frame.size.height);
        }
    }
    
    [UIView commitAnimations];
}

-(void)movedown
{
    [UIView beginAnimations:@"MoveUP" context:Nil];
    [UIView setAnimationDuration:0.3];
    
    if(IS_IPHONE_5)
    {
        self.view.frame=CGRectMake(0, 0, 320, self.view.frame.size.height);
    }
    else if (IS_IPHONE_6)
    {
        self.view.frame=CGRectMake(0, 0, 375, self.view.frame.size.height);
    }
    else if (IS_IPHONE_6_PLUS)
    {
        self.view.frame=CGRectMake(0, 0, 414, self.view.frame.size.height);
    }
    [UIView commitAnimations];
}

#pragma mark  Touch Delegate
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [txt_PostTitle resignFirstResponder];
    [txt_tags resignFirstResponder];
    
    _Dropdown_TableVW.frame=CGRectMake(_Dropdown_TableVW.frame.origin.x, _Dropdown_TableVW.frame.origin.y, _Dropdown_TableVW.frame.size.width, 0);
    
    [self movedown];
}



- (IBAction)checkboxaction:(id)sender
{
    if ([sender isSelected])
    {
        [btn_checkbox setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
        btn_checkbox.selected=NO;

    }
    else
    {
        [btn_checkbox setImage:[UIImage imageNamed:@"checkbox-addpost"] forState:UIControlStateNormal];
        btn_checkbox.selected=YES;

    }
    
    
}
@end
