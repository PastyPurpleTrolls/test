# Help - Referees

Referees are the central system for controlling games between players. These pieces of software connect with players via sockets, report game results, and enforce rules.

## Design

Referees may be uploaded as is, or in a `.zip` file that contains the referee and a makefile.

### Makefile option

The makefile should implement two actions: run, and contest. For example, a Python referee might have a makefile like this:

```makefile
.PHONY: run contest manager clean

include player.mk

manager:
    nc -l -p $(port)

run: test_referee.py
    ./test_referee.py -p $(port) -n $(num_players) -r $(num_rounds) -t $(max_time)

contest: $(PLAYER)
    ./$(PLAYER).py -p $(port) -n '$(name)'
```

The run rule is called to start the referee.  When the referee is
called through the Makefile, the manager will provide four flags:

- `port`: (int) TCP port to connect to the manager on.  The referee
must connect and send a TCP port for the players to connect to.  If
the referee does not respond with a TCP port within 3 seconds of being
started, the manager will terminate the referee due to a timeout.
- `num_players`: (int) The number of players that will connect to the
referee.
- `num_rounds`: (int) The number of rounds that the referee should run
between the players.  If your referee does not support rounds, you can
ignore the value of this flag.
- `max_time`: (int) Maximum amount of time allowed per round, in
seconds.  The game manager will enforce this time.

The contest rule is called to start the player.  When the player is
called through the Makefile, the manager will provide two flags:

- `name`: (string) The name of the player as registered on the contest
server.  The player will be required to communicate this name to the
referee so the referee can report the results to the manager properly.
The player should not assume a particular name to report to the
referee because the manager may choose to give a different name to the
player for each match for disambiguation purposes.
- `port`: (int) TCP port to connect to the referee on.  All
communication with the referee will be done via this port; there is no
other mechanism for communication between the referee or any other
player.

