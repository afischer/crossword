//
//  Document.m
//  Crossword
//
//  Created by Andrew Fischer on 12/25/18.
//  Copyright © 2018 Andrew Fischer. All rights reserved.
//

#import "Document.h"

@interface Document ()

@end

@implementation Document

- (instancetype)init {
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
    }
    return self;
}

+ (BOOL)autosavesInPlace {
    return YES;
}


- (void)makeWindowControllers {
    // Override to return the Storyboard file name of the document.
    [self addWindowController:[[NSStoryboard storyboardWithName:@"Main" bundle:nil] instantiateControllerWithIdentifier:@"Document Window Controller"]];
}


- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error if you return nil.
    // Alternatively, you could remove this method and override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    [NSException raise:@"UnimplementedMethod" format:@"%@ is unimplemented", NSStringFromSelector(_cmd)];
    return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError {
    // Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error if you return NO.
    // Alternatively, you could remove this method and override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
    // If you do, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
//    [NSException raise:@"UnimplementedMethod" format:@"%@ is unimplemented", NSStringFromSelector(_cmd)];
//    NSLog(@"%@", data);
//    const char* puzBytes = (const char*)[data bytes];
//
//    int numClues = puzBytes[46];
//    int width = puzBytes[44];
//    int height = puzBytes[45];
//
//    int boardSize = width * height;
//
//    int HEADER_LENGTH = 0x34; // 52 bytes
//    int STR_SECT_LENGTH = (int)data.length - HEADER_LENGTH - (boardSize * 2);
//
//
//    NSData *magicNumbers = [data subdataWithRange:NSMakeRange(2, 11)];
//    NSString *magicWord = [[NSString alloc] initWithData:magicNumbers encoding:NSISOLatin1StringEncoding];
//
//    NSData *fileVersion = [data subdataWithRange:NSMakeRange(24, 3)];
//    NSString *versionString = [[NSString alloc] initWithData:fileVersion encoding:NSISOLatin1StringEncoding];
//
//    NSData *solutionState = [data subdataWithRange:NSMakeRange(HEADER_LENGTH, boardSize)];
//    NSString *solutionString = [[NSString alloc] initWithData:solutionState encoding:NSISOLatin1StringEncoding];
//
//    NSData *boardState = [data subdataWithRange:NSMakeRange(HEADER_LENGTH + boardSize, boardSize)];
//    NSString *boardString = [[NSString alloc] initWithData:boardState encoding:NSISOLatin1StringEncoding];
    
//    NSData *stringData = [data subdataWithRange:NSMakeRange(HEADER_LENGTH + boardSize * 2, STR_SECT_LENGTH)];
//    NSLog(@"Data length: %d", (int)data.length);
//    NSLog(@"BOARD SIZE: %d \n STRING SECTION LENGTH: %d", boardSize*2, STR_SECT_LENGTH);
//    NSLog(@"%@", stringData);
    
//    NSString *stringstring = [[NSString alloc] initWithData:stringData encoding:NSUTF8StringEncoding];
//    NSMutableArray *clues = [[NSMutableArray alloc] init];
//    int offset = 0;
//    int clueLen = 0;
//
//    for (int i = 0; i < STR_SECT_LENGTH; i++) {
//        clueLen += 1;
//        int clueOffset = HEADER_LENGTH + boardSize * 2 + i;
//        // if we hit a null byte, add word and reset params
//        if (puzBytes[clueOffset] == 0x00) {
//            NSData *clueData = [data subdataWithRange:NSMakeRange(HEADER_LENGTH + boardSize * 2 + offset, clueLen)];
//
//            NSString *clue = [[NSString alloc] initWithData:clueData encoding:NSISOLatin1StringEncoding];
//
//            if (!clue) {
//                break;
//            }
//            [clues addObject:clue];
//            offset = i;
//            clueLen = 0;
//        }
//    }
//    NSLog(@"%@", clues);

    NSData *magicNumbers = [data subdataWithRange:NSMakeRange(2, 11)];
    NSString *magicWord = [[NSString alloc] initWithData:magicNumbers encoding:NSISOLatin1StringEncoding];
    
    if (![@"ACROSS&DOWN" isEqualToString:magicWord]) {
        [NSException raise:@"BadFiletype" format:@"%@ is not a .puz file", typeName];
    }

    Crossword *crossword = [[Crossword alloc] initWithData:data];
    self.crossword = crossword;
    NSLog(@"NICE!");
    return YES;
}


@end
