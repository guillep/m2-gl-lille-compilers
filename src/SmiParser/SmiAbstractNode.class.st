Class {
	#name : 'SmiAbstractNode',
	#superclass : 'SmaCCParseNode',
	#category : 'SmiParser',
	#package : 'SmiParser'
}

{ #category : 'generated' }
SmiAbstractNode >> acceptVisitor: anAbstractVisitor [

	^ anAbstractVisitor visitAbstract: self
]
