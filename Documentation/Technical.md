# Technical details in SubtitleKit

SubtitleKit, as a multiple subtitle format library, contains two major parts of
code: a common abstraction of the subtitle formats, and a set of parsers of
different formats of subtitles.

As a good system designer, the parsers get abstracted too.

## Designing the abstraction of all subtitle formats

There are several common formats to support here, Subrip, SubStation Alpha,
lyric file, Matroska, each with their ups and downs. To abstract them all, some
creative designs ate called for. However, there are several common points:

*   A subtitle track is essentially a list of lines and some metadata together.
    
    Some format, like Subrip, does not provide metadata support; while formats
    like lyric file or Matroska, provides this support. However, different
    formats use different keys for the same meaning.

*   A subtitle line is some form of static media coupled with a time range.
    
    However, the media in question is not certain. It can be unformatted or
    formatted text, or possible images. This calls for some elasticity.

Hence, this is the most easily-thought design:

    @interface SKSubtitleTrack : NSObject
    
    @property NSArray *lines;           // SKSubtitleLine objects
    @property NSDictionary *metadata;   // NSStrings as keys, anything as values
    
    @end
    
    @interface SKSubtitleLine : NSObject
    
    @property NSTimeInterval start;     // Seconds from beginning of the track
    @property NSTimeInterval duration;  // Length of the time range in seonds
    @property id content;               // The static content, stored as-is
    
    @end

## Designing the abstraction of all format parsers

Parsers are actually easier to abstract. They are all factories producing
`SKSubtitleTrack` objects. Since each parser represent a format, they are all
named in the form of `SKFoobarFormat`