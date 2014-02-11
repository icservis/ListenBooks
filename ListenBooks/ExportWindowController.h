//
//  ExportWindowController.h
//  ListenBooks
//
//  Created by Libor Kučera on 11/02/14.
//  Copyright (c) 2014 IC Servis. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Book;

@interface ExportWindowController : NSWindowController

@property (nonatomic, strong) Book* book;
@property (nonatomic, copy) void (^completionBlock)(BOOL success);

@end
