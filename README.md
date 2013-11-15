# SubtitleKit

SubtitleKit is a framework written in Objective-C that can handle various of
formats of subtitles and lyric text files.

Travis CI build status:
[![Build Status](https://travis-ci.org/xcvista/SubtitleKit.png?branch=master)]
(https://travis-ci.org/xcvista/SubtitleKit)

## History

Subtitler, the parent project of SubtitleKit, was started as a hobby project
intended to support a translation team I used to participate actively, [Deefun]
(http://www.deefun.com). It was initially named **Deefun Subtitle Tools** with a
special license granted from the team to use their name and logo in the
software.

The subtitle processing module used in DST was taken from an older award-winning
(as in, winner of a local high school science fair) program, which is used to
process lyric files, with some patches to make it process subtitle files.

That project fell into abandonce quickly after I graduated high school and
stopped supporting it. However it was coded so carefully that it still works
perfectly after four years out of maintaince, until recently a change in .net
framework killed it. An old user called me for bug fixes and sadly I lost the
source code and cannot fix it. Then I offered a new version as a replacement, as
sort of resolution of the situation.

This is the genesis of this project, the renovation of an old but trusted free
subtitle editor.

## Features

This subtitle handling library is implemented in 100% portable (*) Objective-C.
It have the following features:

*   A solid design inherited from the trusted old project it originated from.
*   Making, opening and saving subtitle files in various formats.
*   Tight integration with other common Objective-C and Cocoa technologies.

(*) _Portable_ as in it can be built for OS X, iOS as well as GNUstep on Linux.
Windows is not intended to be supported (instead old found code will be used).

Formats it is designed to handle:

*   Subrip without formatting (`srt`)
*   Lyrics (`lrc`)
*   Subtitle archive (`subar`, a private format preserving **all** information)

The following formats requires Cocoa (Touch) or GNUstep GUI environments:

*   Subrip with formatting (`srt`)
*   SubStation Alpha (`ssa` and `ass`)
*   Matroska (`mks`, non-subtitle streams are ignored.)

## License

This code is licensed under [GNU LGPL v3](LICENSE.md) or up.

Alternatively, you can contact me for other licensing options, including a
commericial license that comes with some sort of warranty.

## Contact

Author: Maxthon T. Chan &lt;<xcvista@me.com>&gt;

Original designers also include: Line, WaitinZ et al.
