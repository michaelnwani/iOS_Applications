//
//  KMNColorDescription.m
//  Colorboard
//
//  Created by Michael Nwani on 9/15/14.
//  Copyright (c) 2014 Michael Nwani. All rights reserved.
//

#import "KMNColorDescription.h"

@implementation KMNColorDescription

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        _color = [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:1.0];
        
        _name = @"Blue";
    }
    
    return self;
}
@end
