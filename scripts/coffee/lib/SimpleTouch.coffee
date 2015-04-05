class SimpleTouch

	constructor: (@node) ->

		@_tapListeners = []
		@_panListeners = []

		# move = false

		# touchStartPosX = touchPosX = 0
		# touchStartPosY = touchPosY = 0

		if window.navigator.msPointerEnabled

			@node.addEventListener "MSPointerDown", (event) =>

				prospect = @_checkProspect event.target, @_tapListeners

				if prospect isnt false

					tapListener = @_tapListeners[prospect.id]

					event.listener = prospect

					for listener in tapListener

						listener.callStart event

				return

			@node.addEventListener "MSPointerMove", (event)  =>

				prospect = @_checkProspect event.target, @_tapListeners

				if prospect isnt false

					tapListener = @_tapListeners[prospect.id]

					event.listener = prospect

					for listener in tapListener

						listener.callCancel event

				return

			@node.addEventListener "MSPointerUp", (event)  =>

				prospect = @_checkProspect event.target, @_tapListeners

				if prospect isnt false

					tapListener = @_tapListeners[prospect.id]

					event.listener = prospect

					for listener in tapListener

						listener.callDone event

				return

		@node.addEventListener 'touchstart', (event)  =>

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

		@node.addEventListener 'touchmove', (event)  =>

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

			# prospect = @_checkProspect event.target, @_panListeners

			# if prospect isnt false

			# 	panListener = @_panListeners[prospect.id]

			# 	for listener in panListener

			# 		listener.move event, event.touches[0].clientX - touchPosX, event.touches[0].clientY - touchPosY

			# touchPosX = event.touches[0].clientX
			# touchPosY = event.touches[0].clientY

			return

		@node.addEventListener 'touchend', (event)  =>

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

			# if move is true

			# 	prospect = @_checkProspect event.target, @_panListeners

			# 	if prospect isnt false

			# 	 	panListener = @_panListeners[prospect.id]

			# 		for listener in panListener

			# 			listener.end event, touchPosX - touchStartPosX, touchPosY - touchStartPosY


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

		if @cbStart?

			@cbStart event

		@_tapStart = Date.now()

		return

	callCancel: (event) ->

		event.time = Date.now() - @_tapStart

		if @cbCancel?

			@cbCancel event

		@callEnd event

		@_tapStart = false

		return

	callEnd: (event) ->

		if @cbEnd?

			@cbEnd event

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

		event.startX = @touchStartPosX = event.touches[0].clientX
		event.startY = @touchStartPosY = event.touches[0].clientY

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

		event.movementX = event.touches[0].clientX - @touchPosX
		event.movementY = event.touches[0].clientY - @touchPosY

		event.startX = @touchStartPosX
		event.startY = @touchStartPosY

		totalX =

		@touchPosX = event.touches[0].clientX
		@touchPosY = event.touches[0].clientY

		@touchTotalPosX += @touchPosX
		@touchTotalPosY += @touchPosY

		event.totalX = @touchTotalPosX = @touchStartPosX - @touchPosX
		event.totalY = @touchTotalPosY = @touchStartPosY - @touchPosY

		if @cbPan?

			@cbPan event

		return

module.exports = new SimpleTouch document.body