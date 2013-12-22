//
//  NumberToString.m
//  RSSLoader
//
//  Created by Libor Kučera on 13.11.13.
//  Copyright (c) 2013 IC Servis. All rights reserved.
//

#import "NumberToString.h"

@implementation NumberToString

+ (Class)transformedValueClass
{
    return [NSString class];
}

+ (BOOL)allowsReverseTransformation
{
    return NO;
}

- (id)transformedValue:(id)value
{
    // The search field in the nib calls the reverse transform function.
    
    NSNumber* val = (NSNumber*)value;
    
    return [val stringValue];
}

@end
