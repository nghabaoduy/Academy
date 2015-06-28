//
//  UserPackage.h
//  academy
//
//  Created by Nguyen Ha Bao Duy on 17/5/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "AModel.h"
#import "Package.h"
@class UserPackage;
@protocol UserPackageDelegate <NSObject>
- (void)updateUserPackageScoreSuccessful:(UserPackage *) userPackage;
- (void)updateUserPackageScoreWithError:(id)Error StatusCode:(NSNumber*)statusCode;
@end
@interface UserPackage : AModel
@property (nonatomic, weak) id <UserPackageDelegate> userPackageDelegate;

@property (nonatomic, strong) NSString * user_id;
@property (nonatomic, strong) NSString * package_id;
@property (nonatomic, strong) NSString * purchaseType;
@property (nonatomic, strong) Package * package;
@property (nonatomic, strong) NSNumber * score;
@property (nonatomic, strong) NSDate * createdAt;
@property (nonatomic, strong) NSDate * expriredAt;
@property (nonatomic, assign) BOOL isExpired;
-(void) updateScore:(NSNumber *) score;
@end
