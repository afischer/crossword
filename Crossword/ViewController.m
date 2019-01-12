//
//  ViewController.m
//  Crossword
//
//  Created by Andrew Fischer on 12/25/18.
//  Copyright © 2018 Andrew Fischer. All rights reserved.
//

#import "ViewController.h"
#import "Document.h"
#import "Crossword.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // UNCOMMENT FOR AUTOLAYOUT DEBUGGING:
//    NSUserDefaults *d = [[NSUserDefaults alloc]init];
//    [d setValue:@"YES" forKey:@"NSConstraintBasedLayoutVisualizeMutuallyExclusiveConstraints"];
}

- (void)viewDidAppear {
    if (!self.view.window.windowController.document) return; // no document
    
    Document *puzzleDoc = self.view.window.windowController.document;
    if (!puzzleDoc.crossword) return; // no valid crossword
    
    self.crossword = puzzleDoc.crossword;
    self.view.window.title = self.crossword.name;
    
    // set text labels
    [self.titleText setStringValue:self.crossword.name];
    [self.authorText setStringValue:self.crossword.author];
    [self.copyrightText setStringValue:self.crossword.copyright];

    
    // set and reload data for clue lists
    [self.acrossList setClueList:self.crossword.acrossClues];
    [self.downList setClueList:self.crossword.downClues];
    [self.acrossList reloadData];
    [self.downList reloadData];
    
    // Initialize game board
    [self.gameTable setupWithCrossword:self.crossword];
    
    // table sizing
    [self.gameTable sizeToFit];
    // FIXME: for asymetric puzzles, this will break if the puzzle is taller than wide
    self.gameTable.rowHeight = self.gameTable.tableColumns[0].width;
}
@end
