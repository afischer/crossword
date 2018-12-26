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

    // Do any additional setup after loading the view.
}

- (void)viewDidAppear {
    Document *puzzleDoc = self.view.window.windowController.document;
    Crossword *cw = puzzleDoc.crossword;
    [self.titleText setStringValue:cw.name];
    [self.authorText setStringValue:cw.author];
    [self.copyrightText setStringValue:cw.copyright];
    
    [self.acrossList beginUpdates];
    [self.acrossList endUpdates];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
