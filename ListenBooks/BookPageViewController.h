//
//  BookPageViewController.h
//  ListenBooks
//
//  Created by Libor Kučera on 20/12/13.
//  Copyright (c) 2013 IC Servis. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BookPageViewController.h"

@protocol BookPageViewControllerDelegate <NSObject>

@optional

- (void)bookPageController:(id)controller textViewSelectionDidChange:(NSRange)range;

@end

@interface BookPageViewController : NSViewController <NSTextViewDelegate>

@property (nonatomic, weak) id <BookPageViewControllerDelegate> delegate;
@property (unsafe_unretained) IBOutlet NSTextView *textView;
@property (nonatomic, assign) NSInteger index;

@end
