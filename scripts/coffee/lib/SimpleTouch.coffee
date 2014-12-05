module.exports = class SimpleTouch

	constructor: ->

	onTap: (node, cb, milisec = 500) ->

		tap = false

		if window.navigator.msPointerEnabled

			node.addEventListener "MSPointerDown", (event) =>

				tap = Date.now()

				return

			node.addEventListener "MSPointerMove", (event)  =>

				tap = false

				return

			node.addEventListener "MSPointerUp", (event)  =>

				if tap isnt false and Date.now() < tap + milisec

					cb event

				return

		node.addEventListener 'touchstart', (event)  =>

			tap = Date.now()

			return

		node.addEventListener 'touchmove', (event)  =>

			tap = false

			return

		node.addEventListener 'touchend', (event)  =>

			if tap isnt false and Date.now() < tap + milisec

				cb event

			return