//
//  Word.h
//  academy
//
//  Created by Brian on 5/17/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSet.h"

@interface Word : NSObject

@property (nonatomic, retain) LSet *set;
@property (nonatomic, retain) NSString * awsId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phonentic;


-(id) initWithDict:(NSDictionary *) dict set:(LSet *) inSet;
-(void) loadDictInfo:(NSDictionary *) dict set:(LSet *) inSet;
-(NSString *) getMeaning: (NSString *) lang bExample:(BOOL) bExample;
-(NSString *) getWordType: (NSString *) lang;

@end
