#!/bin/sh
# This is just a handy shortcut to run the jruby game.

ruby -J-Djava.library.path=./native -rubygems bin/main.rb

# To run the game as a compiled Java program (jar file):
# $ rake jar
# $ java -Djava.library.path=./native -jar ruby_ec.jar
