# Frame System - Lottie Only

## Overview
The frame system has been updated to use **Lottie animations only** for a cleaner, more dynamic experience.

## How It Works

### File Structure
Each frame consists of **2 files** with matching names:
- `frame_X.json` - The Lottie animation file (actual frame)
- `frame_X.jpg` - The thumbnail preview image

Example:
```
assets/frames/
├── frame_1.json  (Lottie animation)
├── frame_1.jpg   (Thumbnail)
├── frame_2.json  (Lottie animation)
├── frame_2.jpg   (Thumbnail)
└── ...
```

### Auto-Detection
The system **automatically discovers** all frames in the `assets/frames/` folder:
- Scans for all `.json` files in `assets/frames/`
- Automatically pairs each `.json` with its matching `.jpg` thumbnail
- No need to manually update code when adding/removing frames

### Adding New Frames
To add a new frame:
1. Create your Lottie animation and export as JSON
2. Create a thumbnail JPG with the same name
3. Copy both files to `assets/frames/`
4. Done! The frame will automatically appear in the editor

Example:
```
1. Create frame_10.json (Lottie animation)
2. Create frame_10.jpg (thumbnail preview)
3. Copy to assets/frames/
4. Frame automatically appears in the app!
```

### Removing Frames
To remove a frame:
1. Delete both the `.json` and `.jpg` files from `assets/frames/`
2. Done! The frame will automatically disappear from the editor

## Technical Details

### Frame Rendering
- **Editor Preview**: Uses `Lottie.asset()` to render animations
- **Play Page**: Uses `Lottie.asset()` with `repeat: true` for continuous loop
- **Thumbnails**: JPG images are used for selection UI to improve performance

### Code Locations
- Frame detection: `lib/editor_page.dart` (_BackdropSettingsPanelState._loadAssets)
- Frame rendering: 
  - `lib/widgets/preview_widget.dart` (_buildFrame)
  - `lib/play_page.dart` (_buildFrame)
- Thumbnail display:
  - `lib/editor_page.dart` (_ImageOption)
  - `lib/settings_panel.dart` (_ImageOption)

### Benefits
✅ No more PNG frames - cleaner codebase
✅ Dynamic, animated borders
✅ Auto-discovery - just copy/paste files
✅ JPG thumbnails for fast preview
✅ Easy to add/remove frames without code changes
