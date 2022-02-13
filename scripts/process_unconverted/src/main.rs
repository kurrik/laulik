use std::env;
use std::error::Error;
use std::fs;
use std::process;

#[derive(Default, Debug)]
struct SongData {
  path: String,
  text: String,
  title: Option<String>,
  poet: Option<String>,
  composer: Option<String>,
  addlindex: Option<String>,
  lmargin: Option<String>,
  rmargin: Option<String>,
  reflmargin: Option<String>,
  refrmargin: Option<String>,
}

#[derive(Debug)]
struct NoteData {
  path: String,
  text: String,
}

#[derive(Debug)]
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
    let song_data = SongData::new(&config.input_file)?;
    Ok(Song {
      song_data,
      note_data: None,
    })
  }

  fn output(&self, config: Config) -> Result<(), Box<dyn Error>> {
    println!("Config {:#?}", config);
    println!("Song {:#?}", self);
    Ok(())
  }
}

impl SongData {
  fn new(path: &String) -> Result<SongData, Box<dyn Error>> {
    let contents = fs::read_to_string(&path)?;
    let mut song_data = SongData {
      path: path.clone(),
      ..SongData::default()
    };
    let mut text = Vec::<String>::new();
    for line in contents.lines() {
      match line {
        _ => text.push(String::from(line)),
      }
    }
    song_data.text = text.join("\n");
    Ok(song_data)
  }
}
