//
//  ProfileVC.m
//  academy
//
//  Created by Brian on 6/6/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//
#import <MBProgressHUD/MBProgressHUD.h>
#import "UIImageView+AFNetworking.h"
#import "ProfileVC.h"
#import "PNChart.h"
#import "DataEngine.h"
#import "User.h"
#import "WordLearned.h"

@interface ProfileVC ()<ModelDelegate, AuthDelegate>

@end

@implementation ProfileVC
{
    
    IBOutlet UITextField *nameTF;

    IBOutlet UIButton *avatarBtn;
    IBOutlet UIImageView *avatarImg;
    IBOutlet UIView *chartView;
    IBOutlet UILabel *totalWordLb;
    IBOutlet UIActivityIndicatorView *wordLoadIndicator;
    
    PNBarChart * barChart;
    IBOutlet UIButton *changePassBtn;
    User *curUser;
    
    NSArray *xLabels;
    NSArray *yValues;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    curUser = [User currentUser];
    curUser.authDelegate = self;
    [self refreshView];
    [nameTF setFont:[UIFont fontWithName:@"GothamRounded-Bold" size:20]];
    [avatarImg setImageWithURL:[NSURL URLWithString:curUser.avatarURL] placeholderImage:[UIImage imageNamed:@"giraffe_happy.png"]];
    
    [avatarImg setContentMode:UIViewContentModeScaleAspectFill];
    CALayer *avatarLayer = avatarImg.layer;
    [avatarLayer setCornerRadius:50.0f];
    [avatarLayer setMasksToBounds:YES];
    
    if ([[DataEngine getInstance] loginType] != LoginNormal) {
        [changePassBtn setEnabled:NO];
    }
    
    //For BarC hart
    barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180.0)];
    [chartView addSubview:barChart];
    [chartView setBackgroundColor:[UIColor clearColor]];
    
    
    [self getWordLearnedList];
}

-(void) getWordLearnedList
{
    wordLoadIndicator.hidden = NO;
    //NSLog(@"getWordLearnedList runs");
    WordLearned *wordLearned = [WordLearned new];
    wordLearned.delegate = self;
    [wordLearned getAllWithFilter:@{@"user_id":curUser.modelId}];
}
-(void) refreshView
{
    [nameTF setText:curUser.profileName];
    
    
}
-(void) refreshChart
{
    [barChart setXLabels:xLabels];
    [barChart setYValues:yValues];
    [barChart setBarTopLabels:yValues];
    [barChart strokeChart];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)goChangeName:(UITextField *)sender {
    NSLog(@"Change name to: %@",sender.text);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [curUser changeProfileName:sender.text];
    
    [sender resignFirstResponder];
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
    //[avatarImg setImage:chosenImage];
    //save image

    [picker dismissViewControllerAnimated:YES completion:^{
        [self uploadImage:chosenImage];
    }];
    

}
-(void) uploadImage:(UIImage *)img
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [curUser uploadImageWithURL:[self getImageFilePath:img:0]];
}
-(NSURL *) getImageFilePath :(UIImage*) image :(int)imageIndex
{
    NSError * error;
    NSArray * directoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:NSTemporaryDirectory() error:&error];
    NSLog(@"directoryContents ====== %@",directoryContents);
    
    NSData *pngData = UIImageJPEGRepresentation(image, 0.05f);
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"propImage%@-%i.jpg",@"profileImage",imageIndex]]; //Add the file name
    [pngData writeToFile:filePath atomically:YES]; //Write the file
    return [NSURL fileURLWithPath:filePath];
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

#pragma WordLearned
-(void)getAllSucessfull:(AModel *)model List:(NSMutableArray *)allList
{
    wordLoadIndicator.hidden = YES;
    NSLog(@"WordLearnedList = %@",allList);
    if (allList.count > 0) {
        [totalWordLb setText:[NSString stringWithFormat:@"%i",allList.count]];
        [self generateChartInfo:allList];
    }
}

-(void) generateChartInfo:(NSArray *)learnedList
{
    NSDictionary * chartData = [WordLearned convertLearnedArrayForChart:learnedList maxColumn:5];
    xLabels = chartData[@"xLabels"];
    yValues = chartData[@"yValues"];
    [self refreshChart];
}

-(void)model:(AModel *)model ErrorMessage:(id)error StatusCode:(NSNumber *)statusCode
{
    wordLoadIndicator.hidden = YES;
    NSLog(@"error Message[%i] = %@",statusCode.intValue,error);
}
#pragma AuthDelegate
-(void)userChangeProfileNameSucessful:(User *)user
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSLog(@"userChangeProfileNameSucessful - %@",user.profileName);
    nameTF.text = user.profileName;
}
-(void)userChangeProfileNameFailed:(User *)user WithError:(id)error StatusCode:(NSNumber *)statusCode
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSLog(@"userChangeProfileNameFailed - %@",error);
    nameTF.text = user.profileName;
}
-(void)uploadAvatarSucessful:(User *)user
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSLog(@"uploadAvatarSucessful - %@",user.avatarURL);
    [avatarImg setImageWithURL:[NSURL URLWithString:user.avatarURL] placeholderImage:[UIImage imageNamed:@"giraffe_happy.png"]];
}
-(void)uploadAvatarFailed:(User *)user WithError:(id)error StatusCode:(NSNumber *)statusCode
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSLog(@"uploadAvatarFailed - %@",error);
}
@end
