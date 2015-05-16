//
//  UserTest.m
//  academy
//
//  Created by Nguyen Ha Bao Duy on 16/5/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "User.h"
@interface UserTest : XCTestCase
{
    User * user;
}

@end

@implementation UserTest

- (void)setUp {
    [super setUp];
    NSDictionary * userInfoDict = @{
                                    @"first_name" : @"Test",
                                    @"last_name" : @"Ali ba bal",
                                    @"dob" : @"20/06/1993",
                                    @"username" : @"alibaba",
                                    @"email" : @"alibaba@40thieves.com"
                                    };
    
    user = [User new];
    [user setObjectWithDictionary:userInfoDict];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    user = nil;
    [super tearDown];
}

- (void)testUserAvailable {
    XCTAssertNotNil(user);
}

- (void)testFirstName {
    XCTAssertEqual(user.firstName, @"Test");
}

- (void)testLastName {
    XCTAssertEqual(user.lastName, @"Ali ba bal");
}

- (void)testFullName {
    XCTAssertTrue([user.fullName isEqualToString:@"Test Ali ba bal"]);
}

- (void)testUsername {
    XCTAssertEqual(user.userName, @"alibaba");
}

- (void)testEmail {
    XCTAssertEqual(user.email, @"alibaba@40thieves.com");
}

@end
