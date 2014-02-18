//
//  BookViewController.h
//  ListenBooks
//
//  Created by Libor Kučera on 18.12.13.
//  Copyright (c) 2013 IC Servis. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TabBarControllerProtocol.h"
#import "BookPageView.h"

@class Book;
@class Bookmark;

static NSString* const FontNameDidChangeNotificaton = @"FONT_NAME_DID_CHANGE_NOTIFICATION";
static NSString* const FontSizeDidChangeNotificaton = @"FONT_SIZE_DID_CHANGE_NOTIFICATION";
static NSString* const ThemeDidChangeNotificaton = @"THEME_DID_CHANGE_NOTIFICATION";
static NSString* const VoiceNameDidChangeNotificaton = @"VOICE_NAME_DID_CHANGE_NOTIFICATION";
static NSString* const VoiceSpeedDidChangeNotificaton = @"VOICE_SPEED_DID_CHANGE_NOTIFICATION";


@interface BookViewController : NSViewController <TabBarControllerProtocol, NSPageControllerDelegate, NSTableViewDelegate, NSTableViewDataSource, BookPageViewDelegate>

@property (nonatomic, strong) Book* book;
@property (nonatomic, strong) Bookmark* bookmark;
@property (nonatomic, strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, strong) NSTabViewItem* tabViewItem;

- (IBAction)add:(id)sender;
- (IBAction)edit:(id)sender;
- (IBAction)remove:(id)sender;
- (IBAction)export:(id)sender;

@end
