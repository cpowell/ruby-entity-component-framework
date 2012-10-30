#!/bin/sh
ruby -J-Djava.library.path=./native -rubygems bin/runner.rb

# To run the game as a compiled Java program (jar file):
# $ rake jar
# $ java -Djava.library.path=./native -jar ruby_ec.jar
