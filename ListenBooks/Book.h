//
//  Book.h
//  ListenBooks
//
//  Created by Libor Kučera on 21/12/13.
//  Copyright (c) 2013 IC Servis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Book, Bookmark;

@interface Book : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSURL* fileUrl;
@property (nonatomic, retain) NSImage* cover;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSNumber * encryption;
@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSString * language;
@property (nonatomic, retain) NSString * subject;
@property (nonatomic, retain) NSString * source;
@property (nonatomic, retain) NSString * rights;
@property (nonatomic, retain) NSString * publisher;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * creator;
@property (nonatomic, retain) NSNumber * canCollapse;
@property (nonatomic, retain) NSNumber * canExpand;
@property (nonatomic, retain) NSNumber * isEditable;
@property (nonatomic, retain) NSNumber * isExpanded;
@property (nonatomic, retain) NSNumber * isLeaf;
@property (nonatomic, retain) NSNumber * isSelectable;
@property (nonatomic, retain) NSNumber * isSmart;
@property (nonatomic, retain) NSNumber * isSpecialGroup;
@property (nonatomic, retain) NSSet *bookmarks;
@property (nonatomic, retain) Book *parent;
@property (nonatomic, retain) NSSet *children;
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

@end
