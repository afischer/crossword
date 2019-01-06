//
//  GameGrid.m
//  Crossword
//
//  Created by Andrew Fischer on 1/5/19.
//  Copyright © 2019 Andrew Fischer. All rights reserved.
//

#import "GameGrid.h"

@implementation GameGrid

- (void)awakeFromNib {
    self.delegate = self;
    self.dataSource = self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)setupWithCrossword:(Crossword *)crossword {
    self.crossword = crossword;
    
    [self beginUpdates];
    while ([self numberOfColumns] < crossword.width) {
        [self addTableColumn:[[NSTableColumn alloc] init]];
        NSLog(@"at %ld columns ", (long)self.numberOfColumns);
    }
    
    while ([self numberOfRows] < crossword.height) {
        [self insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:0] withAnimation:NO];
        NSLog(@"at %ld rows ", (long)self.numberOfRows);
    }

    [self endUpdates];
}



# pragma mark - NSTableViewDelegate
- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSUInteger col = [[self tableColumns] indexOfObject:tableColumn];
    [cell setDrawsBackground:YES];
    [cell setAlignment:NSTextAlignmentCenter];
    [cell setFont:[NSFont systemFontOfSize:16 weight:NSFontWeightRegular]];
//    [cell setFrame:NSMakeRect(0, self.rowHeight/2, tableColumn.width, self.rowHeight)];
    
    
//    NSRect(x:0.0, y:myTableView.rowHeight/2, width:tableColumn!.width, height:myTableView.rowHeight
    // NSMakeRect(0, self.rowHeight/2, tableColumn.width, self.rowHeight)
    if ([self.crossword isBlackAtX:(int)col Y:(int)row]) {
        [cell setBackgroundColor:[NSColor blackColor]];
    } else {
        [cell setBackgroundColor:[NSColor whiteColor]];
    }
}

//- (BOOL)control:(NSControl *)control textShouldBeginEditing:(NSText *)fieldEditor
//{
//    NSEvent *currentEvent = [NSApp currentEvent];
//    switch (currentEvent.type)
//    {
//        case NSLeftMouseUp:
//            if (currentEvent.clickCount<2)
//            {
//                return NO;
//            }
//            return YES;
//        case NSRightMouseUp:
//            return NO;
//        default:
//            return YES;
//    }

# pragma mark - NSTableViewDataSource
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
//    NSUInteger col = [[self tableColumns] indexOfObject:tableColumn];
//    NSView *view = [self viewAtColumn:col row:row makeIfNecessary:NO];
    return @"X";
}
@end
