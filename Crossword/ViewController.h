//
//  ViewController.h
//  Crossword
//
//  Created by Andrew Fischer on 12/25/18.
//  Copyright © 2018 Andrew Fischer. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController <NSTableViewDelegate>
@property (weak) IBOutlet NSTableView *acrossList;
@property (weak) IBOutlet NSTableView *downList;
@property (weak) IBOutlet NSTextField *titleText;
@property (weak) IBOutlet NSTextField *authorText;
@property (weak) IBOutlet NSTextField *copyrightText;
@property (weak) IBOutlet NSView *gameView;
@end

