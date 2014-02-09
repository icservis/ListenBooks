//
//  CFGTabBarModel.m
//  TimeFrogMac
//
//  Created by Libor Kučera on 14.12.13.
//  Copyright (c) 2013 IC Servis. All rights reserved.
//

#import "TabBarModel.h"

@implementation TabBarModel

@synthesize title = _title;
@synthesize largeImage = _largeImage;
@synthesize icon = _icon;
@synthesize iconName = _iconName;

@synthesize isProcessing = _isProcessing;
@synthesize objectCount = _objectCount;
@synthesize objectCountColor = _objectCountColor;
@synthesize showObjectCount = _showObjectCount;
@synthesize isEdited = _isEdited;
@synthesize hasCloseButton = _hasCloseButton;

- (id)init {
	if (self = [super init]) {
		_isProcessing = NO;
		_icon = nil;
		_iconName = nil;
        _largeImage = nil;
		_objectCount = 0;
		_isEdited = NO;
        _hasCloseButton = YES;
        _title = @"Untitled";
        _objectCountColor = nil;
        _showObjectCount = NO;
	}
	return self;
}

@end
