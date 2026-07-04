# YouTube Transcriber Plugin

A Claude Code Plugin for transcribing YouTube videos to text using yt-dlp and whisper-cli.

## Overview

This plugin extracts audio from YouTube videos and generates text transcripts. Useful for referencing video content when writing blog posts or articles.

### Key Features

- Extract audio from YouTube videos via yt-dlp
- Transcribe audio to text via whisper-cli (whisper.cpp)
- Japanese language transcription
- Clean output as a text file in the current directory
- Automatic cleanup of temporary audio files

## Installation

### Prerequisites

This plugin requires the following tools:

#### yt-dlp

```bash
brew install yt-dlp
```

#### whisper-cpp

```bash
brew install whisper-cpp
```

#### Whisper Model

A whisper.cpp compatible model file is required at:

```
~/.model/whisper/ggml-medium.bin
```

This path is environment-dependent. Download a compatible model from the whisper.cpp repository if not already present.

### Plugin Installation

```bash
# From GitHub
/plugin install yostos/claude-code-plugins/plugins/youtube-transcriber

# From local directory
/plugin install ./youtube-transcriber
```

## Usage

### Transcribe Command

```
/youtube-transcriber:transcribe <YouTube URL>
```

#### Example

```
/youtube-transcriber:transcribe https://www.youtube.com/watch?v=dQw4w9WgXcQ
```

#### Workflow

```
[YouTube URL]
      |
[yt-dlp: Extract audio as WAV]
      |
[whisper-cli: Transcribe to text]
      |
[Save transcript to current directory]
      |
[Cleanup temporary files]
      |
[Display transcript]
```

#### Output

- `<video_title>.txt` in the current directory

## Troubleshooting

### Tool Not Installed Error

```
Error: yt-dlp is not installed.
```

Solution: Install the required tools following the Prerequisites section.

### Model File Not Found

```
Error: Whisper model not found at ~/.model/whisper/ggml-medium.bin
```

Solution: Download a whisper.cpp compatible model and place it at the expected path.

### Download Failure

If yt-dlp fails to download, check:
- The YouTube URL is valid and accessible
- yt-dlp is up to date (`yt-dlp -U`)
- Network connectivity

### Slow Transcription

Transcription speed depends on:
- Audio length
- Model size (ggml-medium.bin is a balanced choice)
- Hardware capabilities

## License

MIT License

## Author

yostos

## Repository

https://github.com/yostos/claude-code-plugins
