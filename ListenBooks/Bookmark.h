//
//  Bookmark.h
//  ListenBooks
//
//  Created by Libor Kučera on 21/12/13.
//  Copyright (c) 2013 IC Servis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Book;

@interface Bookmark : NSManagedObject

@property (nonatomic, retain) NSNumber * page;
@property (nonatomic, retain) NSNumber * position;
@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) Book *book;

@end
