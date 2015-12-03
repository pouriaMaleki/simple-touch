class SimpleTouch

	constructor: (@node) ->

		@_tapListeners = []
		@_panListeners = []

		@_panGeneralProspect = false

		# move = false

		# touchStartPosX = touchPosX = 0
		# touchStartPosY = touchPosY = 0

		if window.navigator.msPointerEnabled

			@touchDown = false

			@node.addEventListener("MSHoldVisual", (e) ->
				e.preventDefault()
			, false)

			@node.addEventListener("contextmenu", (e) ->
				e.preventDefault()
			, false)

			@node.addEventListener 'MSPointerDown', (event)  =>

				@touchDown = true

				@_handleTouchStart()

			@node.addEventListener 'MSPointerMove', (event)  =>

				if @touchDown is false

					return

				@_handleTouchMove()

			@node.addEventListener 'MSPointerUp', (event)  =>

				@touchDown = false

				@_handleTouchEnd()

		@node.addEventListener 'touchstart', (event)  =>

			@_handleTouchStart()

		@node.addEventListener 'touchmove', (event)  =>

			@_handleTouchMove()

		@node.addEventListener 'touchend', (event)  =>

			@_handleTouchEnd()

		if window.ontouchstart is undefined

			@touchSimulateDown = false

			@node.addEventListener 'mousedown', (event)  =>

				@touchSimulateDown = true

				@_handleTouchStart()

			@node.addEventListener 'mousemove', (event)  =>

				if @touchSimulateDown is false

					return

				@_handleTouchMove()

			@node.addEventListener 'mouseup', (event)  =>

				@touchSimulateDown = false

				@_handleTouchEnd()


	_handleTouchStart: ->

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

			@_panGeneralProspect = prospect

			for listener in panListener

				listener.callStart event

		return

	_handleTouchMove: ->

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


		if @_panGeneralProspect isnt false

			panListener = @_panListeners[@_panGeneralProspect.id]

			event.listener = @_panGeneralProspect

			for listener in panListener

				listener.callGeneralPan event

		return

	_handleTouchEnd: ->

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

		if @_panGeneralProspect isnt false

			panListener = @_panListeners[@_panGeneralProspect.id]

			event.listener = @_panGeneralProspect

			for listener in panListener

				listener.callGeneralEnd event

			@_panGeneralProspect = false

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

	onGeneralEnd: (@cbGeneralEnd) ->

		@

	onGeneralPan: (@cbGeneralPan) ->

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

	callGeneralEnd: (event) ->

		event.startX = @touchStartPosX
		event.startY = @touchStartPosY

		event.totalX = @touchTotalPosX
		event.totalY = @touchTotalPosY

		if @cbGeneralEnd?

			@cbGeneralEnd event

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

	callGeneralPan: (event) ->

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

		if @cbGeneralPan?

			@cbGeneralPan event

		return

module.exports = new SimpleTouch document.body