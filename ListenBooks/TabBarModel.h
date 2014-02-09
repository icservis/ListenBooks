//
//  CFGTabBarModel.h
//  TimeFrogMac
//
//  Created by Libor Kučera on 14.12.13.
//  Copyright (c) 2013 IC Servis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MMTabBarView/MMTabBarItem.h>

@interface TabBarModel : NSObject <MMTabBarItem> {
    NSString    *_title;
	BOOL        _isProcessing;
	NSImage     *_icon;
    NSImage     *_largeImage;
	NSString    *_iconName;
	NSInteger   _objectCount;
    NSColor     *_objectCountColor;
    BOOL        _showObjectCount;
	BOOL        _isEdited;
    BOOL        _hasCloseButton;
}

@property (copy)   NSString *title;
@property (retain) NSImage  *largeImage;
@property (retain) NSImage  *icon;
@property (retain) NSString *iconName;

@property (assign) BOOL      isProcessing;
@property (assign) NSInteger objectCount;
@property (retain) NSColor   *objectCountColor;
@property (assign) BOOL      showObjectCount;
@property (assign) BOOL      isEdited;
@property (assign) BOOL      hasCloseButton;

// designated initializer
- (id)init;

@end
