//
//  Paragraph.h
//  ListenBooks
//
//  Created by Libor Kučera on 03.03.14.
//  Copyright (c) 2014 IC Servis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Book, Bookmark, Page;

@interface Paragraph : NSManagedObject

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) Book *book;
@property (nonatomic, retain) NSSet *bookmarks;
@property (nonatomic, retain) Page *page;
@end

@interface Paragraph (CoreDataGeneratedAccessors)

- (void)addBookmarksObject:(Bookmark *)value;
- (void)removeBookmarksObject:(Bookmark *)value;
- (void)addBookmarks:(NSSet *)values;
- (void)removeBookmarks:(NSSet *)values;

@end
