

curve = 'bezier-curve(0.23, 1, 0.32, 1)'
time = '.5'
class Chart extends Layer
	constructor: (options={}) ->
		options.backgroundColor ?= "transparent"
		options.width ?= 600
		options.height = options.width / 2
		super options
		@style =
			border: "#E8E8E8 2px solid"
			borderWidth: "0 0 2px 0"
		
		@score = options.score
		@context = 0
		
		@centerY = @height
		
		size = @width * .9	
		circleBase = new Layer
			backgroundColor: "transparent"
			width: size
			height: size
			y: @centerY - (size/2)
			superLayer: @
		
		circleBase.style =
			border: "#E7D0E9 1px solid"
			borderRadius: "50%"
		
		circleBase.centerX()
		
		@build(@context)
	build: (context) ->
		el = @
		@circle = []
		circleMask = []
		circleBorder = []
		
		for c, index in @score[context].values
			
			@circle[index] = new Layer
				backgroundColor: "transparent"
				z: 2
				superLayer: @
			circleMask[index] = new Layer
				backgroundColor: "transparent"
				superLayer: @circle[index]
			circleBorder[index] = new Layer
				backgroundColor: "transparent"
				superLayer: circleMask[index]
			circleBorder[index].style = 
				borderRadius: "50%"
			
			if index == 0
				size = @width * .6
				circleBorder[index].style =
					border: "#F95DAB #{@width * .04}px solid"
			if index == 1
				size = @width * .5
				circleBorder[index].style =
					border: "#00B4CB #{@width * .04}px solid"
			if index == 2
				size = @width * .4
				circleBorder[index].style =
					border: "#8FD63A #{@width * .04}px solid"
			
			@circle[index].properties = 
				width: size
				height: size
				y: @centerY - (size/2)
			circleMask[index].properties =
				width: size
				height: size/2
				y: size/2
			circleBorder[index].properties =
				width: size
				height: size
				y: -size/2
			
			@circle[index].centerX()		
		
		size = @width * .9
		
		@base = new Layer
			clip: false
			backgroundColor: "transparent"
			width: size
			height: size
			y: @centerY - (size/2)
			superLayer: @
			
		circleMask = new Layer
			backgroundColor: "transparent"
			width: size
			height: size/2
			y: size/2
			superLayer: @base
			
		circleMask.style = 
			border: "#C884D0 1px solid"
			borderWidth: "1px 0 0 0"
			
		circleBorder = new Layer
			backgroundColor: "#F7EFF8"
			width: size
			height: size
			y: -size/2
			z: 1
			superLayer: circleMask
			
		circleBorder.style = 
			borderRadius: "50%"
			border: "#E8D0EB 2px solid"
					
		marker = new Layer
			backgroundColor: "#C784CF"
			width: @width * .02
			height: @width * .02
			y: @centerY - (@width * .06)
			x: - @width * .03
			superLayer: @base
		marker.style =
			borderRadius: "50%"
		@base.centerX()
		
		@animate(context)
	
	animate: (context) ->
		
		total = 0
		for c, index in @score[context].values
			@circle[index].animate
				properties:
					rotation: c
				time: 1.5
				curve: curve
			total += c
		
		avg = total/@score[context].values.length
		@base.animate
			properties:
				rotation: avg
			time: 1.5
			curve: curve
			
	next: ->
		if @context < @score.length-1
			@context++
		else
			@context = 0
		
		@animate(@context)

		
chart = new Chart
	width: 600
	score: [
		{
			values: [72,130,42]
		},
		{
			values: [110,140,80]
		},
		{
			values: [140,94,104]
		},
	]
chart.center()	

switcher = new Layer
	width: 200
	height: 50
	y: 300
Utils.labelLayer switcher, "Next"
switcher.centerX()

switcher.on Events.Click, ->
	chart.next()
