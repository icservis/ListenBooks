//
//  Page.h
//  ListenBooks
//
//  Created by Libor Kučera on 04.03.14.
//  Copyright (c) 2014 IC Servis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Book, Bookmark, Paragraph;

@interface Page : NSManagedObject

@property (nonatomic, retain) NSAttributedString * data;
@property (nonatomic, retain) Book *book;
@property (nonatomic, retain) NSSet *bookmarks;
@property (nonatomic, retain) NSSet *paragraphs;
@end

@interface Page (CoreDataGeneratedAccessors)

- (void)addBookmarksObject:(Bookmark *)value;
- (void)removeBookmarksObject:(Bookmark *)value;
- (void)addBookmarks:(NSSet *)values;
- (void)removeBookmarks:(NSSet *)values;

- (void)addParagraphsObject:(Paragraph *)value;
- (void)removeParagraphsObject:(Paragraph *)value;
- (void)addParagraphs:(NSSet *)values;
- (void)removeParagraphs:(NSSet *)values;

@end
