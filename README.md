## KDEventEmitter

This is a basic event emitter for KDFramework.

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

- [@devrim](https://github.com/devrim) - Devrim Yasar
- [@sinan](https://github.com/sinan) - Sinan Yasar
- [@humanchimp](https://github.com/humanchimp) - Chris Thorn


### History

- author     : [@devrim](https://github.com/devrim) - 12/2011
- refactored : [@sinan](https://github.com/sinan) - 05/2012
- refactored : [@sinan](https://github.com/sinan) - 01/2013
- improved   : [@sinan](https://github.com/sinan) - 02/2013
- improved   : [@humanchimp](https://github.com/humanchimp) - 02/2013
- moved here : [@sinan](https://github.com/sinan) - 12/2014
