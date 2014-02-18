//
//  BookPageView.h
//  ListenBooks
//
//  Created by Libor Kučera on 18/02/14.
//  Copyright (c) 2014 IC Servis. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TabBarControllerProtocol.h"

@protocol BookPageViewDelegate <TabBarControllerProtocol>

@end

@interface BookPageView : NSView

@property (nonatomic, weak) id <BookPageViewDelegate> delegate;

- (IBAction)new:(id)sender;

@end
