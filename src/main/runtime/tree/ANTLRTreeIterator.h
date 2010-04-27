//
//  ANTLRTreeIterator.h
//  ANTLR
//
//  Created by Ian Michell on 26/04/2010.
//  Copyright 2010 Ian Michell. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <ANTLR/ANTLRTreeAdaptor.h>
#import <ANTLR/ANTLRTree.h>
#import <ANTLR/ANTLRFastQueue.h>
#import <ANTLR/ANTLRCommonTreeAdaptor.h>

@interface ANTLRTreeIterator : NSEnumerator 
{
	id<ANTLRTreeAdaptor> adaptor;
	id<ANTLRTree> root;
	id<ANTLRTree> tree;
	BOOL firstTime;
	id<ANTLRTree> up;
	id<ANTLRTree> down;
	id<ANTLRTree> eof;
	
	ANTLRFastQueue *nodes;
}

-(id) initWithTree:(id<ANTLRTree>) t;
-(id) initWithTreeAdaptor:(id<ANTLRTreeAdaptor>) a andTree:(id<ANTLRTree>) t;

-(void) reset;
-(BOOL) hasNext;

@property(readwrite, retain) id<ANTLRTree> up;
@property(readwrite, retain) id<ANTLRTree> down;
@property(readwrite, retain) id<ANTLRTree> eof;

@end
