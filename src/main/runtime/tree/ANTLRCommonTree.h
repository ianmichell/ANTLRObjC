//
//  ANTLRCommonTree.h
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
#import <ANTLR/ANTLRTree.h>
#import <ANTLR/ANTLRToken.h>

@interface ANTLRCommonTree : ANTLRTree
{
	id<ANTLRToken> token;
}

-(id) initWithCommonTreeNode:(ANTLRCommonTree *) node;
-(id) initWithToken:(id<ANTLRToken>) t;
-(id) initWithTokenType:(NSInteger) t;

// Dynamic properties
-(id<ANTLRToken>) token;
-(void) setToken:(id<ANTLRToken>) t;
-(BOOL) isEmpty;
-(NSInteger) type;
-(NSInteger) tokenStartIndex;
-(void) setTokenStartIndex:(NSInteger) s;
-(NSInteger) tokenStopIndex;
-(void) setTokenStopIndex:(NSInteger) s;
-(NSInteger) charPositionInLine;
-(NSInteger) line;
-(NSString *) text;

@property (retain, readwrite) id<ANTLRToken> token;

@end
