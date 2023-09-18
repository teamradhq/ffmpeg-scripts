# `ffmpeg` Scripts

This repository contains a collection of scripts that I use for various audio and video
processing tasks using `ffmpeg`. 


---


## Requirements

The scripts are only tested and working on macOS. They should work on Linux, but this is untested.

The following tools are required for these scripts to work:

- `bash`
- `exiftool`
- `ffmpeg` 
- `id3lib`
- `jq`
- `kcov`
- `shunit2`

Install using Homebrew:

### A note on `bash`

Some scripts use mapfiles which is not available on older version of `bash` that ship with macOS. To avoid
issues ensure that you have installed a newer version of `bash` using Homebrew.

```bash
brew install bash exiftool ffmpeg id3lib jq kcov shunit2
```

---


## Installation

1. Clone this repository
2. Add the `bin` directory to your `PATH` environment variable:
   ```bash
   export PATH="$PATH:/path/to/ffmpeg-scripts/bin"
   ```
3. Ensure that the scripts are executable:
   ```bash
   chmod +x /path/to/ffmpeg-scripts/bin/*
   ```

---


## Video Processing

For video processing, you should ensure a few things:

- Source videos are encoded in h.264 codec as all scripts assume this format.
- For best results when performing video splitting and concatenation, ensure that all frames in the source video 
  are keyframes. Videos that are not encoded with all keyframes may not split or concatenate properly with still
  images appearing at the start of sequences or audio being out of sync.


---


## Testing

Unit tests are provided using `shunit2`. To run the tests, simply call the test script from the root directory of 
this project:

```bash
./test/test-extract-tags.sh
```

---


## Examples

Refer to the `examples` directory for ideas on how these scripts could be used. 