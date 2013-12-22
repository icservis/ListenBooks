//
//  ArrayCountToString.m
//  RSSLoader
//
//  Created by Libor Kučera on 14.11.13.
//  Copyright (c) 2013 IC Servis. All rights reserved.
//

#import "ArrayCountToString.h"

@implementation ArrayCountToString

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
    
    NSArray* val = (NSArray*)value;
    
    return [NSString stringWithFormat:@"%ld", [val count]];
}

@end
