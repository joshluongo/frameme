# FrameMe

Quickly frame iOS screenshots, this is designed to use frames from https://developer.apple.com/design/resources/#product-bezels . This also works with Android, TV, Apple Watch or most other devices frames.

## Why?

While [fastlane/frameit](https://docs.fastlane.tools/actions/frameit/) is an excellent screenshot framing tool it relies on device frames from Facebook which often take a long time to receive new device images, this is a simple tool to use the offical Apple device "bezels".

## How does it work?

This is a fairly simple app that first analyses the device frame to determine where the screen is, this is done by starting at the centre pixel and working in each direction to find edges then it compares the X & Y findings to adjust for the curved frame edges.

Following that it creates a mask from the "screen" area that was found, it then applies this mask to the screenshot then overlays the two images.

After which it writes the framed image to the source folder with the suffix `_framed` just like frameit.

Given this uses CoreGraphics it is lightning fast compared to frameit.

## Usage

```
USAGE: frame-me [--skip-content-box] [--no-clip] [--output <output>] <frame> <screenshot> ...

ARGUMENTS:
  <frame>                 The frame to use.
  <screenshot>            The screenshots to process.

OPTIONS:
  --skip-content-box      Don't try and find the content box, just overlay the frame on the screenshot.
  --no-clip               Don't clip the screenshot to the frame.
  --force                 Force framing of file/s. By default files ending with '_framed' are skipped.
  --output <output>       The output folder. By default framed screenshots are
                          placed in the their original folder.
  -h, --help              Show help information.
```

## Example

`frameme ~/frames/iPhone\ 14\ Pro\ -\ Space\ Black\ -\ Portrait.png *.png`

## License

GNU General Public License v3.0
