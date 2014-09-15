//
//  KMNImageTransformer.m
//  Homepwner
//
//  Created by Michael Nwani on 9/14/14.
//  Copyright (c) 2014 Michael Nwani. All rights reserved.
//

#import "KMNImageTransformer.h"

@implementation KMNImageTransformer

+(Class)transformedValueClass
{
    return [NSData class];
}

-(id)transformedValue:(id)value
{
    if (!value)
    {
        return nil;
    }
    if ([value isKindOfClass:[NSData class]])
    {
        return value;
    }
    
    return UIImagePNGRepresentation(value);
}

-(id)reverseTransformedValue:(id)value
{
    return [UIImage imageWithData:value];
}

@end
