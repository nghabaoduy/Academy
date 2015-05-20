//
//  DataEngine.h
//  academy
//
//  Created by Nguyen Ha Bao Duy on 17/5/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataEngine : NSObject

+ (id)getInstance;

- (NSString*)requestURL;

@property (nonatomic, assign) BOOL isForceReload;

@end
