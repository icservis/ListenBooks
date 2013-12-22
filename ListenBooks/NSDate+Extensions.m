//
//  NSDate+Extensions.m
//  RSSLoader
//
//  Created by Libor Kučera on 07.11.13.
//  Copyright (c) 2013 IC Servis. All rights reserved.
//

#import "NSDate+Extensions.h"

@implementation NSDate (Extensions)

+ (NSDate*)nearPast
{
    return [NSDate dateWithTimeIntervalSinceNow:-86400];
}

+ (NSDate*)nearFuture
{
    return [NSDate dateWithTimeIntervalSinceNow:+86400];
}

@end
