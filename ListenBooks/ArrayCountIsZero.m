//
//  ArrayCountIsZero.m
//  RSSLoader
//
//  Created by Libor Kučera on 14.11.13.
//  Copyright (c) 2013 IC Servis. All rights reserved.
//

#import "ArrayCountIsZero.h"

@implementation ArrayCountIsZero

+ (Class)transformedValueClass
{
    return [NSNumber class];
}

+ (BOOL)allowsReverseTransformation
{
    return NO;
}

- (id)transformedValue:(id)value
{
    // The search field in the nib calls the reverse transform function.
    
    NSArray* val = (NSArray*)value;
    
    if (val == nil || [val count] == 0) {
        return @YES;
    } else {
        return @NO;
    }
}

@end
