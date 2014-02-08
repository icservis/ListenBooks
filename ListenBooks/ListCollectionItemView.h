//
//  ListCollectionItemView.h
//  ListenBooks
//
//  Created by Libor Kučera on 27/12/13.
//  Copyright (c) 2013 IC Servis. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Book.h"

@interface ListCollectionItemView : NSView

@property (weak) IBOutlet NSImageView *imageView;
@property (weak) IBOutlet NSTextField *titleField;
@property (weak) IBOutlet NSTextField *authorField;
@property (weak) IBOutlet NSBox *boxView;

@property (strong) Book* book;

- (IBAction)copy:(id)sender;
- (IBAction)paste:(id)sender;
- (IBAction)cut:(id)sender;
- (IBAction)open:(id)sender;
- (IBAction)delete:(id)sender;
- (IBAction)selectAll:(id)sender;

@end
