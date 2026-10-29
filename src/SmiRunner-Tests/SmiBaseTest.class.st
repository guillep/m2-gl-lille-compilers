Class {
	#name : 'SmiBaseTest',
	#superclass : 'ParametrizedTestCase',
	#instVars : [
		'architectureId'
	],
	#category : 'SmiRunner-Tests',
	#package : 'SmiRunner-Tests'
}

{ #category : 'building suites' }
SmiBaseTest class >> testParameters [

	^ ParametrizedTestMatrix new
		  forSelector: #architectureId addOptions: { #aarch64. #x64 };
		  yourself
]

{ #category : 'as yet unclassified' }
SmiBaseTest >> architectureId: aString [ 
	
	architectureId := aString
]
