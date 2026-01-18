# 🎨 Storazzo USB Disk Monitor - Cross-Platform UI App

**Created:** 2026-01-18  
**Author:** Riccardo McDemo 🇮🇹 🍕  
**Status:** Planning Phase

## 📋 Overview

Create a cross-platform desktop application that automatically detects USB disk attachments, matches them against `.riccdisk.yml` configurations, and provides a beautiful UI to manage and monitor external storage devices.

## 🎯 Goals

1. **Automatic USB Detection**: Monitor USB device attachment events in real-time
2. **Configuration Matching**: Read and match against `.riccdisk.yml` files on attached disks
3. **Cross-Platform UI**: Single codebase that works on Windows, macOS, and Linux
4. **Real-time Updates**: Automatically update the app when new disks are attached/detached
5. **Disk Information Display**: Show disk stats, metadata, and health information

## 🛠️ Technology Stack Options

### **Recommended: Tauri** ⭐
- **What it is**: Modern alternative to Electron, using Rust backend + Web frontend
- **Pros**:
  - Much smaller binary size (~3MB vs 100MB+ for Electron)
  - Better performance and security
  - Native OS integration
  - Web technologies for UI (HTML/CSS/JavaScript)
  - Active community and modern tooling
- **Cons**:
  - Requires Rust knowledge for backend
  - Newer ecosystem (less mature than Electron)

### Alternative: Electron
- **What it is**: Build desktop apps with web technologies (Chromium + Node.js)
- **Pros**:
  - Very mature ecosystem
  - Huge community and resources
  - Easy to integrate with existing Ruby code via child processes
  - VSCode, Slack, Discord all use it
- **Cons**:
  - Large bundle sizes
  - Higher memory usage
  - Can feel "heavy"

### Alternative: Flutter Desktop
- **What it is**: Google's UI toolkit, now supports desktop
- **Pros**:
  - Beautiful, native-looking UIs
  - Single codebase for mobile + desktop
  - Fast performance
- **Cons**:
  - Dart language (new learning curve)
  - Smaller desktop ecosystem compared to web-based solutions

### Alternative: Qt (with Ruby bindings)
- **What it is**: C++ framework with Ruby bindings (qtbindings gem)
- **Pros**:
  - Native look and feel
  - Mature and stable
  - Can stay in Ruby ecosystem
- **Cons**:
  - Complex setup
  - Ruby bindings not as well maintained
  - Steeper learning curve

## 🏗️ Proposed Architecture

### Backend (Ruby)
```
storazzo/
├── lib/
│   └── storazzo/
│       ├── usb_monitor.rb       # USB device detection
│       ├── disk_matcher.rb      # Match disks to .riccdisk.yml
│       ├── disk_stats.rb        # Compute disk statistics
│       └── api_server.rb        # JSON API for UI communication
```

### Frontend (Tauri/Electron)
```
storazzo-ui/
├── src/
│   ├── components/
│   │   ├── DiskCard.jsx         # Individual disk display
│   │   ├── DiskList.jsx         # List of all disks
│   │   └── StatsPanel.jsx       # Statistics dashboard
│   ├── services/
│   │   └── api.js               # Communication with Ruby backend
│   └── App.jsx                  # Main application
```

## 🔄 USB Detection Strategy

### Linux
- Use `udev` events or monitor `/proc/mounts`
- Listen to D-Bus signals for device changes
- Ruby gem: `rb-inotify` or direct `udev` integration

### macOS
- Use `DiskArbitration` framework
- Monitor `/Volumes` directory
- Ruby gem: `rb-fsevent` for filesystem events

### Windows
- WMI (Windows Management Instrumentation) events
- Monitor drive letters
- Ruby gem: `win32-changenotify`

## 📊 Features Breakdown

### Phase 1: Core Functionality
- [ ] USB device detection on all platforms
- [ ] Read `.riccdisk.yml` from attached disks
- [ ] Basic UI showing connected disks
- [ ] Display disk metadata (name, size, type)

### Phase 2: Enhanced Features
- [ ] Real-time statistics (used/free space)
- [ ] Disk health monitoring
- [ ] Search/filter disks
- [ ] Export disk inventory to JSON/CSV

### Phase 3: Advanced Features
- [ ] Disk comparison (find duplicates)
- [ ] Backup status tracking
- [ ] Custom disk tagging and categorization
- [ ] Integration with cloud storage (GCS buckets)

## 🎨 UI Mockup Ideas

```
┌─────────────────────────────────────────────────┐
│  🗄️  Storazzo Disk Monitor                     │
├─────────────────────────────────────────────────┤
│                                                 │
│  📀 Connected Disks (3)                         │
│  ┌──────────────────────────────────────────┐  │
│  │ 💾 Riccardo's Backup 2TB                 │  │
│  │ /Volumes/RiccardoBackup                  │  │
│  │ ▓▓▓▓▓▓▓▓▓▓░░░░░░░░░░ 1.2TB / 2TB       │  │
│  │ Last Updated: 2026-01-15                 │  │
│  └──────────────────────────────────────────┘  │
│                                                 │
│  ┌──────────────────────────────────────────┐  │
│  │ 📸 Photos Archive 4TB                    │  │
│  │ /Volumes/PhotosArchive                   │  │
│  │ ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░░ 3.4TB / 4TB       │  │
│  │ Last Updated: 2026-01-10                 │  │
│  └──────────────────────────────────────────┘  │
│                                                 │
│  🔍 Search disks...                             │
└─────────────────────────────────────────────────┘
```

## 🚀 Getting Started

### Prerequisites
- Ruby 3.3+ (upgrade from current 2.7.5)
- Node.js 18+ (for Tauri/Electron frontend)
- Rust 1.70+ (if using Tauri)

### Development Setup
```bash
# 1. Upgrade Ruby
rbenv install 3.3.9
rbenv local 3.3.9

# 2. Install dependencies
bundle install

# 3. Set up UI framework (example for Tauri)
npm create tauri-app@latest storazzo-ui
cd storazzo-ui
npm install

# 4. Start development
npm run tauri dev
```

## 📝 Integration with Existing Storazzo

The new UI app will:
1. **Reuse** existing `RicDisk` classes for disk management
2. **Extend** with new `USBMonitor` class for real-time detection
3. **Expose** a JSON API for the UI to consume
4. **Maintain** backward compatibility with CLI tools

## 🤔 Open Questions

1. Should we bundle the Ruby runtime with the app, or require users to install Ruby?
2. Do we want to support mobile platforms (iOS/Android) in the future?
3. Should the app run as a system tray application or a full window?
4. How do we handle permissions for USB monitoring on different OSes?

## 📚 References

- **Tauri**: https://tauri.app/
- **Electron**: https://www.electronjs.org/
- **Flutter Desktop**: https://flutter.dev/desktop
- **Qt Ruby Bindings**: https://github.com/ryanmelt/qtbindings
- **USB Detection in Ruby**: https://github.com/larskanis/libusb

## 🎯 Next Steps

1. **Review** this plan with Riccardo
2. **Choose** the UI framework (recommendation: Tauri)
3. **Prototype** USB detection on Linux (Derek machine)
4. **Create** basic UI mockup
5. **Integrate** with existing Storazzo codebase

---

**Remember**: The best demoer of the west deserves the best cross-platform app! 🇮🇹 ✨
