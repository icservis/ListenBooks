//
//  StringToPredicateTransformer.m
//  RSSLoader
//
//  Created by Libor Kučera on 06.11.13.
//  Copyright (c) 2013 IC Servis. All rights reserved.
//

#import "StringToPredicateTransformer.h"
#import "NSDate+Extensions.h"

@implementation StringToPredicateTransformer

+ (Class)transformedValueClass
{
    return [NSPredicate class];
}

+ (BOOL)allowsReverseTransformation
{
    return NO;
}

- (id)transformedValue:(id)value
{
    // The search field in the nib calls the reverse transform function.
    
    NSPredicate* predicate;
    if (value != nil) {
        NSPredicate* predicateTemplate = [NSPredicate predicateWithFormat:value];
        predicate = [predicateTemplate predicateWithSubstitutionVariables:[NSDictionary dictionaryWithObject:[NSDate nearPast] forKey:@"DATE"]];
        
    } else {
        predicate = [NSPredicate predicateWithValue:NO];
    }
    
    //NSLog(@"predicate: %@", predicate);
    return predicate;
}

@end
