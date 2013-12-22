//
//  ImageToDataTransformer.m
//  Leyter Mobile
//
//  Created by Libor Kučera on 05.03.13.
//  Copyright (c) 2013 IC Servis, s.r.o. All rights reserved.
//

#import "NSImageToData.h"

@implementation NSImageToData

+ (BOOL)allowsReverseTransformation {
	return YES;
}

+ (Class)transformedValueClass {
	return [NSData class];
}

- (id)transformedValue:(NSImage*)value {
    
    [value lockFocus];
    NSBitmapImageRep *bitmapRep = [[NSBitmapImageRep alloc] initWithFocusedViewRect:NSMakeRect(0, 0, value.size.width, value.size.height)];
    [value unlockFocus];
    
    return [bitmapRep representationUsingType:NSPNGFileType properties:Nil];
}


- (id)reverseTransformedValue:(id)value {
	return [[NSImage alloc] initWithData:value];
}

@end
