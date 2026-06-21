# Changelog

## 0.0.1
- Manage text scaling according to screen size  
- Support dynamic text font size ranges  

## 0.1.0
- Fixed text font size range issues  
- Added support for multiple text ranges (small, normal, title, header)  

## 0.1.1
- Bug fixes and minor improvements  

## 0.2.0
- Added functionality to easily define text sizes for tablet and desktop  
- Example: `fontSize: 16.fs('m', t: 18, d: 22)`  

## 0.2.1
- Bug fixes and stability improvements  

## 1.0.0
### Breaking Changes
- `navigatorKey` is no longer required  

### Improvements
- Simplified text styling and font sizing  
- Added `didChangeSfsMetrics` callback (see example)  
- Resolved issues with `auto_route` package  

## 1.1.0
- Added responsive container helpers: `.h` (height), `.w` (width), `.r` (radius)  
- Simplified spacing with `.wbox` and `.hbox` utilities  

## 1.2.0
- Added padding extensions:
  - `16.p` → Scaled `EdgeInsets.all()`
  - `16.ph` → Scaled horizontal padding
  - `16.pv` → Scaled vertical padding  
- Added configuration options:
  - `respectSystemTextScale` for accessibility support  
  - `orientationAware` for better dimension handling  
- Code optimizations and performance improvements  

## Unreleased
### Added
- `foldableAware` config on `SfsInitBuilder` — clamps scaling to half the height when an unfolded foldable is detected (e.g. Pixel Fold 9 / Pixel Fold 10 / Samsung Foldable)  
- `splitScreenAware` config on `SfsInitBuilder` — clamps scaling when the app runs in split-screen / multi-window  
- Layout now also recalculates when the display size changes (e.g. entering/leaving split-screen), not just on window-size changes  