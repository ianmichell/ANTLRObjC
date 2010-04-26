//
//  ANTLRLookaheadStream.h
//  ANTLR
//
//  Created by Ian Michell on 26/04/2010.
//  Copyright 2010 Ian Michell. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <ANTLR/ANTLRFastQueue.h>

#define UNITIALIZED_EOF_ELEMENT_INDEX NSIntegerMax

@interface ANTLRLookaheadStream : ANTLRFastQueue
{
	id eof;
	NSInteger eofElementIndex;
	NSInteger lastMarker;
	NSInteger markDepth;
}

-(id) initWithEOF:(id) o;
-(id) nextElement;
-(void) consume;
-(void) sync:(NSInteger) need;
-(void) fill:(NSInteger) n;
-(id) LT:(NSInteger) i;
-(id) LB:(NSInteger) i;
-(id) currentSymbol;
-(NSInteger) index;
-(NSInteger) mark;
-(void) releaseWithMarker:(NSInteger) marker;
-(void) rewindWithMarker:(NSInteger) marker;
-(void) rewind;
-(void) seek:(NSInteger) i;

@property(readwrite, retain) id eof;

@end
