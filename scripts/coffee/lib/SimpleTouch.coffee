class SimpleTouch

	constructor: (@node) ->

		@_tapListeners = {}
		@_panListeners = {}

		# move = false

		# touchStartPosX = touchPosX = 0
		# touchStartPosY = touchPosY = 0

		if window.navigator.msPointerEnabled

			@touchDown = false

			@node.addEventListener("MSHoldVisual", (event) ->
				event.preventDefault()
			, false)

			@node.addEventListener("contextmenu", (event) ->
				event.preventDefault()
			, false)

			@node.addEventListener 'MSPointerDown', (event)  =>

				@touchDown = true

				@_handleTouchStart(event)

			@node.addEventListener 'MSPointerMove', (event)  =>

				if @touchDown is false

					return

				@_handleTouchMove(event)

			@node.addEventListener 'MSPointerUp', (event)  =>

				@touchDown = false

				@_handleTouchEnd(event)

		@node.addEventListener 'touchstart', (event)  =>

			@_handleTouchStart(event)

		@node.addEventListener 'touchmove', (event)  =>

			@_handleTouchMove(event)

		@node.addEventListener 'touchend', (event)  =>

			@_handleTouchEnd(event)

		if window.ontouchstart is undefined

			@touchSimulateDown = false

			@node.addEventListener 'mousedown', (event)  =>

				@touchSimulateDown = true

				@_handleTouchStart(event)

			@node.addEventListener 'mousemove', (event)  =>

				if @touchSimulateDown is false

					return

				@_handleTouchMove(event)

			@node.addEventListener 'mouseup', (event)  =>

				@touchSimulateDown = false

				@_handleTouchEnd(event)


	_handleTouchStart: (event) ->

		prospect = @_checkProspect event.target, @_tapListeners

		if prospect isnt false

			tapListener = @_tapListeners[prospect.id]

			event.listener = prospect

			for listener in tapListener

				listener.callStart event

		prospect = @_checkProspect event.target, @_panListeners

		if prospect isnt false

			panListener = @_panListeners[prospect.id]

			event.listener = prospect

			for listener in panListener

				listener.callStart event

		return

	_handleTouchMove: (event) ->

		prospect = @_checkProspect event.target, @_tapListeners

		if prospect isnt false

			tapListener = @_tapListeners[prospect.id]

			event.listener = prospect

			for listener in tapListener

				listener.callCancel event

		prospect = @_checkProspect event.target, @_panListeners

		if prospect isnt false

			panListener = @_panListeners[prospect.id]

			event.listener = prospect

			for listener in panListener

				listener.callPan event

		return

	_handleTouchEnd: (event) ->

		prospect = @_checkProspect event.target, @_tapListeners

		if prospect isnt false

			tapListener = @_tapListeners[prospect.id]

			event.listener = prospect

			for listener in tapListener

				listener.callDone event

		prospect = @_checkProspect event.target, @_panListeners

		if prospect isnt false

			panListener = @_panListeners[prospect.id]

			event.listener = prospect

			for listener in panListener

				listener.callEnd event

		return

	_checkProspect: (prospect, listeners) ->

		while prospect

			if listeners[prospect.id]?

				return prospect

			prospect = prospect.parentNode

		return false

	onTap: (id) ->

		l = new TapListener()

		if @_tapListeners[id]?

			@_tapListeners[id].push l

			return l

		@_tapListeners[id] = [l]

		l

	onPan: (id) ->

		l = new PanListener()

		if @_panListeners[id]?

			@_panListeners[id].push l

			return l

		@_panListeners[id] = [l]

		l

