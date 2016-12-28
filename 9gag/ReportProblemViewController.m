//
//  FifthViewController.m
//  9gag
//
//  Created by Pankaj Sharma on 20/05/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import "ReportProblemViewController.h"
#import "PlaceholderTextView.h"
#import "HeaderFile.h"

@interface ReportProblemViewController ()
@property (strong, nonatomic) IBOutlet UITextView *AddTextView;
@end

@implementation ReportProblemViewController

-(void)viewWillAppear:(BOOL)animated
{
    
    UIView *paddingVw_fstName = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    lbl_title.leftView = paddingVw_fstName;
    lbl_title.leftViewMode = UITextFieldViewModeAlways;
    
    self.tabBarController.tabBar.hidden=YES;
    
    [AppManager sharedManager].navCon = self.navigationController;
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    if(IS_IPHONE_5)
    {
        _Dropdown_TableVW.frame=CGRectMake(14  ,173 , 290, 0);
    }
    else if (IS_IPHONE_6)
    {
        _Dropdown_TableVW.frame=CGRectMake(14, 196, 442, 0);
        
    }
    else if (IS_IPHONE_6_PLUS)
    {
        _Dropdown_TableVW.frame=CGRectMake(11, 260, 392, 0);
    }
    
    arr_category=[NSArray arrayWithObjects:@"Memes",@"Video",@"NSFW",@"Animated GIF", nil];

    _Dropdown_TableVW.scrollEnabled=NO;
    
    txtviewWhatHappen.placeholder = @"Briefly explain what happen";
    txtviewWhatHappen.font=[UIFont systemFontOfSize:20.0];
    txtviewWhatHappen.placeholderColor = [UIColor  colorWithRed:206.0/255.0 green:206.0/255.0 blue:212.0/255.0 alpha:1];
    txtViiewSuggetion.placeholder = @"Give suggestion";
    txtViiewSuggetion.font=[UIFont systemFontOfSize:20.0];
    txtViiewSuggetion.placeholderColor = [UIColor  colorWithRed:206.0/255.0 green:206.0/255.0 blue:212.0/255.0 alpha:1];
    
    self.navigationController.tabBarController.tabBar.hidden=YES;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidDisappear:(BOOL)animated
{
 }
- (IBAction)TappedOnCamera:(id)sender
{
    
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
            //            [scrollView_Advers setContentOffset:CGPointMake(0, 0) animated:YES];
            
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
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)BackAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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

        lbl_category.text=[arr_category objectAtIndex:indexPath.row];
        lbl_category.font = [UIFont systemFontOfSize:20.0f];
        lbl_category.textColor = [UIColor blackColor];
        [txtviewWhatHappen becomeFirstResponder];
        
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
    
    [UIView commitAnimations];
    if (_Dropdown_TableVW.frame.size.height==0)
    {
        _Dropdown_TableVW.frame=CGRectMake(_Dropdown_TableVW.frame.origin.x, _Dropdown_TableVW.frame.origin.y, _Dropdown_TableVW.frame.size.width, 0);
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
            //[_Dropdown_TableVW bringSubviewToFront:self.view];
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
- (BOOL)textFieldShouldBeginEditing:(UITextView *)textField
{
    [UIView beginAnimations:@"MoveUP" context:Nil];
    
    [UIView setAnimationDuration:0.3];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
  if(textField==txtviewWhatHappen)
    {
        [self moveUP:txtViiewSuggetion];
    }
    else if (textField==txtViiewSuggetion)
    {
        [txtViiewSuggetion resignFirstResponder];
    }
    
    [UIView commitAnimations];
    
    return YES;
}

//- (BOOL)textFieldShouldReturn:(UITextView *)textField
//{
//    if (textField == txtviewWhatHappen)
//    {
//        [txtviewWhatHappen resignFirstResponder];
//        
//        [self movedown];
//    }
//    
//    else if (textField == txtViiewSuggetion)
//    {
//        [txtViiewSuggetion resignFirstResponder];
//        
//        [self movedown];
//    }
//    
//    return YES;
//}

-(BOOL) textFieldShouldReturn: (UITextField *) textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark  View Animation
-(void)moveUP:(UITextView *)textField
{
    [UIView beginAnimations:@"MoveUP" context:Nil];
    [UIView setAnimationDuration:0.3];
    if(IS_IPHONE_5)
    {
        if(textField==txtviewWhatHappen)
        {
            self.view.frame=CGRectMake(0, -50, 320, self.view.frame.size.height);
        }
        else if(textField==txtViiewSuggetion)
        {
            self.view.frame=CGRectMake(0, -145, 320, self.view.frame.size.height);
        }
    }
    
    else if (IS_IPHONE_6)
    {
        if(textField==txtviewWhatHappen)
        {
            self.view.frame=CGRectMake(0, -50, 375, self.view.frame.size.height);
        }
        else if(textField==txtViiewSuggetion)
        {
            self.view.frame=CGRectMake(0, -110, 375, self.view.frame.size.height);
        }
        
    }
    else if (IS_IPHONE_6_PLUS)
    {
        if(textField==txtviewWhatHappen)
        {
            self.view.frame=CGRectMake(0, -50, 414, self.view.frame.size.height);
        }
        else if(textField==txtViiewSuggetion)
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
    [txtviewWhatHappen resignFirstResponder];
    [txtViiewSuggetion resignFirstResponder];
    [lbl_title resignFirstResponder];
    _Dropdown_TableVW.frame=CGRectMake(_Dropdown_TableVW.frame.origin.x, _Dropdown_TableVW.frame.origin.y, _Dropdown_TableVW.frame.size.width, 0);

    [self movedown];
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text

{
    if([text isEqualToString:@"\n"])
        [textView resignFirstResponder];
    
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)webserviceSendReport:(id)sender
{
    
    if (isStringEmpty([NSString stringWithFormat:@"%@",lbl_title.text]))
    {
        alert(@"Message", @"Please Enter Title.");
        
        [lbl_title becomeFirstResponder];
    }
    else if (isStringEmpty([NSString stringWithFormat:@"%@",lbl_category.text]))
    {
        alert(@"Message", @"Please Enter Category.");
    }
    else if (isStringEmpty([NSString stringWithFormat:@"%@",txtviewWhatHappen.text]))
    {
        alert(@"Message", @"Please Enter Description.");
        
        [txtviewWhatHappen becomeFirstResponder];
    }
    else if (isStringEmpty([NSString stringWithFormat:@"%@",txtViiewSuggetion.text]))
    {
        alert(@"Message", @"Please Enter Suggestion.");
        
        [txtViiewSuggetion becomeFirstResponder];
        
    }
    else
    {
        [self callService];
    }

}

-(void)callService
{
//quenelle.fansfoot.com/mobile/web/?type=report_problem&categories=bansal&problem=test&briefly_explain=test&suggestion=test

    
    str_user_id=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
    NSLog(@"%@",str_user_id);
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
                                       
                                       @{
                                         
                                         @"type" :@"report_problem",
                                         @"USERID" :str_user_id,
                                         @"categories" :str_categorid,
                                         @"problem" :@"abc",
                                         @"briefly_explain" :txtViiewSuggetion.text,
                                         @"suggestion" :txtViiewSuggetion.text
                                         
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
                 
                 if ([[responseObject valueForKey:@"msg"] isEqualToString:@"Email send"])
                 {
                     alert(@"Message", @"Report Successfully Submitted.");
                     
                     [[AppManager sharedManager]hideHUD];
                     
                     txtviewWhatHappen.text=nil;
                     txtViiewSuggetion.text=nil;
                     imageViewCam.image=nil;
                     lbl_title.text=nil;
                     imageViewCam.image=[UIImage imageNamed:@"upload-container"];
                     lbl_category.textColor=[UIColor lightGrayColor];
                     lbl_category.text=@"Category Type";
                     
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
         
         alert(@"Error", @"No internet connection.");
         
     }];
    
}



@end
