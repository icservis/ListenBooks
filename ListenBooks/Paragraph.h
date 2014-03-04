//
//  Paragraph.h
//  ListenBooks
//
//  Created by Libor Kučera on 04.03.14.
//  Copyright (c) 2014 IC Servis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Book, Page;

@interface Paragraph : NSManagedObject

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) Book *book;
@property (nonatomic, retain) Page *page;

@end
