# Metagalactic Llamas: Battle at the Edge of Time by Jeff Minter
<img src="https://www.mobygames.com/images/covers/l/539848-metagalactic-llamas-battle-at-the-edge-of-time-vic-20-front-cover.jpg" height=300><img src="https://user-images.githubusercontent.com/58846/104136780-2b319d80-5390-11eb-8617-89bf4a598ded.gif" height=300>

This is the disassembled and [commented source code] for the 1984 Commodore Vic 20 game Metgalactic Llamas: Battle at the Edge of Time by Jeff Minter. The dissassembly, initial source code commenting/labelling, and makefile/build setup was done by [mwenge], from whom this repo was forked.

This fork modifies the original game to use the Commodore VIC-20 keyboard, rather than a joystick. The new controls are `wasd` for joystick directions and `F1` for fire.

The modified version is intended to be run on a VIC-20, I have not tested it on any emulators. There are two addition files in src: wasd-f1\_metallama.asm is the modified code, original\_src is the original disassembled src from mwenge. To build the modified version, copy or rename wasd-f1\_metallama.asm to metallama.asm and run make.

A version of the game you can [play in your browser can be found here]. (Use the arrow keys and `ctrl` to manipulate the display, or use a gamepad if you have one plugged in. See the manual below for more.)

## Requirements

* [64tass 6502 compiler][64tass], tested with v1.56.2625
* [VICE Commodore Emulator][vice]

[64tass]: http://tass64.sourceforge.net/
[vice]: http://vice-emu.sourceforge.net/
[https://metallama.xyz]: https://mwenge.github.io/metallama.xyz
[commented source code]:https://github.com/mwenge/metallama/blob/master/src/metallama.asm
[mwenge]:https://github.com/mwenge/metallama
[play in your browser can be found here]: https://mwenge.github.io/metallama

To compile and run it do:

```sh
$ make
```
The compiled game is written to the `bin` folder. 

To just compile the game and get a binary (`metallama.prg`) do:

```sh
$ make metallama
```

