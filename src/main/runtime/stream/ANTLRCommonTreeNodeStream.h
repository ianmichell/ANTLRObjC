//
//  ANTLRCommonTreeNodeStream.h
//  ANTLR
//
//  Created by Ian Michell on 26/04/2010.
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

#define ANTLR_COMMON_TREE_NODE_STREAM_DEFAULT_BUFFER_SIZE 100
#define ANTLR_COMMON_TREE_NODE_STREAM_CALL_STACK_SIZE 10

@interface ANTLRCommonTreeNodeStream : ANTLRLookaheadStream <ANTLRTreeNodeStream> 
{
	id<ANTLRTree> treeSource;
	id<ANTLRTokenStream> tokenStream;
	id<ANTLRTreeAdaptor> treeAdaptor;
	ANTLRTreeIterator *iterator;
	ANTLRIntArray *calls;
	BOOL hasNilRoot;
	NSInteger level;
	BOOL uniqueNavigationNodes;
}

-(id) initWithTree:(id<ANTLRTree>) tree;
-(id) initWithTreeAdaptor:(id<ANTLRTreeAdaptor>) adapt andTree:(id<ANTLRTree>) t;

-(void) push:(NSInteger) i;
-(NSInteger) pop;
-(NSString *) toTokenTypeString;

@end
