//
//  Package.h
//  academy
//
//  Created by Brian on 5/17/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AModel.h"

@interface Package : AModel

@property (nonatomic, retain) NSString * awsId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * oldPrice;
@property (nonatomic, retain) NSString * price;
@property (nonatomic, retain) NSString * language;
@property (nonatomic, retain) NSString * roleCanView;
@property (nonatomic, retain) NSString * orderCode;
@property (nonatomic, retain) NSString * expiryTime;
@property int wordsTotal;

@property (nonatomic, retain) NSMutableArray * setList;
@property (nonatomic, retain) NSString * imgURL;

-(NSArray *) getWordsFromPackageWithQuantity:(int) quan;
@end
