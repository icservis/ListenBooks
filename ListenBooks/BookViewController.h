//
//  BookViewController.h
//  ListenBooks
//
//  Created by Libor Kučera on 18.12.13.
//  Copyright (c) 2013 IC Servis. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TabBarControllerProtocol.h"

static NSString* const FontNameDidChangeNotificaton = @"FONT_NAME_DID_CHANGE_NOTIFICATION";
static NSString* const FontSizeDidChangeNotificaton = @"FONT_SIZE_DID_CHANGE_NOTIFICATION";
static NSString* const ThemeDidChangeNotificaton = @"THEME_DID_CHANGE_NOTIFICATION";
static NSString* const VoiceNameDidChangeNotificaton = @"VOICE_NAME_DID_CHANGE_NOTIFICATION";
static NSString* const VoiceSpeedDidChangeNotificaton = @"VOICE_SPEED_DID_CHANGE_NOTIFICATION";

@class Book;

@interface BookViewController : NSViewController <TabBarControllerProtocol, NSPageControllerDelegate>

@property (strong) Book* book;
@property (strong, nonatomic) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, strong) NSTabViewItem* tabViewItem;

@end
