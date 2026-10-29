Class {
	#name : 'SmiVariableReadNode',
	#superclass : 'SmiAbstractNode',
	#instVars : [
		'variable'
	],
	#category : 'SmiParser',
	#package : 'SmiParser'
}

{ #category : 'generated' }
SmiVariableReadNode >> acceptVisitor: anAbstractVisitor [

	^ anAbstractVisitor visitVariableRead: self
]

{ #category : 'generated' }
SmiVariableReadNode >> tokenVariables [

	^ #( #variable )
]

{ #category : 'generated' }
SmiVariableReadNode >> variable [

	^ variable
]

{ #category : 'generated' }
SmiVariableReadNode >> variable: aSmaCCToken [

	variable := aSmaCCToken
]
