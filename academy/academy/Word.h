//
//  Word.h
//  academy
//
//  Created by Brian on 5/17/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AModel.h"

@interface Word : AModel

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * wordType;
@property (nonatomic, retain) NSString * phonentic;
@property (nonatomic, retain) NSMutableArray * meaningList;

-(NSString *) getMeaning: (NSString *) lang bExample:(BOOL) bExample;
-(NSString *) getWordType: (NSString *) lang;

@end
