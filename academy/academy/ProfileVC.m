//
//  ProfileVC.m
//  academy
//
//  Created by Brian on 6/6/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "ProfileVC.h"
#import "PNChart.h"
#import "DataEngine.h"
#import "User.h"
@interface ProfileVC ()

@end

@implementation ProfileVC
{
    
    IBOutlet UITextField *nameTF;
    IBOutlet UIButton *avatar;
    IBOutlet UIView *chartView;
    
    PNBarChart * barChart;
    IBOutlet UIButton *changePassBtn;
    User *curUser;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    curUser = [User currentUser];
    [self refreshView];
    [nameTF setFont:[UIFont fontWithName:@"GothamRounded-Bold" size:20]];
    
    [avatar.imageView setContentMode:UIViewContentModeScaleAspectFill];
    CALayer *avatarLayer = avatar.layer;
    [avatarLayer setCornerRadius:50.0f];
    [avatarLayer setMasksToBounds:YES];
    
    if ([[DataEngine getInstance] loginType] != LoginNormal) {
        [changePassBtn setEnabled:NO];
    }
    
    //For BarC hart
    barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180.0)];
    [barChart setXLabels:@[@"SEP 1",@"SEP 2",@"SEP 3",@"SEP 4",@"SEP 5"]];
    [barChart setYValues:@[@1,  @10, @2, @6, @3]];
    [barChart setBarTopLabels:@[@1,  @10, @2, @6, @3]];
    [chartView addSubview:barChart];
    [chartView setBackgroundColor:[UIColor clearColor]];
    
    [self performSelector:@selector(refreshChart) withObject:self afterDelay:1.0f];
    
    
}
-(void) refreshView
{
    [nameTF setText:curUser.profileName];
    
    
}
-(void) refreshChart
{
    [barChart setXLabels:@[@"SEP 1",@"SEP 2",@"SEP 3",@"SEP 4",@"SEP 5"]];
    [barChart setYValues:@[@1,  @10, @2, @6, @3]];
    [barChart setBarTopLabels:@[@1,  @10, @2, @6, @3]];
    [barChart strokeChart];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)goChangeName:(UITextField *)sender {
    NSLog(@"Change name to: %@",sender.text);
    [sender resignFirstResponder];
}
- (IBAction)changeAvatar:(id)sender {
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)firstCellInsideTouchUp:(id)sender {
    [nameTF resignFirstResponder];
}
// Avatar Image Control
- (IBAction) AddImageOption:(id)sender
{
    
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Thay Ảnh Đại Diện" delegate:self cancelButtonTitle:@"Huỷ"
                                              destructiveButtonTitle: nil
                                                   otherButtonTitles:@"Chụp ngay", @"Lấy ảnh từ máy", nil];
    popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [popupQuery showInView:self.view];
    
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self SelectCamera];
    } else if (buttonIndex == 1) {
        [self SelectImage];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    chosenImage = [self imageWithImage:chosenImage minSide:100];
    [avatar setImage:chosenImage forState:UIControlStateNormal];
    //save image

    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (UIImage *)imageWithImage:(UIImage *)image minSide:(int)minLength {
    
    CGSize newSize;
    if(image.size.width > image.size.height)
    {
        newSize = CGSizeMake(image.size.width*minLength/image.size.height, minLength);
    }
    else
    {
        newSize = CGSizeMake(minLength, image.size.height*minLength/image.size.width);
    }
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}
- (void) SelectImage
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void) SelectCamera
{
    if (UIImagePickerControllerSourceTypeCamera)
    {
        UIImagePickerController * imgPicker = [[UIImagePickerController alloc] init];
        
        imgPicker.delegate = self;
        
        imgPicker.allowsEditing = NO;
        imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:imgPicker animated:YES completion:NULL];
    }
    
}

@end
