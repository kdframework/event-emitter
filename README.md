## KDEventEmitter

This is a basic event emitter.

### Static events API

After mixing in `KDEventEmitter` to your class you can use `class` and `instance` level listeners.

```coffee
class KDView

  @include KDEventEmitter

...

KDView.on eventName, callback
KDView.once eventName, callback
KDView.off eventName # kills all listeners
KDView.emit eventName[, arg1[, arg2[, ...]]]
```

### Instance events API

```coffee
view = new KDView

view.on eventName, callback
view.once eventName, callback
view.off eventName # kills all listeners
view.emit eventName[, arg1[, arg2[, ...]]]
```

### Authors

- @devrim - Devrim Yasar
- @sinan - Sinan Yasar
- @humanchimp - Chris Thorn


### History

- author     : @devrim - 12/2011
- refactored : @sinan - 05/2012
- refactored : @sinan - 01/2013
- improved   : @sinan - 02/2013
- improved   : @humanchimp - 02/2013
- moved here : @sinan - 12/2014
