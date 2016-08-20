[yaml]: https://en.wikipedia.org/wiki/YAML
[latex]: https://www.latex-project.org/help/documentation/usrguide.pdf
[lilypond]: http://lilypond.org/doc/v2.19/Documentation/notation/index
[mustache]: https://mustache.github.io/mustache.5.html
[model-laul]: src/common/models.py
[model-project]: src/common/models.py

# Laulik Reference

The data used to build a laulik lives in the `data` directory. There are multiple subdirectories which contain project files.

## Laulud

The `data/laulud` directory contains all song information.  The following types of files will be found here:

### Yaml files

The song information is defined by a `.yml` file in the `data/laulud` directory.  These files must start with the header:

```
--- !Laul
```

Followed by a set of keys / values, in standard [Yaml format][yaml].
The following keys are supported:

#### `title` - String
Name of the song.  This will also be included as an index entry.  
Supports [LaTeX][latex] markup.
```
title: Eesti h\"umn
```

#### `composer` - String
Composer of the music.
Supports [LaTeX][latex] markup.
```
composer: Fr. Pacius
```

#### `poet` - String
Creator of the lyrics.
Supports [LaTeX][latex] markup.
```
poet: J. V. Jannsen
```

#### `margin` - Associative array
<a name="yaml-margin"></a>
Sets the margin for indenting the song.
Units are LaTex units.  Supports `verse` and `refrain` values.
**NOTE: This format will need to change in order to make laulik pages resizable, right now it is tied to a fixed page size**
```
margin:
  verse:
    l: 0.9in
    r: 0.1in
  refrain:
    l: 0.8in
    r: 0.2in
```

#### `misc` - String
Supplemental information which will be rendered on the song page.
Supports [LaTeX][latex] markup.
```
misc: (2005 ,,Vanas\~ona{``} laagrilaul)
```

#### `index` - List
A list of additional index entries under which this song will appear.
Supports [LaTeX][latex] markup.
```
index:
  - 2005 Vanas\~ona laagrilaul
```

#### `paths` - Associative array
<a name="yaml-paths"></a>
Paths to the other files associated with this song.
Paths are relative to the `.yml` file location.

```
paths:
  lyrics: 01_eesti_hümn.tex
  music: 01_eesti_hümn.ly
```

### Lyric files

Lyrics are specified by adding a `lyrics` entry under the [paths](#yaml-paths) portion of the Yaml file.

The lyric file typically has a `.tex` extension.  Its syntax is based off of a modified [LaTeX][latex] syntax.  Structurally, it is sufficient to format a file as a set of lines in a plain text format (using LaTeX modifiers for accents, etc as needed).

The lyric file is passed through a [mustache][mustache] renderer and passed a [Laul][model-laul] object in case you need to render templated data into the lyrics.

```
Mu isamaa, mu õnn ja rõõm,
kui kaunis oled sa!
Ei leia mina iial teal
see suure laia ilma peal,
mis mull' nii armas oleks ka
kui sa, mu isamaa!

Sa oled mind ju sünnitand
ja üles kasvatand!
Sind tänan mina alati
ja jään sul truuiks surmani!
Mull' kõige armsam oled sa.
mu kallis isamaa!

Su üle Jumal valvaku,
mu armas isamaa!
Ta olgu sinu kaitseja
ja võtku rohkest' õnnista',
mis iial ette võtad sa,
mu kallis isamaa!
```

Verses are defined as groups of non-blank lines.

#### `%REFRAIN` Verses

A verse will be marked as refrain if its first line is the text `%REFRAIN`. Refrains will be indented differently (see [margin](#yaml-margin) for more information).

```
Kes otsib, see leiab, ja muidu ei saa;
otsime skaut/gaidlikku teed!
Iga matk algab \"uhe sammuga,
astu julgelt ja vaata mis on ees.

%REFRAIN
Vanas\~ona, esiisa \~opetus,
kostab meile l\"abi aegade.

Vanal teel vana s\~obra leiad sa,
istu ja tee l\~oket koos.
R\"a\"agi oma jutte ja ela edasi,
ainult p\"u\"udlikud on muinasloos.
```

### Music files

Musical notes are specified by adding a `music` entry under the [paths](#yaml-paths) portion of the Yaml file.

The lyric file typically has a `.ly` extension.  The file should be formatted according to the [lilypond][lilypond] syntax.

The lyric file is passed through a [mustache][mustache] renderer and passed a [Laul][model-laul] object in case you need to render templated data into the lyrics.

### Image files

An image can be associated with a song by adding an `image` entry under the [paths](#yaml-paths) portion of the Yaml file.

This will be rendered next to the header for the associated song.

## Projects

The songbook information is defined by a `.yml` file in the `data/projects` directory.  These files must start with the header:

```
--- !Project
```

Followed by a set of keys / values, in standard
[Yaml format][yaml].
The following keys are supported:

#### `title` - String
Name of the book.  
Supports [LaTeX][latex] markup.
```
title: Järvemetsa laulik
```

#### `subtitle` - String
Subtitle for the title page.
Supports [LaTeX][latex] markup.
```
subtitle: 2006 Võluja Suurlaager
```

#### `parts` - List
A list of paths to include as songs in this project. These paths are relative to the `data` directory, not the project file.

Order is important as the songs will be included in the same order they appear in this list.

**TODO: Support linking to .latex files in order to include supplemental text, etc in the project.**

```
parts:
  - laulud/01_eesti_hümn.yml
  - laulud/2005_vanasõna.yml
```

## Templates
Templates are located in the `data/templates` directory, typically with a `.tex` extension.

These are [mustache][mustache] templates which render `.tex` output.

Songs are rendered into the `laul.tex` template and are passed a [Laul][model-laul] object.

Projects are rendered into the `project.tex` template and are passed a [Project][model-project] object.  The Project object contains a `content` attribute containing a rendered copy of all the song data associated with the project.
