//
//  UserPackage.h
//  academy
//
//  Created by Nguyen Ha Bao Duy on 17/5/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "AModel.h"
#import "Package.h"

@interface UserPackage : AModel

@property (nonatomic, strong) NSString * user_id;
@property (nonatomic, strong) NSString * package_id;
@property (nonatomic, strong) Package * package;

@end
