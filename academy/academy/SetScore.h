//
//  SetScore.h
//  academy
//
//  Created by Brian on 6/4/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "AModel.h"

@interface SetScore : AModel

@property (nonatomic, strong) NSString * user_id;
@property (nonatomic, strong) NSString * set_id;
@property (nonatomic, strong) NSNumber *score;

@end
