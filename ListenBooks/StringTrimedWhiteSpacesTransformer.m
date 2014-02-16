//
//  StringTrimedWhiteSpacesTransformer.m
//  ListenBooks
//
//  Created by Libor Kučera on 16/02/14.
//  Copyright (c) 2014 IC Servis. All rights reserved.
//

#import "StringTrimedWhiteSpacesTransformer.h"

@implementation StringTrimedWhiteSpacesTransformer

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
    
    NSString* string = (NSString*)value;
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

@end
