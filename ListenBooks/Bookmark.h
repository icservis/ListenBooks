//
//  Bookmark.h
//  ListenBooks
//
//  Created by Libor Kučera on 04.03.14.
//  Copyright (c) 2014 IC Servis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Book, Page;

@interface Bookmark : NSManagedObject

@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSNumber * pageIndex;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * rangeLocation;
@property (nonatomic, retain) NSNumber * rangeLength;
@property (nonatomic, retain) Book *book;
@property (nonatomic, retain) Page *page;

@end
