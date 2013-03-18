//
//  LocationModel.h
//  Foundit-iOS
//
//  Created by Shaun Maharaj on 2013-03-07.
//  Copyright (c) 2013 Shaun Maharaj. All rights reserved.
//

#import "JSONModel.h"
#import "LocationModel.h"

@interface LocationModel : JSONModel

@property (strong, nonatomic) LocationModel* location;
@property (strong, nonatomic) NSString* country_code;
@property (strong, nonatomic) NSString* country;

@end
