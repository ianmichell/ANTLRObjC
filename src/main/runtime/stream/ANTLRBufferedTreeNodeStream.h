//
//  ANTLRBufferedTreeNodeStream.h
//  ANTLR
//
//  Created by Ian Michell on 29/04/2010.
//  Copyright 2010 Ian Michell. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <ANTLR/ANTLRTree.h>
#import <ANTLR/ANTLRTreeAdaptor.h>
#import <ANTLR/ANTLRTokenStream.h>
#import <ANTLR/ANTLRTreeNodeStream.h>
#import <ANTLR/ANTLRLookaheadStream.h>
#import <ANTLR/ANTLRTreeIterator.h>
#import <ANTLR/ANTLRIntArray.h>

#define ANTLR_BUFFERED_TREE_NODE_STREAM_BUFFER_SIZE 100
#define ANTLR_BUFFERED_TREE_NODE_STREAM_CALL_STACK_SIZE 10

@interface ANTLRBufferedTreeNodeStream : NSObject <ANTLRTreeNodeStream> 
{
	id<ANTLRTree> up;
	id<ANTLRTree> down;
	id<ANTLRTree> eof;
	
	NSMutableArray *nodes;
	
	id<ANTLRTree> treeSource; // root
	
	id<ANTLRTokenStream> tokenStream;
	id<ANTLRTreeAdaptor> treeAdaptor;
	
	BOOL uniqueNavigationNodes;
	NSInteger p;
	NSInteger lastMarker;
	ANTLRIntArray *calls;
	
	NSEnumerator *e;
	
}

#pragma mark Constructor
-(id) initWithTree:(id<ANTLRTree>) tree;
-(id) initWithTreeAdaptor:(id<ANTLRTreeAdaptor>) anAdaptor andTree:(id<ANTLRTree>) tree;
-(id) initWithTreeAdaptor:(id<ANTLRTreeAdaptor>) anAdaptor withTree:(id<ANTLRTree>) tree withBufferSize:(NSInteger) bufferSize;

#pragma mark General Methods
-(id) currentSymbol;
-(id) LB:(NSInteger) i;
-(NSString *) sourceName;
-(NSEnumerator *) objectEnumerator;

-(void) push:(NSInteger) i;
-(NSInteger) pop;

-(NSString *) tokenTypeString;
-(NSString *) tokenStringFrom:(NSInteger) start to:(NSInteger) stop;

// protected methods. DO NOT USE
#pragma mark Protected Methods
-(void) _fillBuffer;
-(void) _fillBufferWithTree:(id<ANTLRTree>) tree;
-(NSInteger) _nodeIndex:(id<ANTLRTree>) node;
-(void) _addNavigationNode:(NSInteger) type;

@property(readonly) id currentSymbol;

@end
