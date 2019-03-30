import dom
import html5_canvas

import resources, entity, game_class
import map, arena_map

# global stuff goes here
# needed because key handler refs Game
var game: Game;

# main key input handler
proc processKeyDown(key: int, player: Player) =
    case key:
      of 37: player.move(-1, 0)   #left
      of 39: player.move(1, 0)     #right
      of 38: player.move(0, -1)      #up
      of 40: player.move(0, 1)    #down
      else: echo key

# stubs to be called from JS by JQuery onclick()
proc moveUpNim() {.exportc.} =
    game.player.move(0, -1)

proc moveDownNim() {.exportc.} =
    game.player.move(0, 1)

proc moveLeftNim() {.exportc.} =
    game.player.move(-1, 0)

proc moveRightNim() {.exportc.} =
    game.player.move(1, 0)

# we need to specify our own %#^%$@ type so that we can work as a callback 
# in onReady()
proc ready(canvas: Canvas) : proc(canvas:Canvas) =
    echo ("We've done loading, ready");

    # moved from main
    # initial setup
    game = newGame(canvas);
    game.clearGame();
    
    echo $resources.getURLs();

    for k in resources.getURLs():
        echo $k;
        # for easier retrieval from Nim
        game.images.add(resources.get(k));
    
    #game.images.add(resources.get("gfx/human_m.png"));
    #echo game.images.len

    # test
    #renderGfxTile(game, game.images[0], 0, 0);

    # setup cd.
    game.player = Player(position: (1,1))
    game.map = arena_map.generateMap(20,20,@[(10,10)])

    # what it says on the tin
    proc mainLoop(time:float) = 
        discard dom.window.requestAnimationFrame(mainLoop)

    # should the main loop get moved to dom.window.onload
    # this if will become necessary
    #    if not isNil(game):
        # clear
        game.clearGame();
        # render
        game.renderMap(game.map);
        game.render(game.player);

    # this indentation is crucially important! It's not part of the main loop!
    discard dom.window.requestAnimationFrame(mainLoop)

# just a stub for JS to be able to call
proc onReadyNim() {.exportc.} =
    echo "Calling Nim from JS";
    let canvas = dom.document.getElementById("canvas").Canvas
    discard ready(canvas);

# setup canvas
dom.window.onload = proc(e: dom.Event) =
    let canvas = dom.document.getElementById("canvas").Canvas
    canvas.width = 800
    canvas.height = 600

    # load assets
    # do we need this? YES WE DO!
    var ress = initLoader(dom.window);
    # we have to force cstring conversion for some reason
    resources.load(@[cstring("gfx/human_m.png"), 
    cstring("gfx/wall_stone.png"),
    cstring("gfx/floor_cave.png"),
    cstring("gfx/kobold.png")]);

    # keys
    #  proc onKeyUp(event: Event) =
    #    processKeyUp(event.keyCode)

    proc onKeyDown(event: Event) =
        # prevent scrolling on arrow keys
        event.preventDefault();
        processKeyDown(event.keyCode, game.player);

    #  dom.window.addEventListener("keyup", onKeyUp)
    dom.window.addEventListener("keydown", onKeyDown)

    # place for main loop IF we need e.g. a visual loading bar