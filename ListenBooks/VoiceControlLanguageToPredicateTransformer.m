//
//  VoiceControlLanguageToPredicateTransformer.m
//  ListenBooks
//
//  Created by Libor Kučera on 15/02/14.
//  Copyright (c) 2014 IC Servis. All rights reserved.
//

#import "VoiceControlLanguageToPredicateTransformer.h"

@implementation VoiceControlLanguageToPredicateTransformer

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
        
        NSArray* languageParts = [value componentsSeparatedByString:@"-"];
        
        predicate = [NSPredicate predicateWithFormat:@"VoiceLanguage BEGINSWITH %@", languageParts[0]];
        
    } else {
        predicate = [NSPredicate predicateWithValue:NO];
    }
    return predicate;
}

@end
