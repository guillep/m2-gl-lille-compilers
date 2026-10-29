"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part:  State a one line summary. For example, ""I represent a paragraph of text"".

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them.

Public API and Key Messages

- message one
- message two
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.

Internal Representation and Key Implementation Points.


    Implementation Points
"
Class {
	#name : 'BaselineOfSmiParser',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfSmiParser',
	#package : 'BaselineOfSmiParser'
}

{ #category : 'baseline' }
BaselineOfSmiParser >> baseline: spec [

	<baseline>
	spec for: #common do: [
		spec baseline: 'SmaCC-GLR' with: [
			spec
				loads: #( 'SmaCC-GLR-Runtime' );
				className: 'BaselineOfSmaCC';
				repository: 'github://guillep/SmaCC' ].

		spec baseline: 'VMMaker' with: [
			spec
				repository: 'github://pharo-project/pharo-vm:pharo-12' ].


		spec package: 'SmiParser' with: [ spec requires: 'SmaCC-GLR' ].
		spec package: 'SmiRunner' with: [ spec requires: 'VMMaker' ].
		spec package: 'SmiRunner-Tests' with: [ spec requires: 'SmiRunner' ] ]
]
