//
//  LoanModel.h
//  Foundit-iOS
//
//  Created by Shaun Maharaj on 2013-03-07.
//  Copyright (c) 2013 Shaun Maharaj. All rights reserved.
//

#import "JSONModel.h"
//#import "LocationModel.h"

@protocol LoanModel @end
@interface LoanModel : JSONModel

@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* description;
//@property (strong, nonatomic) NSString* posting_type;

//@property (strong, nonatomic) LocationModel* location;

@end
