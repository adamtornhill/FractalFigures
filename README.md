# Fractal Figures

This software is a Processing sketch used to visualize code ownership as fractal figures.
The sketch is used to explore the ownership analyses from Your Code as a CrimeScene.
The sketch isn't intended to scale to large systems -- it's a free proof of concept.

## License

Copyright © 2014-2023 Adam Tornhill

Distributed under the [GNU General Public License v3.0](http://www.gnu.org/licenses/gpl.html).

## Credits

The algorithm and idea comes from research by D'Ambros and Lanza as published in their paper Fractal Figures: Visualizing Development Effort for CVS Entities.

## Usage

Run the sketch in [Processing](https://www.processing.org/). The code has been tested with Processing 4.

When you start the program, it prompts you for a file containing the CSV with the results of an `entity-effort` analysis. You obtain those ownership metrics via [Code Maat](https://github.com/adamtornhill/code-maat).

That's it - the fractal figures will appear together with a color legend to interpret them.

### Additional commands

During a visualization, press `s` to save an image to disk. In case you haven't provided a file with color mappings, the visualization will generate random colors. Just press `space` to re-draw the image using a new set of colors.

## Warnings

Note that the implementation is quick and dirty (with emphasis on the later). That means, input data isn't validated. In practice it shouldn't be much of a problem - you'll notice fast.

The program has been implemented properly in [CodeScene's free Community Edition](https://codescene.com/community-edition), which is intended for professional use. Anyway, I still hope that you'll find this simpler sketch useful in its current shape.