//
//  LSet.h
//  academy
//
//  Created by Brian on 5/17/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Package.h"
@interface LSet : NSObject

@property (nonatomic, retain) Package * package;
@property (nonatomic, retain) NSString * awsId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * desc;
@property int orderNo;

@property (nonatomic, retain) NSMutableArray * wordList;

-(id) initWithDict:(NSDictionary *) dict package:(Package *) pack;
-(void) loadDictInfo:(NSDictionary *) dict  package:(Package *) pack;

@end
