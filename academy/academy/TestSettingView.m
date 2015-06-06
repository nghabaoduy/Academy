//
//  TestSettingView.m
//  academy
//
//  Created by Brian on 6/6/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "TestSettingView.h"
#import "MyCustomTextfield.h"
@interface TestSettingView ()

@end

@implementation TestSettingView
{

    IBOutlet MyCustomTextfield *totalWordTF;
    IBOutlet MyCustomTextfield *testTypeTF;
    UIPickerView *quantityPicker;
    UITextField * curTextField;
    TestType selectedTestType;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.scrollEnabled = NO;
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = backBtn;
    self.navigationItem.title = @"Kiểu Luyện Tập";
    
    totalWordTF.placeholder = @"Số lượng từ: ";
    testTypeTF.placeholder = @"Kiểu câu hỏi: ";
    
    totalWordTF.text = [NSString stringWithFormat:@"%i",_testMaker.testWordQuantity];
    testTypeTF.text = [TestMaker getTestTypeName:_testMaker.userPickedTestType];
}
-(void) goBack
{
    [self dismissViewControllerAnimated:YES completion:^{
        [MBProgressHUD hideHUDForView:_parentView.view animated:YES];
        _parentView = nil;
        _testMaker = nil;
    }];
}
- (IBAction)resetTest:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
        _testMaker.testWordQuantity = [totalWordTF.text intValue];
        _testMaker.userPickedTestType = selectedTestType;
        [_parentView restartTest];
        [MBProgressHUD hideHUDForView:_parentView.view animated:YES];
        _parentView = nil;
        _testMaker = nil;
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)launchPicker
{
    // Here we need to pass a full frame
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] initWithParentView:self.view];
    
    // Add some custom content to the alert view
    [alertView setContainerView:[self getQuantityPicker]];
    
    // Modify the parameters
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"OK", @"Cancel", nil]];
    
    // You may use a Block, rather than a delegate.
    [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
        if (buttonIndex == 0) {
            if (curTextField == totalWordTF) {
                totalWordTF.text = [NSString stringWithFormat:@"%i",([quantityPicker selectedRowInComponent:0]+1) * 5];
            }
            if (curTextField == testTypeTF) {
                if ([quantityPicker selectedRowInComponent:0] == 0) {
                    selectedTestType = TestTypeCount;
                    testTypeTF.text = [TestMaker getTestTypeName:TestTypeCount];
                }
                else{
                    selectedTestType = [quantityPicker selectedRowInComponent:0]-1;
                    testTypeTF.text = [TestMaker getTestTypeName:[quantityPicker selectedRowInComponent:0]-1];
                }
                
            }
        }
        [alertView close];
    }];
    
    [alertView setUseMotionEffects:true];
    
    // And launch the dialog
    [alertView show];
}

- (UIView *)getQuantityPicker
{
    if (quantityPicker == nil) {
        quantityPicker = [[UIPickerView alloc] init];
        quantityPicker.delegate = self;
        quantityPicker.dataSource = self;
        quantityPicker.frame = CGRectMake(0, 0, 300, 300);
    }
    else
    {
        [quantityPicker reloadAllComponents];
    }
    return quantityPicker;
}
#pragma mark - uipickerdatasource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (curTextField == totalWordTF) {
        return _testMaker.fullWordList.count/5;
    }
    if (curTextField == testTypeTF) {
        return TestTypeCount+1;
    }
    return 1;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (curTextField == totalWordTF) {
        if (row == _testMaker.fullWordList.count/5) {
            return [NSString stringWithFormat:@"%i",_testMaker.fullWordList.count];
        }
        return [NSString stringWithFormat:@"%i",((row+1) * 5)];
    }
    if (curTextField == testTypeTF) {
        if (row == 0) {
            return [TestMaker getTestTypeName:TestTypeCount];
        }
        return [TestMaker getTestTypeName:row-1];
    }
    return [NSString stringWithFormat:@"%i",row+1];
}
#pragma mark - UITextField delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    curTextField = textField;
    [self launchPicker];
    return NO;
}
@end
