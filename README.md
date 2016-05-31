gayngine
========

point-n-clicky. feely-touchy. photoshop powered. fabulous.

The engine is based on _Scenes_ loaded from `.psd` files and can be scripted in Moonscript and Lua.

File Structure
--------------

### `assets`
contains global assets (for now, the font).

### `lib`
contains 3rd party libraries.
So far vrld's [HUMP][hump] and [HC][HC] are used, alongside Evine's [artal][artal].

### `game`
contains the game code.

Files in this directory are specific to the game using the engine and except for _Scenes_ no further structure is imposed.

#### `game/scenes`
contains the game's _Scenes_ and shared mixins in the `common` directory.
See _Scenes_ below.

Concepts
--------

### Scenes
a _Scene_ is a single gameplay sequence, contained on one (scrollable) screen.
It can be navigated by the player using mouse controls and may contain objects and characters to interact with.

A _Scene_ is defined via a directory in the `scenes` game directory.
Every _Scene_ consists of one photoshop document, `main.psd`, whose layer structure is loaded and rendered.

Layers in a scene `main.psd` may load _Mixins_ using a mixin directive.
A mixin directive has the following format:

    ... mixin_name(p1,p2,...) ...

The directive consists of the mixin name and any number of parameters, seperated by commas and enclosed in parenthesis.
It may be preceded and followed by any other string of text.

### Mixins
_Mixins_ are a way of giving behaviours or distinct appearances to elements of a scene.

#### Load Location
When a directive is encountered, the _Mixin_ of the given name is searched.
The following locations are searched for the _Mixin_:

- game/scenes/_scene-name_/_mixin-name_._EXT_
- game/scenes/_scene-name_/init._EXT_
- game/scenes/common/_mixin-name_._EXT_
- game/scenes/common/init._EXT_

The `init` files above are loaded and expected to return a table;
if there is a value associated with the key *mixin-name* it is used as the mixin.
The other files are loaded if they exist and their return value is used directly.

The locations above are attempted in order and the first working path is used.
Failure to require a module will be ignored.

If a _Mixin_ cannot be loaded it is ignored and an error is logged in the console in debug mode.

#### Functionality
When a mixin directive is encountered, the _Mixin_ is loaded and called with the following arguments:

- the table representing the _Scene Node_ that contains the directive
- the *PSDScene* instance loading the _Mixin_
- any additional arguments passed to the mixin via the directive (as strings)

the _Mixin_ is expected to modify the _Scene Node_ to achieve the desired results.
It may define `draw` and `update` methods for the node that override the default behaviour (drawing the binary pixel data).

The `Mixin` parent class and the `wrapping_` helper function defined in the `util` module allow to write _Mixins_ in moonscript.
The `Mixin` parent class set's up hot-reloading and provides helper methods;
the `wrapping_` helper function may be applied to a moonscript class to make the constructor wrap it's first argument as the instance table instead of creating a new one.

Example: `game/common/mymixin.moon`

    import { wrapping_, Mixin } from require "util"

    wrapping_ class MyMixin extends Mixin
      new: (scene, ...) =>
        super!
        -- @ is the scene node

      update: (dt) =>
        -- update node

      draw: =>
        -- override default draw method

### Scene Nodes
_Scene Nodes_ are nodes in a _Scene_'s rendering tree.
They follow the structure given by [artal][artal] but are nested in a tree.
Integer keys inside a _Scene Node_ are reserved for children nodes.

#### Useful Fields
- `ox`, `oy`: negative integers representing the offset of the `image`s origin.
- `name`: the full layer name.
- `image`: if available, a LÖVE `Image` instance of the Layer's pixel data.
- `type`: one of `"empty"`, `"image"` or `"open"`.
- `mask`: a table containing a list of vector mask paths under `paths`.
  Each `path` is a sequence of Control Points, containg coordinates pairs (`x`, `y`) at the three keys `pre`, `cp` and `post`.

#### Drawing
If a _Scene Node_ contains a `draw` method, it is invoked with two parameters:

- `draw_group`, a bound method of the *PSDScene* instance.
  Draws a group of _Scene Nodes_:

        draw: (draw_group, draw_layer) =>
          draw_group @ -- no-op for layer groups
- `draw_layer`, a bound method of the *PSDScene* instance.
  Draws a single layer owning an `image` key.

If no `draw` method is defined and the _Scene Node_ has a key `image`, it is drawn at `(-ox, -oy)`.

Otherwise, if the `type` of the Node is `"open"`, `draw_group` is applied to it.


#### Updating
Updating works like Drawing, except:

- the method name is `update`,
- there is no `image` key or anything similar,
- there are no parameters to `update` except `dt`.

[artal]: https://github.com/unXedDani/Artal
[hump]: https://github.com/vrld/hump
[HC]: https://github.com/vrld/HC
