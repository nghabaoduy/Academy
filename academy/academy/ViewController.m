//
//  ViewController.m
//  academy
//
//  Created by Brian on 5/13/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "ViewController.h"
#import "UserShelfNavVC.h"
#import "ShopNavVC.h"
#import "AModel.h"

@interface ViewController () <ModelDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"here");
    AModel * newModel = [AModel new];
    newModel.delegate = self;
    newModel.modelId = @"100";
    [newModel updateModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login:(id)sender {
    //ShopNavVC * view = [self.storyboard instantiateViewControllerWithIdentifier:@"shopNavView"];
    UserShelfNavVC * view = [self.storyboard instantiateViewControllerWithIdentifier:@"userShelfNavView"];
    [self presentViewController:view animated:NO completion:nil];
    
}

+ (void)findIdSuccessful:(AModel *)model {
    NSLog(@"model Id %@", model.modelId);
}

- (void)updateModelSuccessful:(AModel *)model {
    NSLog(@"model Id %@", model.modelId);

}




@end
