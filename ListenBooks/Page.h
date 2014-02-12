//
//  Page.h
//  ListenBooks
//
//  Created by Libor Kučera on 12/02/14.
//  Copyright (c) 2014 IC Servis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Book;

@interface Page : NSManagedObject

@property (nonatomic, retain) NSNumber * sortIndex;
@property (nonatomic, retain) NSAttributedString* data;
@property (nonatomic, retain) Book *book;

@end
