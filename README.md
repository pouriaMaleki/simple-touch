(work in progress)

I think this is going somewhere, I make another way of listening to touch event in very simple code, I just check where touched, then it find the `id` of your element in events if you bind some.


Work in progress and I have so much to do, so I just create that for my Corodva Music Player App (named Wikiseda on google play) and it work perfect on Webkit.


### Development

git clone [this project git]

cd simple-touch

npm install

### Use

npm install simple-touch

```
Touch = require 'simple-touch'

Touch.onTap "close-menu" # it's just id of my element in html
.onStart (event) =>

	event.listener.style.backgroundColor = 'rgba(0,0,0,.1)'

.onEnd (event) =>

	event.listener.style.backgroundColor = ''

.onTap (event) =>

	closeMenu()
```

```
timeout = null

Touch.onTap "long-press-me"
.onStart (event) =>

	event.listener.style.backgroundColor = 'rgba(0,0,0,.1)'

	timeout = setTimeout =>

		console.log "long press on ", event.listener

	, 700

.onEnd (event) =>

	event.listener.style.backgroundColor = ''
	clearTimeout timeout
```

```

Touch.onPan "pan-me"
.onPan (event) ->

	return if event.totalY > -10

	# check out event by running console.log(event)

```

### TODO

- Tap count
- Swipe