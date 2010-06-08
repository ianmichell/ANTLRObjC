//
//  ANTLRTree.h
//  ANTLR
//
//  Created by Ian Michell on 21/04/2010.
//  Copyright 2010 Ian Michell. All rights reserved.
//

// [The "BSD licence"]
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions
// are met:
// 1. Redistributions of source code must retain the above copyright
//    notice, this list of conditions and the following disclaimer.
// 2. Redistributions in binary form must reproduce the above copyright
//    notice, this list of conditions and the following disclaimer in the
//    documentation and/or other materials provided with the distribution.
// 3. The name of the author may not be used to endorse or promote products
//    derived from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
// IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
// OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
// NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
// THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import <Cocoa/Cocoa.h>

@protocol ANTLRTree <NSObject, NSCopying>

+(id<ANTLRTree>) invalidNode;

#pragma mark Constructors
-(id) initWithTree:(id<ANTLRTree>) tree;

#pragma mark Ancestors / Parents
-(id<ANTLRTree>) getAncestor:(NSInteger) tokenType;
-(BOOL) hasAncestor:(NSInteger) tokenType;

@property(readwrite, retain) id<ANTLRTree> parent;
@property(readonly) NSArray *ancestors;

// Children
#pragma mark Children
-(id<ANTLRTree>) childAtIndex:(NSInteger) idx;
-(void) setChildAtIndex:(NSInteger) idx child:(id<ANTLRTree>)child;
-(void) freshenParentAndChildIndexes;
-(void) addChild:(id<ANTLRTree>) child;
-(id<ANTLRTree>) deleteChild:(NSInteger) index;
-(void) replaceChildrenFromIndex:(NSInteger) start toIndex:(NSInteger) stop tree:(id<ANTLRTree>) tree;
-(void) addChildren:(NSArray *) c;

@property(readonly) NSMutableArray *children;
@property(readonly) NSInteger childCount; // dynamic
@property(readwrite) NSInteger childIndex;

#pragma mark this node
@property(readonly) BOOL isEmpty;
@property(readwrite) NSInteger tokenStartIndex;
@property(readwrite) NSInteger tokenStopIndex;
@property(readonly) NSInteger type;
@property(readonly) NSInteger line;
@property(readonly) NSInteger charPositionInLine;
@property(readonly) NSString *text;

#pragma mark Information
-(NSString *) description;
-(NSString *) treeDescription;

@end

@interface ANTLRTree : NSObject <ANTLRTree>
{
	NSAutoreleasePool *pool;
	NSMutableArray *children;
	NSInteger tokenStartIndex;
	NSInteger tokenStopIndex;
	NSInteger childIndex;
	id<ANTLRTree> parent;
	NSArray *ancestors;
}

-(id<ANTLRTree>) firstChildWithType:(NSInteger) t;
-(void) freshenParentAndChildIndexesAtOffset:(NSInteger) offset;
-(void) sanityCheckParentAndChildIndexes;
-(void) sanityCheckParentAndChildIndexesForParentTree:(id<ANTLRTree>) parentTree forIndex:(NSInteger) idx;

@end
