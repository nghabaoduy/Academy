//
//  ProfileVC.m
//  academy
//
//  Created by Brian on 6/6/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//
#import <MBProgressHUD/MBProgressHUD.h>
#import "UIImageView+AFNetworking.h"
#import "AFNetworking.h"
#import "ProfileVC.h"
#import "PNChart.h"
#import "DataEngine.h"
#import "User.h"
#import "WordLearned.h"
#import "FRDLivelyButton.h"
#import "SideMenuVC.h"
#import "TOMSMorphingLabel.h"
#import "AMSmoothAlertView.h"

@interface ProfileVC ()<ModelDelegate, AuthDelegate>

@end

@implementation ProfileVC
{
    
    __weak IBOutlet TOMSMorphingLabel *titleLb;
    IBOutlet UITextField *nameTF;

    IBOutlet UIButton *avatarBtn;
    __weak IBOutlet UIView *imgBGShade;
    __weak IBOutlet UIView *takeImageSolid;
    IBOutlet UIImageView *avatarImg;
    __weak IBOutlet UIImageView *avatarBG;
    IBOutlet UIView *chartView;
    
    
    __weak IBOutlet UILabel *totalWordTitleLb;
    IBOutlet UILabel *totalWordLb;
    IBOutlet UIActivityIndicatorView *wordLoadIndicator;
    
    PNBarChart * barChart;
    IBOutlet UIButton *changePassBtn;
    User *curUser;
    
    NSArray *xLabels;
    NSArray *yValues;
    
    BOOL wordListIsLoad;
    
    FRDLivelyButton *paneRevealLeftButton;
    __weak IBOutlet UIProgressView *imgProgressBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    curUser = [User currentUser];
    curUser.authDelegate = self;
    [self refreshView];
    [nameTF setFont:[UIFont fontWithName:@"GothamRounded-Bold" size:20]];
    takeImageSolid.layer.cornerRadius = 20;
    [self setupInitView];
    [self loadAvartar];
    
    
    [avatarImg setContentMode:UIViewContentModeScaleAspectFill];
    CALayer *avatarLayer = avatarImg.layer;
    [avatarLayer setCornerRadius:75.0f];
    [avatarLayer setMasksToBounds:YES];
    
    if ([[DataEngine getInstance] loginType] != LoginNormal) {
        [changePassBtn setEnabled:NO];
    }
    
    //For BarC hart
    barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180.0)];
    [chartView addSubview:barChart];
    [chartView setBackgroundColor:[UIColor clearColor]];
    
    self.tableView.separatorColor = [UIColor clearColor];
    [self.navigationController setNavigationBarHidden:YES];
    
}

-(void) loadAvartar
{
    if (curUser.avatarURL == nil) {
        [self displayDummyAvatar];
        return;
    }
    AFURLConnectionOperation * operation = [[DataEngine getInstance] getCacheImageOperation: curUser.avatarURL setCompletionBlock:^(NSString *localURL) {
        UIImage *storedavatarImg = [UIImage imageWithContentsOfFile:localURL];
        [avatarImg setImage:storedavatarImg];
        [avatarBG setImage:storedavatarImg];
        [MyUIEngine fadeOutButton:imgProgressBar withDelay:0.5];
        [self animateViewAppear];
    }];
    if (operation) {
        [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
            imgProgressBar.progress = (float)totalBytesRead / totalBytesExpectedToRead;
        }];
        [operation start];
    }
}
-(void) displayDummyAvatar
{
    NSLog(@"displayDummyAvatar runs");
    [MyUIEngine fadeOutButton:imgProgressBar withDelay:0.5];
    [avatarImg setImage:[UIImage imageNamed:@"dummyAvatar.png"]];
    NSString* imageURL = [NSString stringWithFormat:@"image%03ld.jpg", (unsigned long)(arc4random_uniform(13)+1)];
     [avatarBG setImage:[UIImage imageNamed:imageURL]];
     [self animateViewAppear];
}


