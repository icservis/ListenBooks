//
//  NSAttributedStringToData.m
//  ListenBooks
//
//  Created by Libor Kučera on 12/02/14.
//  Copyright (c) 2014 IC Servis. All rights reserved.
//

#import "NSAttributedStringToData.h"

@implementation NSAttributedStringToData

+ (BOOL)allowsReverseTransformation {
	return YES;
}

+ (Class)transformedValueClass {
	return [NSData class];
}

- (id)transformedValue:(NSAttributedString*)value {
    
    NSDictionary* options = [[NSDictionary alloc] initWithObjectsAndKeys: nil];
    return [value RTFDFromRange:NSMakeRange(0, value.length) documentAttributes:options];
}

- (id)reverseTransformedValue:(id)value {
    NSError* error;
    NSDictionary* options = [[NSDictionary alloc] initWithObjectsAndKeys: nil];
	return [[NSAttributedString alloc] initWithData:value options:options documentAttributes:nil error:&error];
}

@end
