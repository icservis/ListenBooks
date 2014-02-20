//
//  Book.h
//  ListenBooks
//
//  Created by Libor Kučera on 03.03.14.
//  Copyright (c) 2014 IC Servis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Book, Bookmark, Page, Paragraph;

@interface Book : NSManagedObject

@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSNumber * canCollapse;
@property (nonatomic, retain) NSNumber * canExpand;
@property (nonatomic, retain) NSImage * cover;
@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSString * creator;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * encryption;
@property (nonatomic, retain) NSURL * fileUrl;
@property (nonatomic, retain) NSString * fontName;
@property (nonatomic, retain) NSNumber * fontSizeDelta;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSNumber * isEditable;
@property (nonatomic, retain) NSNumber * isExpanded;
@property (nonatomic, retain) NSNumber * isLeaf;
@property (nonatomic, retain) NSNumber * isSelectable;
@property (nonatomic, retain) NSNumber * isSmart;
@property (nonatomic, retain) NSNumber * isSpecialGroup;
@property (nonatomic, retain) NSString * language;
@property (nonatomic, retain) NSString * publisher;
@property (nonatomic, retain) NSString * rights;
@property (nonatomic, retain) NSString * source;
@property (nonatomic, retain) NSString * subject;
@property (nonatomic, retain) NSNumber * themeIndex;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSString * voiceIdentifier;
@property (nonatomic, retain) NSNumber * voiceSpeed;
@property (nonatomic, retain) NSSet *bookmarks;
@property (nonatomic, retain) NSSet *children;
@property (nonatomic, retain) NSOrderedSet *pages;
@property (nonatomic, retain) NSOrderedSet *paragraphs;
@property (nonatomic, retain) Book *parent;
@end

@interface Book (CoreDataGeneratedAccessors)

- (void)addBookmarksObject:(Bookmark *)value;
- (void)removeBookmarksObject:(Bookmark *)value;
- (void)addBookmarks:(NSSet *)values;
- (void)removeBookmarks:(NSSet *)values;

- (void)addChildrenObject:(Book *)value;
- (void)removeChildrenObject:(Book *)value;
- (void)addChildren:(NSSet *)values;
- (void)removeChildren:(NSSet *)values;

- (void)insertObject:(Page *)value inPagesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromPagesAtIndex:(NSUInteger)idx;
- (void)insertPages:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removePagesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInPagesAtIndex:(NSUInteger)idx withObject:(Page *)value;
- (void)replacePagesAtIndexes:(NSIndexSet *)indexes withPages:(NSArray *)values;
- (void)addPagesObject:(Page *)value;
- (void)removePagesObject:(Page *)value;
- (void)addPages:(NSOrderedSet *)values;
- (void)removePages:(NSOrderedSet *)values;
- (void)insertObject:(Paragraph *)value inParagraphsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromParagraphsAtIndex:(NSUInteger)idx;
- (void)insertParagraphs:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeParagraphsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInParagraphsAtIndex:(NSUInteger)idx withObject:(Paragraph *)value;
- (void)replaceParagraphsAtIndexes:(NSIndexSet *)indexes withParagraphs:(NSArray *)values;
- (void)addParagraphsObject:(Paragraph *)value;
- (void)removeParagraphsObject:(Paragraph *)value;
- (void)addParagraphs:(NSOrderedSet *)values;
- (void)removeParagraphs:(NSOrderedSet *)values;
@end
