//
//  ANTLRTreeAdapter.h
//  ANTLR
//
//  Created by Ian Michell on 23/04/2010.
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
#import <ANTLR/ANTLRTree.h>
#import <ANTLR/ANTLRToken.h>
#import <ANTLR/ANTLRTokenStream.h>

@protocol ANTLRTreeAdapter <NSObject>

#pragma mark Tree Construction
-(id<ANTLRTree>) createTreeWithToken:(id<ANTLRToken>) payload;
-(id<ANTLRTree>) createEmptyTree;
-(id<ANTLRTree>) createErrorNodeWithStream:(id<ANTLRTokenStream>) inStream fromToken:(id<ANTLRToken>) start toToken:(id<ANTLRToken>) stop errorIn:(NSError *) error;

-(id<ANTLRTree>) copyNode:(id<ANTLRTree>) t;
-(id<ANTLRTree>) copyTree:(id<ANTLRTree>) t;

-(void) addChild:(id<ANTLRTree>) child toTree:(id<ANTLRTree>)parent;

-(id<ANTLRTree>) postProcessTree:(id<ANTLRTree>) rootTree;
-(NSInteger) getUniqueIdForTree:(id<ANTLRTree>) node;

-(BOOL) isEmptyTree:(id<ANTLRTree>) tree;

#pragma mark Rewrite Rules
-(id<ANTLRTree>) createTreeWithToken:(id<ANTLRToken>) token withType:(NSInteger) type;
-(id<ANTLRTree>) createTreeWithToken:(id<ANTLRToken>) token withType:(NSInteger) type andText:(NSString *) text;
-(id<ANTLRTree>) createTreeWithTokenType:(NSInteger) tokenType withText:(NSString *) text;

-(id<ANTLRTree>) becomeRootNode:(id<ANTLRTree>) newRoot ofNode:(id<ANTLRTree>) oldRoot;

#pragma mark Content
-(NSInteger) tokenTypeForNode:(id<ANTLRTree>) t;
-(void) setTokenType:(NSInteger) type forNode:(id<ANTLRTree>) t;

-(NSString *) textForNode:(id<ANTLRTree>) t;
-(void) setText:(NSString *) text forNode:(id<ANTLRTree>) t;

-(id<ANTLRToken>) tokenForNode:(id<ANTLRTree>) t;

-(void) setTokenBoundriesForTree:(id<ANTLRTree>) t fromToken:(id<ANTLRToken>) start toToken:(id<ANTLRToken>) stop;

-(NSInteger) tokenStartIndexForTree:(id<ANTLRTree>) t;
-(NSInteger) tokenStopIndexForTree:(id<ANTLRTree>) t;

#pragma mark Navigation / Tree Parsing
-(id<ANTLRTree>) childForNode:(id<ANTLRTree>) parent atIndex:(NSInteger) idx;
-(void) setChildForNode:(id<ANTLRTree>) parent atIndex:(NSInteger) idx withChild:(id<ANTLRTree>) child;
-(id<ANTLRTree>) removeChildFromNode:(id<ANTLRTree>) parent atIndex:(NSInteger) idx;

-(NSInteger) childCountForTree:(id<ANTLRTree>) t;

-(id<ANTLRTree>) parentForNode:(id<ANTLRTree>) child;
-(id<ANTLRTree>) setParentForNode:(id<ANTLRTree>) child toParent:(id<ANTLRTree>) parent;

-(NSInteger) indexForNode:(id<ANTLRTree>) t;
-(void) setIndexForNode:(id<ANTLRTree>) t toIndex:(NSInteger) idx;

-(void) replaceChildrenForTree:(id<ANTLRTree>) parent from:(NSInteger) start to:(NSInteger) stop with:(id<ANTLRTree>) t;

@end


@interface ANTLRTreeAdapter : NSObject <ANTLRTreeAdapter>
{

}

@end
