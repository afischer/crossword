//
//  GridCell.m
//  Crossword
//
//  Created by Andrew Fischer on 6/5/19.
//  Copyright © 2019 Andrew Fischer. All rights reserved.
//

#import "GridCell.h"

@implementation GridCell
- (instancetype)initWithCurrentVal:(NSString *)val
                          solution:(NSString *)solution
                             label:(NSString *) label
                           isBlack:(BOOL)isBlack {
    self = [super init];
    if (self) {
        self.currentValue = val;
        self.correctValue = solution;
        self.label = label;
        self.isBlack = isBlack;
        self.isRevealed = NO;
        self.isIncorrect = NO;
    }
    return self;
}
@end
