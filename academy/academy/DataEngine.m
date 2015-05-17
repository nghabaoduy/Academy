//
//  DataEngine.m
//  academy
//
//  Created by Nguyen Ha Bao Duy on 17/5/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "DataEngine.h"

@implementation DataEngine

static DataEngine * instance = nil;

+ (id)getInstance {
    if (instance == nil) {
        instance = [DataEngine new];
    }
    return instance;
}

- (NSString *)requestURL {
    return @"http://academy.openlabproduction.com/";
}

@end
