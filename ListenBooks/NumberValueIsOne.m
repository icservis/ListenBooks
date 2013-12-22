//
//  BooleanValueIsOne.m
//  RSSLoader
//
//  Created by Libor Kučera on 08.11.13.
//  Copyright (c) 2013 IC Servis. All rights reserved.
//

#import "NumberValueIsOne.h"

@implementation NumberValueIsOne

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
    
    NSNumber* val = (NSNumber*)value;
    
    if ([val isEqualToNumber:@1]) {
        return @YES;
    } else {
        return @NO;
    }
}

@end
