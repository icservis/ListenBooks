//
//  BookmarkView.h
//  ListenBooks
//
//  Created by Libor Kučera on 18.12.13.
//  Copyright (c) 2013 IC Servis. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class BookmarksController;

@interface BookmarksView : NSTableView

@property (unsafe_unretained) IBOutlet BookmarksController* bookmarksController;

@end
