//
//  ANTLRStreamEnumertor.h
//  ANTLR
//
//  Created by Ian Michell on 29/04/2010.
//  Copyright 2010 Ian Michell. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ANTLRStreamEnumerator : NSEnumerator 
{
	NSInteger i;
	id eof;
	NSMutableArray *nodes;
}

-(id) initWithNodes:(NSMutableArray *) n andEOF:(id) o;
-(BOOL) hasNext;

@end
