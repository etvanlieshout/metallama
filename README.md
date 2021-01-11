# Metagalactic Llamas: Battle at the Edge of Time by Jeff Minter
<img src="https://www.mobygames.com/images/covers/l/539848-metagalactic-llamas-battle-at-the-edge-of-time-vic-20-front-cover.jpg" height=300><img src="https://user-images.githubusercontent.com/58846/104136780-2b319d80-5390-11eb-8617-89bf4a598ded.gif" height=300>

This is the disassembled and [commented source code] for the 1984 Commodore Vic 20 game Metgalactic Llamas: Battle at the Edge of Time by Jeff Minter. 

A version of the game you can [play in your browser can be found here]. (Use the arrow keys and `ctrl` to manipulate the display, or use a gamepad if you have one plugged in. See the manual below for more.)

## Requirements

* [64tass][64tass], tested with v1.54, r1900
* [VICE][vice]

[64tass]: http://tass64.sourceforge.net/
[vice]: http://vice-emu.sourceforge.net/
[https://metallama.xyz]: https://mwenge.github.io/metallama.xyz
[commented source code]:https://github.com/mwenge/metallama/blob/master/src/metallama.asm
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

