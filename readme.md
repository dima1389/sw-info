# SW Info Embedding and Build Comparison

This educational project demonstrates how to embed structured software metadata (`sw_info`) into a dedicated section of a microcontroller firmware image using C, linker scripts, and the `arm-none-eabi` GCC toolchain. It also explores techniques for building and comparing different firmware versions to observe the impact of various compilation flags and configurations.

## 🧾 Purpose

The main goal is to illustrate how embedded software version information can be:
- Defined and structured in C (`sw_info.c`)
- Mapped to a specific memory section via a linker script (`linker.ld`)
- Compiled into binary formats (HEX, BIN, S19)
- Compared between different builds to observe binary-level differences

## 🛠 Project Structure

- **`build_basic/`**  
  Output directory for the basic build.

- **`build_advanced/`**  
  Output directory for the advanced build.

- **`build_compare.log`**  
  Log file showing byte-by-byte differences between basic and advanced builds.

- **`build_sw_info.bat`**  
  Batch script that compiles both builds and performs the binary comparison.

- **`linker.ld`**  
  Linker script that defines the `.sw_info` memory section.

- **`sw_info.c`**  
  C source file containing the software version metadata structure.

- **`readme.md`**  
  This documentation file.

- **`See`**  
  A placeholder or helper file (purpose may vary).

## 📦 How It Works

- The `sw_info.c` file defines a structure with version and build metadata, placed into a custom section `.sw_info`.
- The `linker.ld` file allows fine control over memory layout and the address of `.sw_info`.
- The `build_sw_info.bat` script:
  - Compiles and links two builds: `basic` and `advanced` (with additional flags)
  - Generates HEX, BIN, and S19 output files
  - Compares object and executable files and logs binary differences into `build_compare.log`

## 🧪 Educational Value

This project is ideal for:
- Embedded systems students and engineers learning about linker scripts, custom sections, and build processes
- Understanding how small changes in source code or compiler flags impact the resulting firmware image
- Visualizing changes through byte-by-byte binary comparison

## 📋 Requirements

- GCC ARM toolchain (e.g., `arm-none-eabi-gcc`, `arm-none-eabi-ld`)
- Windows environment (for the batch file)
- Basic understanding of C and embedded development

## ✅ Example Use Case

You can modify the `sw_info` structure and recompile using the provided batch script. Observe how values change in the `.hex` or `.s19` files by inspecting the `build_compare.log`.

---

This project is public and free to use for learning, teaching, and experimenting with embedded software metadata embedding techniques.
