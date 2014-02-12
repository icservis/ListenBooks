//
//  PreferencesWindowController.h
//  ListenBooks
//
//  Created by Libor Kučera on 12/02/14.
//  Copyright (c) 2014 IC Servis. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PreferencesWindowController : NSWindowController

@property (nonatomic, copy) void (^completionBlock)(BOOL success);

@end
