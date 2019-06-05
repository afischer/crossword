//
//  Crossword.m
//  Crossword
//
//  Created by Andrew Fischer on 12/26/18.
//  Copyright © 2018 Andrew Fischer. All rights reserved.
//

#import "Crossword.h"

@implementation Crossword


- (NSString *) cleanStringWithData:(NSData *)data {
    NSString *s = [[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
    return [s stringByReplacingOccurrencesOfString:@"\0" withString:@""];
}

- (instancetype)initWithData:(NSData *)data {
    self = [super init];
    if (self) {
        const char* puzBytes = (const char*)[data bytes];
        
        self.numClues = puzBytes[46];
        self.width = puzBytes[44];
        self.height = puzBytes[45];
        
        int boardSize = self.width * self.height;
        
        int HEADER_LENGTH = 0x34; // 52 bytes
        int STR_SECT_LENGTH = (int)data.length - HEADER_LENGTH - (boardSize * 2);
        
        
        
        NSData *fileVersion = [data subdataWithRange:NSMakeRange(24, 3)];
        NSString *versionString = [[NSString alloc] initWithData:fileVersion encoding:NSISOLatin1StringEncoding];
        
        NSData *solutionState = [data subdataWithRange:NSMakeRange(HEADER_LENGTH, boardSize)];
        NSString *solutionString = [[NSString alloc] initWithData:solutionState encoding:NSISOLatin1StringEncoding];
        
        NSData *boardState = [data subdataWithRange:NSMakeRange(HEADER_LENGTH + boardSize, boardSize)];
        NSString *boardString = [[NSString alloc] initWithData:boardState encoding:NSISOLatin1StringEncoding];
        

        NSMutableArray *board = [[NSMutableArray alloc] init];
        NSMutableArray *correctBoard = [[NSMutableArray alloc] init];

        for (int i = 0; i < self.width; i++) {
            NSRange rowRange = NSMakeRange(self.width * i, self.width);
            [board addObject:[boardString substringWithRange:rowRange]];
            [correctBoard addObject:[solutionString substringWithRange:rowRange]];
        }
        self.boardLayout = [board copy];
        self.solvedLayout = [correctBoard copy];
        
        NSLog(@"%@", board);
        
        // GET CLUES
        NSMutableArray *clues = [[NSMutableArray alloc] init];
        int offset = 0;
        int clueLen = 0;
        
        for (int i = 0; i < STR_SECT_LENGTH; i++) {
            clueLen += 1;
            int clueOffset = HEADER_LENGTH + boardSize * 2 + i;
            // if we hit a null byte, add word and reset params
            
            if (puzBytes[clueOffset] == 0x00) {
                NSData *clueData = [data subdataWithRange:NSMakeRange(HEADER_LENGTH + boardSize * 2 + offset, clueLen)];
                
                NSString *clue = [self cleanStringWithData:clueData];
                [clues addObject:clue];

                if (puzBytes[clueOffset + 1] == 0x00) {
                    break;
                }
                offset = i;
                clueLen = 0;
            }
        }
        
        // remove title, author, and copyright
        
        
        self.name = clues[0];
        self.author = clues[1];
        self.copyright = clues[2];
        
        // FIXME
        clues = [[clues subarrayWithRange:NSMakeRange(3, clues.count - 3)] mutableCopy];

        
        // MAP CLUES
        int clueNum = 1; // current clue's box number
        int clueIdx = 0; // current clue's index in clue listing
        NSMutableDictionary *acrossClueMap = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *downClueMap = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *labelMap = [[NSMutableDictionary alloc] init];

        
        for (int y = 0; y < self.height; y++) {
            for (int x = 0; x < self.width; x++) {
                if ([self isBlackAtX:x Y:y]) continue;
                BOOL assigned = NO; // have we given a number in this iteration?
                NSString *numString = [NSString stringWithFormat:@"%d", clueNum];
                NSString *coordString = [NSString stringWithFormat:@"%d,%d", x, y];
                // across check
                if ([self hasAcrossAtX:x Y:y]) {
//                    NSLog(@"Found across");
                    [acrossClueMap setValue:clues[clueIdx] forKey:numString];
                    [labelMap setValue:numString forKey:coordString];
                    assigned = YES;
                    clueIdx++;
                }
                // down check
                if ([self hasDownAtX:x Y:y]) {
//                    NSLog(@"Found down");
                    [downClueMap setValue:clues[clueIdx] forKey:numString];
                    [labelMap setValue:numString forKey:coordString];
                    assigned = YES;
                    clueIdx++;
                }
                
                if (assigned) clueNum++; // assigned clue values, so inc counter
            }
        }
        
        self.acrossClues = acrossClueMap;
        self.downClues = downClueMap;
        self.labelMap = labelMap;
        NSLog(@"%@", acrossClueMap);
        NSLog(@"%@", downClueMap);
    }
    return self;
}

-(BOOL) isBlackAtX:(int) x Y:(int) y {
    return [self.boardLayout[y] characterAtIndex:x] == 46;
}

-(NSString *) valueAtX:(int) x Y:(int) y {
    if ([self isBlackAtX:x Y:y]) return @"";
    char character = [self.boardLayout[y] characterAtIndex:x];
    if (character == 45) return @"";
    return [NSString stringWithFormat:@"%c", character];
}

-(NSString *) solutionAtX:(int) x Y:(int) y {
    if ([self isBlackAtX:x Y:y]) return @"";
    char character = [self.solvedLayout[y] characterAtIndex:x];
    return [NSString stringWithFormat:@"%c", character];
}

-(BOOL) hasAcrossAtX:(int) x Y:(int) y {
    if (x == 0 || [self isBlackAtX:x - 1 Y:y]) {
        return x + 1 < self.width && ![self isBlackAtX:x + 1 Y:y];
    }
    return NO;
}

-(BOOL) hasDownAtX:(int) x Y:(int) y {
    if (y== 0 || [self isBlackAtX:x Y:y - 1]) {
        return y + 1 < self.height && ![self isBlackAtX:x Y:y + 1];
    }
    return NO;
}

-(BOOL) hasLabelAtX:(int) x Y:(int) y {
    return [self hasDownAtX:(int)x Y:(int)y] || [self hasAcrossAtX:(int)x Y:(int)y];
}

-(NSString *) labelAtX:(int) x Y:(int) y {
    if ([self hasDownAtX:(int)x Y:(int)y] || [self hasAcrossAtX:(int)x Y:(int)y]) {
        NSString *coordString = [NSString stringWithFormat:@"%d,%d", (int)x, (int)y];
        NSString *clueNum = [self.labelMap valueForKey:coordString];
        return clueNum;
    }
    return @"";
}

@end
