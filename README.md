# Fractal Figures

This software is a Processing sketch used to visualize code ownership for individual contributors.

## License

Copyright © 2014 Adam Tornhill

Distributed under the [GNU General Public License v3.0](http://www.gnu.org/licenses/gpl.html).

## Usage

Run the sketch in [Processing](https://www.processing.org/). When you start the program, it will prompt you for two files:

1. A CSV file with a list of each author and their respective color.
2. A CSV file with the ownership metrics mined from [Code Maat](https://github.com/adamtornhill/code-maat) as the results of a entity-effort analysis.

The author color information has to be given as a CSV of author and RGB color (pretty low-level, I know). Example:

             Adam Tornhill,250,0,0
             Ada Lovelace,0,250,0
             Charles Babbage,100,130,20

That's it - the fractal figures will appear together with a color legend to interpret them.

## Warnings

Note that the implementation is quick and dirty (with emphasis on the later). That means, input data isn't validated. In practice it shouldn't be much of a problem - you'll notice fast.

Perhaps I'll re-write the whole program properly one day. Until then, I hope it remains useful in its current shape.