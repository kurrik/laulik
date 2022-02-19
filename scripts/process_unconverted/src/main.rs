use lazy_static::lazy_static;
use regex::Regex;
use serde::{Deserialize, Serialize};
use std::env;
use std::error::Error;
use std::fs;
use std::path::Path;
use std::process;

#[derive(Default, Debug, Serialize, Deserialize)]
struct SongData {
  path: String,
  text: String,
  meta: SongMeta,
}

#[derive(Default, Debug, Serialize, Deserialize)]
struct SongMeta {
  #[serde(skip_serializing_if = "Option::is_none")]
  title: Option<String>,
  #[serde(skip_serializing_if = "Option::is_none")]
  poet: Option<String>,
  #[serde(skip_serializing_if = "Option::is_none")]
  composer: Option<String>,
  #[serde(skip_serializing_if = "Vec::is_empty")]
  index: Vec<String>,
  #[serde(skip_serializing_if = "Option::is_none")]
  misc: Option<String>,
  #[serde(skip_serializing_if = "Option::is_none")]
  margin: Option<SongMargins>,
  paths: SongPaths,
}

impl SongMeta {
  fn ensure_margin(&mut self) -> &mut SongMargins {
    self.margin.get_or_insert(SongMargins::default())
  }
}

#[derive(Default, Debug, Serialize, Deserialize)]
struct SongPaths {
  lyrics: String,
  #[serde(skip_serializing_if = "Option::is_none")]
  music: Option<String>,
}

#[derive(Default, Debug, Serialize, Deserialize)]
struct SongMargins {
  #[serde(skip_serializing_if = "Option::is_none")]
  verse: Option<MarginData>,
  #[serde(skip_serializing_if = "Option::is_none")]
  refrain: Option<MarginData>,
}

impl SongMargins {
  fn ensure_verse(&mut self) -> &mut MarginData {
    self.verse.get_or_insert(MarginData::default())
  }

  fn ensure_refrain(&mut self) -> &mut MarginData {
    self.refrain.get_or_insert(MarginData::default())
  }
}

#[derive(Default, Debug, Serialize, Deserialize)]
struct MarginData {
  #[serde(skip_serializing_if = "Option::is_none")]
  l: Option<String>,
  #[serde(skip_serializing_if = "Option::is_none")]
  r: Option<String>,
}

#[derive(Debug, Serialize, Deserialize)]
struct NoteData {
  path: String,
  text: String,
}

#[derive(Debug, Serialize, Deserialize)]
struct Song {
  song_data: SongData,
  note_data: Option<NoteData>,
}

#[derive(Debug)]
struct Config {
  input_file: String,
  output_path: String,
}

fn main() {
  // Get execution config.
  let args: Vec<String> = env::args().collect();
  let config = Config::new(&args).unwrap_or_else(|err| {
    println!("Problem parsing arguments: {}", err);
    process::exit(1);
  });

  // Parse metadata.
  let song = Song::new(&config).unwrap_or_else(|err| {
    println!("Problem parsing song: {}", err);
    process::exit(1);
  });

  // Write output.
  if let Err(err) = song.output(config) {
    println!("Problem writing output: {}", err);
    process::exit(1);
  }
}

impl Config {
  fn new(args: &[String]) -> Result<Config, &str> {
    if args.len() < 3 {
      return Err("not enough arguments");
    }
    let input_file = args[1].clone();
    let output_path = args[2].clone();
    Ok(Config {
      input_file,
      output_path,
    })
  }
}

impl Song {
  fn new(config: &Config) -> Result<Song, Box<dyn Error>> {
    let note_data = NoteData::new(&config.input_file)?;
    let song_data = SongData::new(&config.input_file, note_data.as_ref())?;
    Ok(Song {
      song_data,
      note_data,
    })
  }

