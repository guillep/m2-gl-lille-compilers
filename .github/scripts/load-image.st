"Loads VMMaker (and the course code, when the repository has some) into a fresh Pharo 13 image.
Run with: pharo Pharo.image st --save --quit load-image.st
Reads VMMAKER_REPOSITORY and GITHUB_WORKSPACE from the environment."

| env vmmakerRepository sourceDirectory |
env := Smalltalk os environment.
vmmakerRepository := env at: 'VMMAKER_REPOSITORY'.
sourceDirectory := (env at: 'GITHUB_WORKSPACE') asFileReference / 'src'.

Iceberg remoteTypeSelector: #httpsUrl.

EpMonitor disableDuring: [
	Metacello new
		baseline: 'VMMaker';
		repository: vmmakerRepository;
		load.

	"Course code: every BaselineOf* package found under src/ (Tonel format)"
	sourceDirectory exists ifTrue: [
		(sourceDirectory directories select: [ :each | each basename beginsWith: 'BaselineOf' ])
			do: [ :each |
				Metacello new
					baseline: (each basename allButFirst: 'BaselineOf' size);
					repository: 'tonel://' , sourceDirectory fullName;
					load ] ] ].
