//
//  Package.h
//  academy
//
//  Created by Brian on 5/17/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Package : NSObject

@property (nonatomic, retain) NSString * awsId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * price;
@property int wordsTotal;

@property (nonatomic, retain) NSMutableArray * setList;

-(id) initWithDict:(NSDictionary *) dict;
-(void) loadDictInfo:(NSDictionary *) dict;
@end
