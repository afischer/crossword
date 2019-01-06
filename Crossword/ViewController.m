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
    self.downList.delegate = self;
    self.acrossList.delegate = self;
    self.downList.dataSource = self;
    self.acrossList.dataSource = self;
//    NSUserDefaults *d = [[NSUserDefaults alloc]init];
//    [d setValue:@"YES" forKey:@"NSConstraintBasedLayoutVisualizeMutuallyExclusiveConstraints"];
}

- (void)viewDidAppear {

    Document *puzzleDoc = self.view.window.windowController.document;
    if (!puzzleDoc.crossword) return;
    
    self.crossword = puzzleDoc.crossword;
    
    [self.titleText setStringValue:self.crossword.name];
    [self.authorText setStringValue:self.crossword.author];
    [self.copyrightText setStringValue:self.crossword.copyright];
    
    
    self.acrossKeys = [[self.crossword.acrossClues allKeys] sortedArrayUsingComparator:^NSComparisonResult(
                                                                                                    NSString *string1, NSString *string2) {
        return [string1 compare: string2 options: NSNumericSearch];
    }];
    
    self.downKeys = [[self.crossword.downClues allKeys]
                      sortedArrayUsingComparator:^NSComparisonResult(
                          NSString *string1, NSString *string2) {
                          return [string1 compare: string2 options: NSNumericSearch];
    }];
    
    // reload data for clue lists set in viewDidLoad
    [self.acrossList reloadData];
    [self.downList reloadData];
    
    
    /*
    [self.gameTable beginUpdates];
    while ([self.gameTable numberOfColumns] < self.crossword.width) {
        [self.gameTable addTableColumn:[[NSTableColumn alloc] init]];
        NSLog(@"at %ld columns ", (long)self.gameTable.numberOfColumns);
    }
    
    while ([self.gameTable numberOfRows] < self.crossword.height) {
        [self.gameTable insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:0] withAnimation:NO];
        NSLog(@"at %ld rows ", (long)self.gameTable.numberOfRows);
    }
    [self.gameTable endUpdates];
    */
    
    [self.gameTable setupWithCrossword:self.crossword];
    // TODO: MAKE A DELEGATE FOR THE GAME BOARD
    

    

    // table sizing
    [self.gameTable sizeToFit];
    
    // FIXME: for asymetric puzzles, this will break if the puzzle is taller than wide
    self.gameTable.rowHeight = self.gameTable.tableColumns[0].width;
    
    
//    for (int y = 0; y < self.gameTable.numberOfColumns; y++) {
//        for (int x = 0; x < self.gameTable.numberOfRows; x++) {
//            NSTableCellView *cell = [self.gameTable viewAtColumn:y row:x makeIfNecessary:NO];
//            if ([self.crossword isBlackAtX:x Y:y]) {
////                cell.wantsLayer = YES;
////                cell.layer.backgroundColor = [[NSColor blackColor] CGColor];
////                cell.textField.stringValue = @"X";
//            }
//        }
//    }


}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    // Update the view, if already loaded.
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    if ([tableView.identifier isEqualTo: @"across"]) {
        return self.crossword.acrossClues.count;
    } else {
        return self.crossword.downClues.count;
    }
}

- (id)tableView:(NSTableView *)tableView
 objectValueForTableColumn:(NSTableColumn *)tableColumn
             row:(NSInteger)row {
    
    if ([tableView.identifier isEqualTo: @"across"]) {
        NSString *clueNum = self.acrossKeys[row];
        if ([tableColumn.identifier isEqualTo:@"number"]) {
            return [clueNum stringByAppendingString:@"."];
        } else {
            return self.crossword.acrossClues[clueNum];
        }
    } else {
        NSString *clueNum = self.downKeys[row];
        if ([tableColumn.identifier isEqualTo:@"number"]) {
            return [clueNum stringByAppendingString:@"."];
        } else {
            return self.crossword.downClues[clueNum];
        }
    }
    // TOOD: Throw something here?
    return @"";
}


@end
