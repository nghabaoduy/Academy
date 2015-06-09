//
//  Meaning.h
//  academy
//
//  Created by Nguyen Ha Bao Duy on 18/5/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "AModel.h"

@interface Meaning : AModel

@property (nonatomic, strong) NSString * language;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * wordId;
@property (nonatomic, strong) NSString * example;
@property (nonatomic, strong) NSString * wordSubDictStr;
@property (nonatomic, strong) NSDictionary * wordSubDict;

@end
