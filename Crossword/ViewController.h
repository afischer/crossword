//
//  ViewController.h
//  Crossword
//
//  Created by Andrew Fischer on 12/25/18.
//  Copyright © 2018 Andrew Fischer. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Crossword.h"
#import "GameGridView.h"

@interface ViewController : NSViewController <NSTableViewDelegate, NSTableViewDataSource>
@property (weak) IBOutlet NSTableView *acrossList;
@property (weak) IBOutlet NSTableView *downList;
@property (weak) IBOutlet NSTextField *titleText;
@property (weak) IBOutlet NSTextField *authorText;
@property (weak) IBOutlet NSTextField *copyrightText;
@property (weak) IBOutlet GameGridView *gameTable;
@property (strong, nonatomic) Crossword *crossword;
@property (strong, nonatomic) NSArray* acrossKeys;
@property (strong, nonatomic) NSArray* downKeys;
@end

