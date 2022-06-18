use flutter_rust_bridge::{support::lazy_static, StreamSink};
use image::{io::Reader as ImageReader, GenericImageView, ImageBuffer, ImageFormat, Rgba};
use std::sync::{Arc, Mutex};

// This is the entry point of your Rust library.
// When adding new code to your project, note that only items used
// here will be transformed to their Dart equivalents.

// A plain enum without any fields. This is similar to Dart- or C-style enums.
// flutter_rust_bridge is capable of generating code for enums with fields
// (@freezed classes in Dart and tagged unions in C).
pub enum Platform {
    Unknown,
    Android,
    Ios,
    Windows,
    Unix,
    MacIntel,
    MacApple,
    Wasm,
}

lazy_static! {
    static ref LISTENER: Arc<Mutex<Option<StreamSink<String>>>> = Default::default();
}

pub fn register_listener(listener: StreamSink<String>) -> anyhow::Result<()> {
    (*LISTENER.lock().unwrap()) = Some(listener);
    Ok(())
}

pub fn create_event(event: String) {
    if let Some(ref listener) = *LISTENER.lock().unwrap() {
        listener.add(event);
    } else {
        println!("no listener!");
    }
}

// A function definition in Rust. Similar to Dart, the return type must always be named
// and is never inferred.
pub fn platform() -> Platform {
    // This is a macro, a special expression that expands into code. In Rust, all macros
    // end with an exclamation mark and can be invoked with all kinds of brackets (parentheses,
    // brackets and curly braces). However, certain conventions exist, for example the
    // vector macro is almost always invoked as vec![..].
    //
    // The cfg!() macro returns a boolean value based on the current compiler configuration.
    // When attached to expressions (#[cfg(..)] form), they show or hide the expression at compile time.
    // Here, however, they evaluate to runtime values, which may or may not be optimized out
    // by the compiler. A variety of configurations are demonstrated here which cover most of
    // the modern oeprating systems. Try running the Flutter application on different machines
    // and see if it matches your expected OS.
    //
    // Furthermore, in Rust, the last expression in a function is the return value and does
    // not have the trailing semicolon. This entire if-else chain forms a single expression.
    if cfg!(windows) {
        Platform::Windows
    } else if cfg!(target_os = "android") {
        Platform::Android
    } else if cfg!(target_os = "ios") {
        Platform::Ios
    } else if cfg!(all(target_os = "macos", target_arch = "aarch64")) {
        Platform::MacApple
    } else if cfg!(target_os = "macos") {
        Platform::MacIntel
    } else if cfg!(target_family = "wasm") {
        Platform::Wasm
    } else if cfg!(unix) {
        Platform::Unix
    } else {
        Platform::Unknown
    }
}

// The convention for Rust identifiers is the snake_case,
// and they are automatically converted to camelCase on the Dart side.
pub fn rust_release_mode() -> bool {
    cfg!(not(debug_assertions))
}

pub fn try_read_image(path: String, size: u32) -> anyhow::Result<()> {
    create_event("Read starting...".to_string());
    let cloned = path.clone();
    let img = match ImageReader::open(path)?.with_guessed_format() {
        Ok(img) => img,
        Err(e) => {
            create_event("Error reading image: ".to_string() + &e.to_string());
            panic!()
        }
    };
    let img = match img.decode() {
        Ok(img) => img,
        Err(e) => {
            create_event("Error decoding image: ".to_string() + &e.to_string());
            panic!()
        }
    };

    let img = _create_grid(&img, size)?;

    let _img = img.save_with_format(cloned, ImageFormat::Png)?;
    create_event("Read successfully.".to_string());

    Ok(())
}

fn _create_grid(
    img: &image::DynamicImage,
    size: u32,
) -> anyhow::Result<ImageBuffer<image::Rgba<u8>, Vec<u8>>> {
    let final_image_size = size;
    let granularity = img.height() / final_image_size;
    let grid: ImageBuffer<image::Rgba<u8>, Vec<u8>> =
        ImageBuffer::from_fn(final_image_size, final_image_size, move |x, y| {
            _get_local_avg_color(img, x, y, granularity)
        });

    Ok(grid)
}

fn _get_local_avg_color(
    img: &image::DynamicImage,
    x: u32,
    y: u32,
    granularity: u32,
) -> image::Rgba<u8> {
    let mut r: u32 = 0;
    let mut g: u32 = 0;
    let mut b: u32 = 0;
    for (_i, j) in (x..x + granularity).enumerate() {
        for (_k, l) in (y..y + granularity).enumerate() {
            if j < img.width() && l < img.height() {
                let pixel = img.get_pixel(j, l);
                r += u32::from(pixel[0]);
                g += u32::from(pixel[1]);
                b += u32::from(pixel[2]);
            }
        }
    }
    let num = granularity * granularity;
    Rgba([(r / num) as u8, (g / num) as u8, (b / num) as u8, 255])
}
