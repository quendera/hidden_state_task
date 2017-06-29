# Hidden state task
Space shooting game designed to study decision-making in humans. To play, download the zip file corresponding to your operating system from the latest release, unzip it and run it on your computer (you may need to give it permission).

## Rules of the game

Objective: destroy the enemy spaceship.

A word of warning: the enemy spaceship is in a quantum state that can only be measured upon impact of your attack. If your attack is of the same polarity as the enemy, the corresponding damage is inflicted. Otherwise, the enemy can use the energy of the attack to gain back health points. The enemy may change polarity between attacks. Choose wisely.

Enemy laser and bullets damage your ship. Avoid them as much as possible. A certain amount of hits will result in your doom.


## Controls

`←`, `↑`, `↓`, `→` : move.

`X` : shoot (the longer you press, the more damaging/energetic the shot).

`C` : change polarity (blue/red).

`P` : pause/unpause.

`Esc` : exit the game.

## Data collection

Upon exiting the game (either by defeating the enemy, doom or pressing `Esc`), your playing data will be saved to your computer in the following folder:

- Windows: `%APPDATA%\Godot\app_userdata\two_state_shooting\`

- MacOS, Linux: `$HOME/.godot/app_userdata/two_state_shooting/`

as a json file called `data`+`unix_timestamp`+`.json`

## Credits

- The soundtrack comes from [FoxSynergy](https://opengameart.org/content/cosmo-blast)

- Pixel art proudly produced by [dyogurt](https://twitter.com/dfmmatias)