Further examples can be found on [GitHub](https://github.com/PastyPurpleTrolls/test/tree/master/examples).

### Standalone referees

Referees should be implemented to support four flags from the game manager.

- `-p`: (int) TCP port to connect to the manager on. The referee must connect and send a TCP port for the players to connect to.  If the referee does not respond with a TCP port within 3 seconds of being started, the manager will terminate the referee due to a timeout.
- `-n`: (int) The number of players that will connect to the referee.
- `-r`: (int) The number of rounds that the referee should run between the players. If your referee does not support rounds, you can ignore the value of this flag.
- `-t`: (int) Maximum amount of time allowed per match, in seconds. The game manager will enforce this time.

## Protocol

Referees must communicate with the game manager via a TCP socket. Three main pieces of information are expected: a player TCP port number, results of rounds, final results of match (if rounds are supported). The referee must also send the moves made in each round.

For efficiency in the client visualizer, the referee should
periodically should send the game state to the manager.  We have
chosen a value of 10 moves for the initial games prototyped with the
system.

Commands are sent as key:value pairs. The first `:` in the command is seen as a special character and represents the end of a command name. Everything that follows is interpreted as the value. Pipes `|` represent separation between values that should be parsed.

Do **not** use `|` for any purpose except as a delimiter to represent lists in the protocol. It should not be used in game state representations.

### Defined Keywords

- `port`: (int) TCP port that the players should connect on. This needs to be sent within the first 3 seconds of being started.
- `match`: Values: `start`, `end`. Tell the manager to expect information about the match.
- `round`: Pipe separated double. `start` or `end`. Round start can also contain any data about the round. 
- `move`: Human readable description of the move as well as any round data needed by the visualizer. Data should be formatted in JSON to make parsing easier. 
- `gamestate`: Implementation dependant value. Sent periodically to represent the current state of the game. To ease parsing in the browser, please use JSON.
- `roundresult`: Sent directly after `round:end`. Pipe separated tuple with player name, result, and score. Score is implementation dependant. Result can only be `Win`, `Loss`, and `Tie`.
- `matchresult`: Sent directly after `match:end`. Pipe separated tuple with player name, result, and rounds won. 

### Example communication

```
port:2222
match:start
round:start|{}
move:description|movedata
gamestate:{}
round:end
roundresult:playername|result|score
roundresult:playername|result|score
match:end
matchresult:playername|result|roundswon
matchresult:playername|result|roundswon
```

## Replay Plugin

Every referee should be uploaded along with a replay plugin. Replays are an important piece of the learning experience and allow students to figure out what their player did during competition matches.

Replay plugins must be uploaded in a compressed file containing `script.js` and any other assets required by the plugin. Allowed compressed file formats are `.tar` and `.zip`. The compressed file must be a flat directory structure, any folders uploaded will not be available for use.

### Logs

Log files are generated from data sent by the referee over the course of a round. This log is loaded and made available to the Replay plugin on load.

Moves always have a description and data. Move data can be sent in any format by the game referee, but JSON is preferred to allow for easy parsing. Optionally, the game referee can send game state after a move to provide information as to what the game looked like after the move was completed. If provided, `gamestate` will be listed as an additional key:value pair in the move object.

#### Example

```javascript
{
    "results": {
        "Player2": {
            "result": "Win",
            "score": "1"
        },
        "Player1": {
            "result": "Loss",
            "score": "0"
        }
    },
    "moves": [{
        "description": "Player2 plays w",
        "data": "[\"Player2\", \"w\"]"
    }],
    "info": "0"
}
```

### Example Plugin

The GitHub repository contains an [example referee](https://github.com/PastyPurpleTrolls/game-contest-server/tree/master/examples/guess-w/test_referee.py), [player](https://github.com/PastyPurpleTrolls/game-contest-server/tree/master/examples/guess-w/test_player.py), and an example [Replay plugin](https://github.com/PastyPurpleTrolls/game-contest-server/tree/master/examples/guess-w/test-assets/script.js).

### API

Every plugin must define `script.js`. This script defines the logic for generating gamestates and rendering the game to the screen.

The Replay API is defined in [round.js](https://github.com/PastyPurpleTrolls/test/blob/master/app/assets/javascripts/round.js). Please refer the commented source for any questions on exact functionality. [PIXI.js](http://pixijs.com) runs the rendering code for displaying replays. Please refer to its [documentation](https://pixijs.github.io/docs/index.html) when writing rendering code.

#### Replay API

The Replay API is available through the global Replay object. Plugins should modify the prototype (`Replay.prototype`) to define functionality and attributes.

Three settings are available to Replay plugins.

```javascript
//Width and height of the renderer
Replay.prototype.rendererWidth = 750;
Replay.prototype.rendererHeight = 750;

//Time between moves (in seconds)
Replay.prototype.playIncrement = 1;
```

- [**Replay.prototype.initPlugin()**](https://github.com/PastyPurpleTrolls/test/blob/master/app/assets/javascripts/round.js#L202)
  
    Called immediately after initialization of the Replay object. This hook should be used for any logic that needs to be precomputed. 
    
    *Note: the round log will not be available when this function is called.*
- [**Replay.prototype.generateGamestate()**](https://github.com/PastyPurpleTrolls/test/blob/master/app/assets/javascripts/round.js#L386)

    Called whenever a new move is loaded. Any logic that is required in order to generate a gamestate should be executed in this method.
    
    Several attributes are available on the Round object to provide move data. Use [`self.parseJSON(string)`](https://github.com/PastyPurpleTrolls/test/blob/master/app/assets/javascripts/round.js#L513) to safely parse move data.

    - `self.round` Contains the parsed contents of the round log JSON file.
    
    - `self.moveNumber` is available in order to access the current move. It is important to note that moveNumber is not 0 indexed. A value of 1 would translate to index 0 in the moves array.

- [**Replay.prototype.render()**](https://github.com/PastyPurpleTrolls/test/blob/master/app/assets/javascripts/round.js#L379)

    Renders the current move gamestate to the WebGL context. Called immediately after `self.generateGamestate()`

- [**Replay.prototype.rendererLoaded()**](https://github.com/PastyPurpleTrolls/test/blob/master/app/assets/javascripts/round.js#L443)

    Called directly after the PIXI renderer has been defined and added to the page. Should be used to change any options (like background color) on the renderer.

- [**Replay.prototype.loadTextures()**](https://github.com/PastyPurpleTrolls/test/blob/master/app/assets/javascripts/round.js#L450)

    Load any required textures into the PIXI context. Call `self.addTexture(name, url)` to add a new texture. The URL will be relative to the assets folder that `script.js` is located in. Textures are added to the `self.textures` object.

- [**Replay.prototype.loadSprites()**](https://github.com/PastyPurpleTrolls/test/blob/master/app/assets/javascripts/round.js#L457)

    Load any PIXI sprites on initial load. Creating new sprites in the `render()` method should be avoided if possible.

    New sprites should be defined on `self.sprites` as a new key:value pair. Sprites can be added as a group (in an array) if that is convenient. For example:

    ```javascript
    self.sprites["spriteName"] = new PIXI.Sprite(self.textures["textureName"]);

    self.sprites["pieces"] = [];

    for (var i = 0; i < 10; i++) {
        self.sprites["pieces"][i] = new PIXI.Sprite(self.textures["textureName"]);
    }
    ```

- [**Replay.copy(src)**](https://github.com/PastyPurpleTrolls/test/blob/master/app/assets/javascripts/round.js#533) Helper function to deep copy objects (useful when calculating a new gamestate for each move)
    
    