  fn output(&self, config: Config) -> Result<(), Box<dyn Error>> {
    let yaml = serde_yaml::to_string(&self.song_data.meta)?;
    let out_path = Path::new(&config.output_path);

    // Lyrics
    let tex_path = out_path.join(&self.song_data.meta.paths.lyrics);
    fs::write(tex_path, &self.song_data.text)?;

    // Yaml
    let yml_path = out_path
      .join(&self.song_data.meta.paths.lyrics)
      .with_extension("yml");
    fs::write(yml_path, yaml.replacen("---", "--- !Laul", 1))?;

    // Notes
    match (&self.song_data.meta.paths.music, &self.note_data) {
      (Some(music_path), Some(note_data)) => {
        let ly_path = out_path.join(music_path).with_extension("ly");
        fs::write(ly_path, &note_data.text)?;
      }
      _ => (),
    }
    Ok(())
  }
}

impl NoteData {
  fn new(path: &String) -> Result<Option<NoteData>, Box<dyn Error>> {
    let input_path = Path::new(path);
    let notes_input_path = input_path
      .parent()
      .unwrap()
      .parent()
      .unwrap()
      .join("notes")
      .join(input_path.with_extension("ly").file_name().unwrap());
    let note_data = match notes_input_path.is_file() {
      true => Some(NoteData {
        text: fs::read_to_string(&notes_input_path)?,
        path: notes_input_path.to_string_lossy().to_string(),
      }),
      false => None,
    };
    Ok(note_data)
  }
}

impl SongData {
  fn new(path: &String, note_data: Option<&NoteData>) -> Result<SongData, Box<dyn Error>> {
    let input_path = Path::new(path);
    let song_contents = fs::read_to_string(&path)?;
    let mut song_data = SongData {
      path: path.clone(),
      meta: SongMeta {
        paths: SongPaths {
          lyrics: input_path
            .with_extension("tex")
            .file_name()
            .unwrap()
            .to_string_lossy()
            .to_string(),
          music: note_data.map(|d| {
            Path::new(&d.path)
              .file_name()
              .unwrap()
              .to_string_lossy()
              .to_string()
          }),
        },
        ..SongMeta::default()
      },
      ..SongData::default()
    };
    let mut output = Vec::<String>::new();
    for (prefix, text) in song_contents.lines().map(|l| SongData::parse_line(l)) {
      match (prefix, text) {
        (None, Some(t)) => output.push(t.to_string()),
        (Some("TITLE"), Some(t)) => song_data.meta.title = Some(t.to_string()),
        (Some("POET"), Some(t)) => song_data.meta.poet = Some(t.to_string()),
        (Some("COMPOSER"), Some(t)) => song_data.meta.composer = Some(t.to_string()),
        (Some("ADDLINDEX"), Some(t)) => song_data.meta.index.push(t.to_string()),
        (Some("MISC"), Some(t)) => song_data.meta.misc = Some(t.to_string()),
        (Some("LMARGIN"), Some(t)) => {
          song_data.meta.ensure_margin().ensure_verse().l = Some(t.to_string())
        }
        (Some("RMARGIN"), Some(t)) => {
          song_data.meta.ensure_margin().ensure_verse().r = Some(t.to_string())
        }
        (Some("REFLMARGIN"), Some(t)) => {
          song_data.meta.ensure_margin().ensure_refrain().l = Some(t.to_string())
        }
        (Some("REFRMARGIN"), Some(t)) => {
          song_data.meta.ensure_margin().ensure_refrain().r = Some(t.to_string())
        }
        _ => {}
      }
    }
    song_data.text = output.join("\n");
    Ok(song_data)
  }

  fn parse_line(line: &str) -> (Option<&str>, Option<&str>) {
    lazy_static! {
      static ref RE: Regex = Regex::new(r"^(%(.*)=)?(.*)$").unwrap();
    }
    let cap = RE.captures(line).unwrap();
    let prefix = cap.get(2).map(|p| p.as_str());
    let text = cap.get(3).map(|t| t.as_str());
    (prefix, text)
  }
}
