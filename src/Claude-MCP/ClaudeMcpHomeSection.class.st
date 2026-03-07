Class {
	#name : 'ClaudeMcpHomeSection',
	#superclass : 'GtHomeMultiCardSection',
	#category : 'Claude-MCP',
	#package : 'Claude-MCP'
}

{ #category : 'accessing' }
ClaudeMcpHomeSection >> defaultPriority [
	^ 15
]

{ #category : 'accessing' }
ClaudeMcpHomeSection >> sectionTitle [
	^ 'Claude MCP'
]

{ #category : 'cards' }
ClaudeMcpHomeSection >> serverStatusCard [
	<gtSectionCard>
	| card |
	card := GtHomeCard explicit.
	^ card
		title: 'MCP Server for Claude';
		description: 'Status of the MCP Server for Claude. Click to inspect.';
		priority: 1;
		stencil: [ 
			| instance container statusDot statusLabel toolsLabel portLabel portEditor toggleButton controlRow inspectArea updater |
			instance := ClaudeMcpServer default.
			
			statusDot := BlElement new
				size: 12 @ 12;
				geometry: BlEllipseGeometry new;
				margin: (BlInsets top: 4).
			statusLabel := BrLabel new
				aptitude: (BrGlamorousLabelAptitude new foreground: Color darkGray).
			toolsLabel := BrLabel new
				padding: (BlInsets top: 4);
				aptitude: (BrGlamorousLabelAptitude new 
					foreground: Color gray;
					fontSize: 12).
			
			portLabel := BrLabel new
				aptitude: (BrGlamorousLabelAptitude new foreground: Color gray; fontSize: 12);
				text: 'Port:'.
			portEditor := BrEditableLabel new
				aptitude: (BrGlamorousEditableLabelAptitude new glamorousRegularFontAndSize
					foreground: Color gray);
				text: instance port asString;
				when: BrEditorAcceptWish do: [ :wish |
					instance port: wish text asString asInteger ].
			
			toggleButton := BrButton new
				beSmallSize;
				label: 'Stop'.
			
			controlRow := BrHorizontalPane new
				hMatchParent;
				vFitContent;
				cellSpacing: 6;
				alignCenterLeft;
				when: BlClickEvent do: [ :e | e consumed: true ];
				when: BlDoubleClickEvent do: [ :e | e consumed: true ];
				addChild: portLabel;
				addChild: portEditor;
				addChild: toggleButton.
			
			inspectArea := BrVerticalPane new
				hMatchParent;
				vFitContent;
				when: BlClickEvent do: [ :anEvent |
					anEvent consumed: true.
					inspectArea phlow spawnOrShowObject: instance ].
			
			inspectArea addChild: (BrLabel new
				beLargeSize;
				padding: (BlInsets bottom: 5);
				aptitude: BrGlamorousLabelAptitude new bold;
				text: 'MCP Server for Claude') preventMeAndChildrenMouseEvents.
			inspectArea addChild: (BrHorizontalPane new
				hMatchParent;
				vFitContent;
				cellSpacing: 8;
				addChild: statusDot;
				addChild: statusLabel) preventMeAndChildrenMouseEvents.
			inspectArea addChild: toolsLabel preventMeAndChildrenMouseEvents.
			
			container := BrVerticalPane new
				exact: 300 @ 140;
				background: Color white;
				aptitude: BrShadowAptitude new beLarge
					+ (BrGlamorousButtonExteriorAptitude new 
						backgroundPaint: Color white;
						borderPaint: Color transparent)
					+ (GtPhlowBrowseDefinitionAptitude new definition: [ card definingMethod ]);
				padding: (BlInsets all: 15);
				margin: (BlInsets
					top: self spaceGap
					left: 2 * self spaceGap
					bottom: 2 * self spaceGap
					right: 2 * self spaceGap).
			
			container addChild: inspectArea.
			container addChild: controlRow.
			
			"Update UI to reflect current state"
			updater := BrElementUpdater new
				element: container
				selector: #yourself;
				action: [
					| znServer isRunning |
					znServer := instance server instVarNamed: 'server'.
					isRunning := znServer notNil and: [ znServer isRunning ].
					statusDot background: (isRunning 
						ifTrue: [ Color fromHexString: '2ecc71' ] 
						ifFalse: [ Color fromHexString: 'e74c3c' ]).
					"No port in status line — port editor shows it"
					statusLabel text: (isRunning 
						ifTrue: [ 'Running' ] 
						ifFalse: [ 'Stopped' ]).
					toolsLabel text: instance server tools size asString, ' tools registered'.
					"Colored button matching state"
					toggleButton label: (isRunning ifTrue: [ 'Stop' ] ifFalse: [ 'Start' ]).
					toggleButton aptitude: (BrGlamorousButtonWithLabelAptitude new
						+ (isRunning
							ifTrue: [ BrGlamorousButtonExteriorAptitude new
								backgroundPaint: (Color fromHexString: 'e74c3c');
								borderPaint: (Color fromHexString: 'c0392b') ]
							ifFalse: [ BrGlamorousButtonExteriorAptitude new
								backgroundPaint: (Color fromHexString: '2ecc71');
								borderPaint: (Color fromHexString: '27ae60') ])).
					toggleButton label asRopedText foreground: Color white.
					toggleButton action: [ :btn |
						isRunning
							ifTrue: [ instance stop ]
							ifFalse: [ instance start ] ] ].
			
			"Subscribe to server announcements"
			instance announcer weak
				when: ClaudeMcpServerStarted send: #requestUpdate to: updater;
				when: ClaudeMcpServerStopped send: #requestUpdate to: updater.
			
			"Initial update"
			updater requestUpdate.
			
			container ]
]
