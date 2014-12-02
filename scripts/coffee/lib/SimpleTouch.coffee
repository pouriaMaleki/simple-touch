module.exports = class SimpleTouch

	constructor: ->

	onTap: (node, cb, milisec = 500) ->

		tap = false

		if window.navigator.msPointerEnabled

			node.addEventListener "MSPointerDown", =>

				tap = Date.now()

				return

			node.addEventListener "MSPointerMove", =>

				tap = false

				return

			node.addEventListener "MSPointerUp", =>

				if tap isnt false and Date.now() < tap + milisec

					cb()

				return

		node.addEventListener 'touchstart', =>

			tap = Date.now()

			return

		node.addEventListener 'touchmove', =>

			tap = false

			return

		node.addEventListener 'touchend', =>

			if tap isnt false and Date.now() < tap + milisec

				cb()

			return