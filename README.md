# Welcome to the Ruby Entity-Component Framework
This framework (RECF for short) is designed to help game authors construct 
modern, high-performance games using the elegant Ruby language and a fairly
new alternative to OOP called an "entity component system". An Entity
Component System is a programming methodology that successfully addresses many
shortcomings of OOP and streamlines game creation and maintenance.

The RECF has been documented in a series of blog posts by the author:

###Entity-Component game programming using JRuby and libGDX

* [Part 1 - introduction and nomenclature](http://cbpowell.wordpress.com/2012/10/30/entity-component-game-programming-using-jruby-and-libgdx-part-1/)
* [Part 2 - entities and the entity manager](http://wp.me/pFIOD-f0)
* [Part 3 - components](http://cbpowell.wordpress.com/2012/12/06/entity-component-game-programming-using-jruby-and-libgdx-part-3/)
* [Part 4 - systems](http://cbpowell.wordpress.com/2012/12/07/entity-component-game-programming-using-jruby-and-libgdx-part-4/)
* [Part 5 - libGDX concepts](http://cbpowell.wordpress.com/2012/12/11/entity-component-game-programming-using-jruby-and-libgdx-part-5/)
* [Part 6 - the Lunar Lander game](http://cbpowell.wordpress.com/2012/12/13/entity-component-game-programming-using-jruby-and-libgdx-part-6/)
* [Part 7 - serialization](http://cbpowell.wordpress.com/2012/12/16/entity-component-game-programming-using-jruby-and-libgdx-part-7/)
* [Part 8 - collision detection and more](http://cbpowell.wordpress.com/2012/12/17/entity-component-game-programming-using-jruby-and-libgdx-part-8/)

# Are you using this in a game?
Won't you consider emailing the author at <cpowell@prylis.com> ? I'd love to 
hear how the framework is being used "in the wild".

# Dependencies
The stock RECF utilizes libGDX (and LWJGL) to operate, although it has also been
adapted to Slick2D. These are bundled with the RECF source and don't need to
be separately downloaded.

But note: the entity component piece itself is wholly agnostic to the
graphics / game engine (libGDX, Slick, whatever). You can easily adapt the
RECF to your favorite graphics system: Unity, Torque 3D, ...

The RECF uses JRuby and has been tested with version 1.7. You'll need to 
install your own JRuby interpreter (with, say, RVM).

The RECF also uses some Gems which you can install with:

    $ bundle

# Running the sample game
The RECF includes a **very** basic "Lunar Lander"-type game that is intended to
be used as an example and teaching tool for the framework. You can run the
game with:

    $ ./run.sh (*nix, MacOS)	
	run.bat (Windows, requires jruby in your PATH)

(You'll need to have met the dependencies first.)

A, D => rotate, S => thrust

You can also generate a precompiled, distributable, multi-platform, jarfile 
package for your game as follows:

    $ rake jar

...and run it:

    $ java -jar ./recf.jar

# Further reading about Entity-Component Frameworks
Entity Component systems are quite different from Object Oriented Programming, especially
if you are already a seasoned OO programmer. These resources will help you
learn the justifications and benefits of Entity Component systems versus OO:

* In [this article](http://humespeaks.tumblr.com/post/21273251357/ludum-dare-dry-run-lessons-learned), scroll down and read the comment that begins with *"Oh man, the Entity Systems question."* Hume tidily articulates the typical problem that OO creates but EC fixes.
* [This T=Machine blog series](http://t-machine.org/index.php/2007/09/03/entity-systems-are-the-future-of-mmog-development-part-1/) offers a highly detailed and experienced look at the advantages to EC in MMO development.
* ["Evolve Your Hierarchy"](http://cowboyprogramming.com/2007/01/05/evolve-your-heirachy/) is a commonly-referenced piece on OO vs. EC.
* [This wiki](http://entity-systems.wikidot.com/) (by Adam of T=Machine) is one of the canonical EC references; you’ll return there often for advice.

# Thanks
A special "thanks" to Peter Cooper for writing [Let’s Build a Simple Video Game with JRuby: A Tutorial](http://www.rubyinside.com/video-game-ruby-tutorial-5726.html).
His article inspired me down this path.