#pragma mark -- Appear Animation
- (void) setupInitView
{
    self.tableView.bounces = NO;
    self.tableView.alwaysBounceVertical = NO;
    
    avatarImg.layer.opacity = 0;
    avatarBG.layer.opacity = 0;
    takeImageSolid.transform = CGAffineTransformMakeScale(0, 0);
    avatarBtn.transform = CGAffineTransformMakeScale(0, 0);
    nameTF.transform = CGAffineTransformMakeScale(0, 0);
    
    [titleLb setTextWithoutMorphing:@""];
    [self addMenuBtn];
    paneRevealLeftButton.transform = CGAffineTransformMakeScale(0, 0);
    
    totalWordTitleLb.transform = CGAffineTransformMakeScale(0, 0);
    totalWordLb.transform = CGAffineTransformMakeScale(0, 0);
    wordLoadIndicator.transform = CGAffineTransformMakeScale(0, 0);
}
- (void) animateViewAppear
{
    [titleLb setText:@"Cá Nhân"];
    [MyUIEngine popAppearButton:paneRevealLeftButton withDelay:0.1];
    
    [MyUIEngine fadeInButton:avatarBG];
    [MyUIEngine fadeInButton:avatarImg withDelay:0.3];
    [MyUIEngine popAppearButton:avatarImg withDelay:0.3];
    [MyUIEngine popAppearButton:takeImageSolid withDelay:0.4];
    [MyUIEngine popAppearButton:avatarBtn withDelay:0.5];
    [MyUIEngine popAppearButton:nameTF withDelay:0.6];
    
    [MyUIEngine popAppearButton:totalWordTitleLb withDelay:0.8];
    [MyUIEngine popAppearButton:totalWordLb withDelay:0.9];
    
}
-(void) viewDidAppear:(BOOL)animated
{
    if (!wordListIsLoad) {
        wordListIsLoad = YES;
        [self getWordLearnedList];
    }
    
}

-(void) addMenuBtn
{
    if (!paneRevealLeftButton) {
        paneRevealLeftButton = [[FRDLivelyButton alloc] initWithFrame:CGRectMake(15,12,30,22)];
        [paneRevealLeftButton setStyle:kFRDLivelyButtonStyleHamburger animated:NO];
        [paneRevealLeftButton addTarget:self action:@selector(leftBarButtonItemTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        [paneRevealLeftButton setOptions:@{ kFRDLivelyButtonLineWidth: @(2.0f),
                                                        kFRDLivelyButtonHighlightedColor: [UIColor colorWithRed:0.5 green:0.8 blue:1.0 alpha:1.0],
                                                        kFRDLivelyButtonColor: [UIColor whiteColor]
                                                        }];
        [self.view addSubview:paneRevealLeftButton];
    }
    
}

-(void) leftBarButtonItemTapped:(id)sender
{
    [[SideMenuVC getInstance] dynamicsDrawerRevealLeftBarButtonItemTapped:sender];
}

-(void) getWordLearnedList
{
    [MyUIEngine popAppearButton:wordLoadIndicator];
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
    [avatarImg setImage:img];
    [avatarBG setImage:img];
    
    avatarImg.layer.opacity = 0;
    avatarBG.layer.opacity = 0;
    [MyUIEngine fadeInButton:avatarBG];
    [MyUIEngine fadeInButton:avatarImg withDelay:0.3];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [curUser uploadImageWithURL:[self getImageFilePath:img:0]];
}
-(NSURL *) getImageFilePath :(UIImage*) image :(int)imageIndex
{
    NSError * error;
    NSArray * directoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:NSTemporaryDirectory() error:&error];
    NSLog(@"directoryContents ====== %@",directoryContents);
    
    NSData *pngData = UIImageJPEGRepresentation(image, 1.0f);
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

#pragma Tableview
- (CGFloat)tableView:(UITableView*)tableView
heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    }
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView*)tableView
heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView*)tableView:(UITableView*)tableView
viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (UIView*)tableView:(UITableView*)tableView
viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}
#pragma WordLearned
-(void)getAllSucessfull:(AModel *)model List:(NSMutableArray *)allList
{
    [MyUIEngine popDisappearButton:wordLoadIndicator];
    //NSLog(@"WordLearnedList = %@",allList);
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
    [MyUIEngine popDisappearButton:wordLoadIndicator];
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
}
-(void)uploadAvatarFailed:(User *)user WithError:(id)error StatusCode:(NSNumber *)statusCode
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSLog(@"uploadAvatarFailed - %@",error);
    [avatarImg setImage:[UIImage imageNamed:@"dummyAvatar.png"]];
    NSString* imageURL = [NSString stringWithFormat:@"image%03ld.jpg", (unsigned long)(arc4random_uniform(13)+1)];
    [avatarBG setImage:[UIImage imageNamed:imageURL]];
    AMSmoothAlertView *alert = [[AMSmoothAlertView alloc] initDropAlertWithTitle:@"Thông Báo"
                                                                         andText:@"Thay ảnh đại diện thất bại. Bạn thử lại nhé!"
                                                                 andCancelButton:NO
                                                                    forAlertType:AlertFailure withCompletionHandler:^(AMSmoothAlertView * alert, UIButton * button) {
                                                                        //[alert dismissAlertView];
                                                                    }];
    [alert show];
}
@end
