//
//  WindowController.m
//  Crossword
//
//  Created by Andrew Fischer on 3/2/19.
//  Copyright © 2019 Andrew Fischer. All rights reserved.
//

#import "WindowController.h"
#import "ViewController.h"

@interface WindowController ()
@property (strong, nonatomic, nullable) ViewController *vc;
@end

@implementation WindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    self.vc = self.window.contentViewController;
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}
- (IBAction)didClickMove:(id)sender {
    NSSegmentedControl *control = sender;
    NSLog(@"selected %li", (long)control.selectedSegment);
    if (control.selectedSegment) {
        return [self.vc.gameTable selectNextClue];
    } else {
        return [self.vc.gameTable selectPreviousClue];
    }
}

- (IBAction)didClickRotate:(id)sender {
    [self.vc.gameTable rotateSelection];
}

- (IBAction)didCheckSquare:(id)sender {
    NSLog(@"Checking Square");
    [self.vc.gameTable checkSquare];
    
}

- (IBAction)didCheckClue:(id)sender {
    NSLog(@"Checking Clue");
    [self.vc.gameTable checkSquare];
}

- (IBAction)didCheckPuzzle:(id)sender {
    NSLog(@"Checking Puzzle");
    [self.vc.gameTable checkSquare];
}

- (IBAction)didRevealSquare:(id)sender {
    NSLog(@"Revealing Square");
    [self.vc.gameTable revealSquare];
}

- (IBAction)didRevealClue:(id)sender {
    NSLog(@"Revealing Clue");
    [self.vc.gameTable revealSquare];
}

- (IBAction)didRevealPuzzle:(id)sender {
    NSLog(@"Revealing Puzzle");
    [self.vc.gameTable revealSquare];
}

@end
