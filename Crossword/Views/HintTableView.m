//
//  HintTableView.m
//  Crossword
//
//  Created by Andrew Fischer on 1/11/19.
//  Copyright © 2019 Andrew Fischer. All rights reserved.
//

#import "HintTableView.h"
#import "ViewController.h"

// Subclass NSTextView to override hitTest:point
@interface NoClickLabel : NSTextView @end
@implementation NoClickLabel
- (instancetype)init {
    self = [super init];
    self.drawsBackground = NO;
    self.selectable = NO;
    return self;
}
- (NSView *)hitTest:(NSPoint)point { return nil; }
@end

@implementation HintTableView
- (void)awakeFromNib {
    self.delegate = self;
    self.dataSource = self;
    [self sizeToFit];
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

// TODO: Autolayout so automatic height can be used
- (NSView *)tableView:(NSTableView *)tableView
   viewForTableColumn:(NSTableColumn *)tableColumn
                  row:(NSInteger)row {
    NoClickLabel *cell = [[NoClickLabel alloc] init];
    
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

// use mousedown because row selection can change without clicking.
- (void)mouseDown:(NSEvent *)event {
    [super mouseDown:event]; // click row
    
    NSTextView *selectedCell = [self viewAtColumn:0
                                              row:self.selectedRow
                                  makeIfNecessary:NO];

    NSString *hintNumString = [selectedCell.string substringWithRange:NSMakeRange(0, selectedCell.string.length - 1)];
    
    // TODO: seems like a dirty way to do this
    ViewController *vc = (ViewController *)self.window.contentViewController;
    AnswerDirection dir = [self.identifier isEqualToString:@"across"]
    ? AnswerDirectionAcross
    : AnswerDirectionDown;
    vc.gameTable.currDirection = dir;
    [vc.gameTable selectClue:hintNumString withDirection:dir];
    NSLog(@"Selected %@ %@", hintNumString, self.identifier);
}
@end
