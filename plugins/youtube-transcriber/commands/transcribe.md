---
description: Transcribe a YouTube video to text using yt-dlp and whisper-cli
argument-hint: <YouTube URL>
allowed-tools: ["Bash", "Read", "Write"]
---

# YouTube Transcription Command

Extract audio from a YouTube video and transcribe it to text.

## Processing Steps

1. **Environment Check**
   - Run: `which yt-dlp whisper-cli` to verify tools are installed
   - If any command is not found, provide installation instructions:
     - yt-dlp: `brew install yt-dlp`
     - whisper-cli: `brew install whisper-cpp`
   - Verify whisper model exists: `test -f ~/.model/whisper/ggml-medium.bin`
   - If model not found, display error and exit

2. **Extract Video Metadata**
   - Run: `yt-dlp --print title --no-download "<URL>"`
   - Capture the video title for output filename
   - Sanitize title for filename (remove special characters, replace spaces with underscores)

3. **Extract Audio**
   - Run: `yt-dlp -x --audio-format wav -o "/tmp/yt-transcribe-%(id)s.%(ext)s" "<URL>"`
   - Use `/tmp/` for temporary audio file
   - Note the output file path

4. **Transcribe Audio**
   - Run: `whisper-cli <audio_file> --model ~/.model/whisper/ggml-medium.bin --language ja --output-txt --no-fallback --threads 12`
   - This produces a `.txt` file alongside the audio file

5. **Save Result**
   - Read the generated transcript file
   - Write the transcript to `<sanitized_title>.txt` in the current directory

6. **Cleanup**
   - Delete the temporary audio file from `/tmp/`
   - Delete the temporary transcript file from `/tmp/`

7. **Display Result**
   - Show the output file path
   - Display the transcript content using the Read tool

## Important Guidelines

- **DO NOT** ask for user confirmation during processing - execute automatically
- **DO** verify all prerequisites before starting
- **DO** clean up temporary files even if an error occurs
- **DO** sanitize the video title for safe filename use (remove `/`, `\`, `:`, `*`, `?`, `"`, `<`, `>`, `|`)
- **DO** display the full transcript after completion

## Error Handling

- If URL is not provided, display: "Error: Please provide a YouTube URL. Usage: /youtube-transcriber:transcribe <URL>"
- If yt-dlp fails, display the error and suggest checking the URL
- If whisper-cli fails, display the error and suggest checking the model file
- Always attempt cleanup of temporary files regardless of errors

## Example Usage

```
/youtube-transcriber:transcribe https://www.youtube.com/watch?v=example
```
