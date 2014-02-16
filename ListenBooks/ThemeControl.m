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
    NSDictionary* lightTheme = [[NSDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"Light", @"Theme Name"), @"Name", [NSColor colorWithCalibratedRed:1.000 green:1.000 blue:1.000 alpha:1], @"BackgroundColor", [NSColor colorWithCalibratedRed:0.141 green:0.141 blue:0.141 alpha:1], @"ForegroundColor", nil];
    NSDictionary* sepiaTheme = [[NSDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"Sepia", @"Theme Name"), @"Name", [NSColor colorWithCalibratedRed:0.973 green:0.945 blue:0.894 alpha:1], @"BackgroundColor", [NSColor colorWithCalibratedRed:0.314 green:0.200 blue:0.118 alpha:1], @"ForegroundColor", nil];
    NSDictionary* darkTheme = [[NSDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"Dark", @"Theme Name"), @"Name", [NSColor colorWithCalibratedRed:0.000 green:0.000 blue:0.000 alpha:1], @"BackgroundColor", [NSColor colorWithCalibratedRed:0.745 green:0.745 blue:0.745 alpha:1], @"ForegroundColor", nil];
    return @[lightTheme, sepiaTheme, darkTheme];
}

@end
