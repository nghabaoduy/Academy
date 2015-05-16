//
//  AModelTest.m
//  academy
//
//  Created by Nguyen Ha Bao Duy on 16/5/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "AModel.h"

@interface AModelTest : XCTestCase <ModelDelegate>
{
    AModel * newModel;
    BOOL _callbackInvoked;
    XCTestExpectation *_expectation;
    NSString * resultValue;
    NSArray * findAllValue;
    

    AModel * findIdModel;
    
}

@end

@implementation AModelTest

- (void)setUp {
    [super setUp];
    newModel= [AModel new];
    [newModel setModelId:@"100"];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    
    newModel = nil;
    [super tearDown];
}

- (void)testModelId {
    XCTAssertEqual(newModel.modelId, @"100");
}


//Delegate
- (void)updateModelSuccessful:(AModel *)model {
    _callbackInvoked = YES;
    resultValue =model.modelId;
}

- (void)deleteModelSuccessful:(AModel *)model {
    
}

- (void)createModelSuccessful:(AModel *)model {
    _callbackInvoked = YES;
    resultValue =model.modelId;
}

- (void)findIdSuccessful:(AModel *)model {
    
}

- (void)getAllSucessfull:(NSArray *)allList {
    
}



@end
