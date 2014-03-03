//
//  Bookmark.m
//  ListenBooks
//
//  Created by Libor Kučera on 03.03.14.
//  Copyright (c) 2014 IC Servis. All rights reserved.
//

#import "Bookmark.h"
#import "Book.h"
#import "Page.h"
#import "Paragraph.h"


@implementation Bookmark

@dynamic created;
@dynamic position;
@dynamic timestamp;
@dynamic title;
@dynamic book;
@dynamic page;
@dynamic paragraph;

-(BOOL)validateValue:(__autoreleasing id *)value forKey:(NSString *)key error:(NSError *__autoreleasing *)error
{
    if ([key isEqualToString:@"title"]) {
        if ([*value length] == 0) {
            
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey:
                                           NSLocalizedString(@"Title can not be empty!", nil),
                                       NSLocalizedRecoverySuggestionErrorKey:
                                           NSLocalizedString(@"Please supply correct value.", nil)
                                       };
            *error = [NSError errorWithDomain:ListenBooksErrorDomain code:-1 userInfo:userInfo];
            
            return NO;
        }
    }
    return YES;
}

@end
