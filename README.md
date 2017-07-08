# Schrödinger shot

Space shooting game designed to study decision-making in humans. To play, download the zip file corresponding to your operating system from the latest release, unzip it and run it on your computer (you may need to give it permission).

## Rules of the game

Objective: destroy the enemy spaceship.

A word of warning: the enemy spaceship is in a quantum superposition state of red and blue. Its attacks reflect its quantic nature: red and blue bullets are emitted with corresponding probability. Only bullet of a polarity different from yours can hurt your ship.
When attacked, the enemy waveform collapses and the spaceship assumes a full red or blue state.
If your attack is of the same polarity as the enemy, the corresponding damage is inflicted. Otherwise, the enemy can use the energy of the attack to gain back health points.
After the attack, the enemy returns to an unknown superposition state.

In case of incorrect attack, the enemy will use your energy against you, unleashing a powerful laser. There is no escape: you can only protect yourself by warping space-time around you with your shield. Unnecessary usage of the shield will cost you a time-out.

Enemy laser and bullets damage your ship. Avoid them as much as possible. A certain amount of hits will result in your doom.


## Controls

`←`, `↑`, `↓`, `→` : move.

`W` : shoot (the longer you press, the more damaging/energetic the shot)

`E` : change polarity (blue/red).

`Space` : shield (only available after shooting)

`P` : pause/unpause.

`F` : toggle fullscreen.

`Esc` : exit the game.

`Enter` : start the game.

## Data collection

Upon exiting the game (either by defeating the enemy, doom or pressing `Esc`), your playing data will be saved to your computer in the following folder:

- Windows: `%APPDATA%\Godot\app_userdata\two_state_shooting\`

- MacOS, Linux: `$HOME/.godot/app_userdata/two_state_shooting/`

as a json file called `data`+`unix_timestamp`+`.json`

## Credits

- The soundtrack comes from [FoxSynergy](https://opengameart.org/content/cosmo-blast)

- Pixel art proudly produced by [dyogurt](https://twitter.com/dfmmatias)

## Licensing

As of now, no license is provided. This will probably change in the future.