class TapListener

	constructor: (@milisec = 300) ->

		@_tapStart = false

		@touchPosX = @touchTotalPosX = @touchStartPosX = 0
		@touchPosY = @touchTotalPosY = @touchStartPosY = 0

	onStart: (@cbStart) ->

		@

	onCancel: (@cbCancel) ->

		@

	onEnd: (@cbEnd) ->

		@

	onDone: (@cbDone) ->

		@

	onTap: (@cbTap) ->

		@


	callStart: (event) ->

		event.startX = @touchStartPosX = (if event.clientX? then event.clientX else event.touches[0].clientX )
		event.startY = @touchStartPosY = (if event.clientY? then event.clientY else event.touches[0].clientY )

		if @cbStart?

			@cbStart event

		@_tapStart = Date.now()

		return

	callCancel: (event) ->

		event.movementX = (if event.clientX? then event.clientX else event.touches[0].clientX ) - @touchPosX
		event.movementY = (if event.clientY? then event.clientY else event.touches[0].clientY ) - @touchPosY

		event.startX = @touchStartPosX
		event.startY = @touchStartPosY

		@touchPosX = (if event.clientX? then event.clientX else event.touches[0].clientX )
		@touchPosY = (if event.clientY? then event.clientY else event.touches[0].clientY )

		@touchTotalPosX += @touchPosX
		@touchTotalPosY += @touchPosY

		event.totalX = @touchTotalPosX = @touchStartPosX - @touchPosX
		event.totalY = @touchTotalPosY = @touchStartPosY - @touchPosY

		event.time = Date.now() - @_tapStart

		if Math.abs(event.totalX) > 10 or Math.abs(event.totalY) > 10

			if @cbCancel?

				@cbCancel event

			@callEnd event

			@_tapStart = false

		return

	callEnd: (event) ->

		event.startX = @touchStartPosX
		event.startY = @touchStartPosY

		event.totalX = @touchTotalPosX
		event.totalY = @touchTotalPosY

		if @cbEnd?

			@cbEnd event

		@touchPosX = @touchTotalPosX = @touchStartPosX = 0
		@touchPosY = @touchTotalPosY = @touchStartPosY = 0

		return

	callDone: (event) ->

		event.time = Date.now() - @_tapStart

		@callEnd event

		if @_tapStart isnt false

			if @cbDone?

				@cbDone event

			if event.time < @milisec

				@callTap event

				@_tapStart = false

		return

	callTap: (event) ->

		if @cbTap?

			@cbTap event

		return

class PanListener

	constructor: ->

		@touchPosX = @touchTotalPosX = @touchStartPosX = 0
		@touchPosY = @touchTotalPosY = @touchStartPosY = 0

	onStart: (@cbStart) ->

		@

	onEnd: (@cbEnd) ->

		@

	onPan: (@cbPan) ->

		@

	callStart: (event) ->

		event.startX = @touchStartPosX = (if event.clientX? then event.clientX else event.touches[0].clientX )
		event.startY = @touchStartPosY = (if event.clientY? then event.clientY else event.touches[0].clientY )

		if @cbStart?

			@cbStart event

		return

	callEnd: (event) ->

		event.startX = @touchStartPosX
		event.startY = @touchStartPosY

		event.totalX = @touchTotalPosX
		event.totalY = @touchTotalPosY

		if @cbEnd?

			@cbEnd event

		@touchPosX = @touchTotalPosX = @touchStartPosX = 0
		@touchPosY = @touchTotalPosY = @touchStartPosY = 0

		return

	callPan: (event) ->

		event.movementX = (if event.clientX? then event.clientX else event.touches[0].clientX ) - @touchPosX
		event.movementY = (if event.clientY? then event.clientY else event.touches[0].clientY ) - @touchPosY

		event.startX = @touchStartPosX
		event.startY = @touchStartPosY

		@touchPosX = (if event.clientX? then event.clientX else event.touches[0].clientX )
		@touchPosY = (if event.clientY? then event.clientY else event.touches[0].clientY )

		@touchTotalPosX += @touchPosX
		@touchTotalPosY += @touchPosY

		event.totalX = @touchTotalPosX = @touchStartPosX - @touchPosX
		event.totalY = @touchTotalPosY = @touchStartPosY - @touchPosY

		if @cbPan?

			@cbPan event

		return

module.exports = new SimpleTouch document.body