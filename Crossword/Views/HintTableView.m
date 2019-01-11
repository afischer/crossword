//
//  HintTableView.m
//  Crossword
//
//  Created by Andrew Fischer on 1/11/19.
//  Copyright © 2019 Andrew Fischer. All rights reserved.
//

#import "HintTableView.h"

@implementation HintTableView
- (void)awakeFromNib {
    self.delegate = self;
    self.dataSource = self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
}

- (void)setClueList:(NSDictionary *)clues {
    self.clues = clues;
    
    self.clueKeys = [[self.clues allKeys] sortedArrayUsingComparator:
        ^NSComparisonResult(NSString *string1, NSString *string2) {
            return [string1 compare: string2 options: NSNumericSearch];
        }
     ];
}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.clues.count;
}
/*
- (id)tableView:(NSTableView *)tableView
  objectValueForTableColumn:(NSTableColumn *)tableColumn
            row:(NSInteger)row {
    
    NSString *clueNum = self.clueKeys[row];
    if ([tableColumn.identifier isEqualTo:@"number"]) {
        return [clueNum stringByAppendingString:@"."];
    } else {
        return self.clues[clueNum];
    }

    // TOOD: Throw something here?
    return @"";
}
*/
- (NSView *)tableView:(NSTableView *)tableView
   viewForTableColumn:(NSTableColumn *)tableColumn
                  row:(NSInteger)row {
//    NSTextView *cell = [tableView makeViewWithIdentifier:@"hintLabelView" owner:nil];
    NSTextView *cell = [[NSTextView alloc] init];
    [cell setDrawsBackground:NO];
//    [cell respondsToSelector:NO];
//    [cell isEditable:NO];
    
    
    NSString *clueNum = self.clueKeys[row];
    
    if ([tableColumn.identifier isEqualTo:@"number"]) {
        cell.font = [NSFont systemFontOfSize:12 weight:NSFontWeightBold];
        cell.string = [clueNum stringByAppendingString:@"."];
    } else {
        cell.string = self.clues[clueNum];
    }
    return cell;
}

- (BOOL) selectHintWithKey:(NSString *)key {
    NSString *keyString = [key stringByAppendingString:@"."];
    int index = -1;
    for (int row = 0; row < self.numberOfRows; row++) {
        NSTextView *cell = [self viewAtColumn:0 row:row makeIfNecessary:NO];
        if ([cell.string isEqualToString:keyString]) {
            index = row;
            break;
        }
    }
    if (index < 0) {
        return NO; // no hint found
    }
    [self selectRowIndexes:[NSIndexSet indexSetWithIndex:index] byExtendingSelection:NO];
    [self scrollRowToVisible:index];
    return YES;
}
@end
