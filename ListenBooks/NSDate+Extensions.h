//
//  NSDate+Extensions.h
//  RSSLoader
//
//  Created by Libor Kučera on 07.11.13.
//  Copyright (c) 2013 IC Servis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extensions)

+ (NSDate*)nearPast;
+ (NSDate*)nearFuture;

@end
