//
//  Document.h
//  Crossword
//
//  Created by Andrew Fischer on 12/25/18.
//  Copyright © 2018 Andrew Fischer. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Crossword.h"

@interface Document : NSDocument
@property (strong, nonatomic) Crossword *crossword;
@property (nonatomic) NSString *formatVersion;
@property (nonatomic) NSString *checksum; // TODO
@end

