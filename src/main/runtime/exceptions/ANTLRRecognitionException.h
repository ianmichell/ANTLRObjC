//
//  ANTLRRecognitionException.h
//  ANTLR
//
//  Created by Ian Michell on 24/04/2010.
//  Copyright 2010 Ian Michell. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <ANTLR/ANTLRIntStream.h>
#import <ANTLR/ANTLRToken.h>
#import <ANTLR/ANTLRTree.h>

@interface ANTLRRecognitionException : NSException
{
	id<ANTLRIntStream> inputStream;
	NSInteger index;
	id<ANTLRToken> token;
	id<ANTLRTree> node;
	NSInteger currentChar;
	NSInteger line;
	NSInteger charPositionInLine;
	BOOL approximateLineInfo;
}

+(ANTLRRecognitionException *) exceptionWithStream:(id<ANTLRIntStream>) input;

-(id) initWithStream:(id<ANTLRIntStream>) input;
-(NSInteger) unexpectedType;

// this should not be used outside of this type of class
-(void) extractInformationFromTreeNodeStream:(id<ANTLRIntStream>) input;

@property(readwrite, retain) id<ANTLRIntStream> inputStream;
@property(readwrite) NSInteger index;
@property(readwrite, retain) id<ANTLRToken> token;
@property(readwrite, retain) id<ANTLRTree> node;
@property(readwrite) NSInteger currentChar;
@property(readwrite) NSInteger line;
@property(readwrite) NSInteger charPositionInLine;
@property(readwrite) BOOL approximateLineInfo;

@property(readonly) NSInteger unexpectedType;

@end
