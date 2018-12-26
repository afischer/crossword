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
                
                if (!clue) {
                    break;
                }
                [clues addObject:clue];
                offset = i;
                clueLen = 0;
            }
        }
        
        self.acrossClues = clues;
        
        self.name = clues[0];
        self.author = clues[1];
        self.copyright = clues[2];
        
        NSLog(@"%@", [clues subarrayWithRange:NSMakeRange(0, 3)]);
    }
    return self;
}
@end
