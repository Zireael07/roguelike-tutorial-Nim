# Nim bindings for our JS resources.js file

import dom
import html5_canvas

#import tables

type
    Loader* = ref object

proc initLoader*(win: Window): Loader {.importc.}

proc load*(list: seq[cstring]) {.importc.}

proc get*(url: cstring) : ImageElement {.importc.}

proc getURLs*() : seq[cstring] {.importc.}
#proc getResources*() : Table[cstring, ImageElement] {.importc.}

proc onReady*(fun: proc(canvas: Canvas)) {.importc.}

