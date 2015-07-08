//
//  PackageTryBuyStatus.h
//  academy
//
//  Created by Mac Mini on 7/6/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "AModel.h"
typedef void(^completion)(BOOL finished);
@interface PackageTryBuyStatus : AModel

@property (nonatomic, assign) int tryCount;
@property (nonatomic, assign) int buyCount;
- (void)refreshPackStatuswithCompletion:(completion) block;
@end
