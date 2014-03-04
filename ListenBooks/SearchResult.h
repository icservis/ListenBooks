//
//  SearchResult.h
//  ListenBooks
//
//  Created by Libor Kučera on 03.03.14.
//  Copyright (c) 2014 IC Servis. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Book, Page, Paragraph;

@interface SearchResult : NSObject

@property (nonatomic, copy) NSAttributedString* title;
@property (nonatomic, strong) Paragraph* paragraph;
@property (nonatomic, strong) Page* page;
@property (nonatomic, strong) NSNumber* positionInParagraph;
@property (nonatomic, strong) NSNumber* positionInPage;
@property (nonatomic, strong) NSNumber* pageIndex;

@end