//
//  ThemeControl.m
//  ListenBooks
//
//  Created by Libor Kučera on 16/02/14.
//  Copyright (c) 2014 IC Servis. All rights reserved.
//

#import "ThemeControl.h"

@implementation ThemeControl

- (NSArray*)arrangedObjects
{
    NSDictionary* lightTheme = [[NSDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"Light", @"Theme Name"), @"Name", [NSColor colorWithCalibratedRed:0.975 green:0.975 blue:0.975 alpha:1], @"BackgroundColor", [NSColor colorWithCalibratedRed:0.282 green:0.282 blue:0.282 alpha:1], @"ForegroundColor", nil];
    NSDictionary* sepiaTheme = [[NSDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"Sepia", @"Theme Name"), @"Name", [NSColor colorWithCalibratedRed:0.975 green:0.975 blue:0.975 alpha:1], @"BackgroundColor", [NSColor colorWithCalibratedRed:0.900 green:0.655 blue:0.300 alpha:1], @"ForegroundColor", nil];
    NSDictionary* darkTheme = [[NSDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"Dark", @"Theme Name"), @"Name", [NSColor colorWithCalibratedRed:0.282 green:0.282 blue:0.282 alpha:1], @"BackgroundColor", [NSColor colorWithCalibratedRed:0.975 green:0.975 blue:0.975  alpha:1], @"ForegroundColor", nil];
    return @[lightTheme, sepiaTheme, darkTheme];
}

@end
