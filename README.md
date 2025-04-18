# AK-Starter-Project

[![Stars](https://img.shields.io/github/stars/Areshkew/AK-Starter-Project?style=social)](https://github.com/Areshkew/AK-Starter-Project/stargazers)
[![Forks](https://img.shields.io/github/forks/Areshkew/AK-Starter-Project?style=social)](https://github.com/Areshkew/AK-Starter-Project/network/members)
[![Watchers](https://img.shields.io/github/watchers/Areshkew/AK-Starter-Project?style=social)](https://github.com/Areshkew/AK-Starter-Project/watchers)

A starter project for building applications using the **AK Library** from [SerenityOS](https://serenityos.org/) and [Ladybird Web Browser](https://ladybird.dev/), with [Zig](https://ziglang.org/) as the build system. This project provides a lightweight, efficient foundation for developers looking to leverage the powerful utilities and data structures of the AK Library in their own applications.

---

## 📖 Overview

The **AK Library** is a custom C++ standard library replacement originally developed for SerenityOS. It offers a lightweight and efficient alternative to the STL, with features such as:

- **Core Data Structures**: Strings, containers, and more.
- **String Manipulation**: UTF-8/16/32 support, formatting, and building.
- **Memory Management**: Custom allocation utilities like `kmalloc`.
- **JSON Parsing/Serialization**: Easy handling of JSON data.
- **Time & Date Handling**: Tools for working with time zones and timestamps.
- **Encoding/Decoding**: Support for Base64 and Hex.
- **Path Manipulation**: Cross-platform file path handling.
- **Error Handling**: Robust primitives for error management.
- **Random Number Generation**: Secure and efficient utilities.
- **Debugging Tools**: Assertions and stack tracing.

This starter project integrates the AK Library with additional dependencies like `simdutf` for high-performance Unicode operations and a test suite for validating functionality. It uses Zig as the build system for simplicity and cross-platform compatibility.

---

## 🚀 Features

- **Preconfigured Build System**: Uses Zig for a modern, dependency-free build experience.
- **AK Library Integration**: Ready-to-use utilities and data structures from SerenityOS and Ladybird.
- **High-Performance Unicode**: Includes `simdutf` for fast UTF-8/16/32 and Base64 operations using SIMD instructions (SSE2, AVX2, NEON, etc.).
- **Test Suite**: Built-in testing framework to ensure code reliability.
- **C++23 Support**: Leverages modern C++ standards for better performance and readability.
- **Lightweight and Efficient**: Designed to be a minimal yet powerful foundation for new projects.

---

## 🛠️ Getting Started

### Prerequisites

- **Zig**: Install the Zig programming language and build system from [ziglang.org](https://ziglang.org/download/). (zig 0.14.0)
- **C++ Compiler**: Ensure you have a C++23-compatible compiler (e.g., `g++` or `clang++`) installed.

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/Areshkew/AK-Starter-Project.git
   cd AK-Starter-Project
   ```

2. Build the project using Zig:
   ```bash
   zig build
   ```

3. Run the example application:
   ```bash
   zig build run
   ```

4. Run the test suite:
   ```bash
   zig build test
   ```

### Project Structure

```
AK-Starter-Project/
├── AK/                # AK Library source files
├── Documentation/     # Documentation for the project
├── Libraries/         # External dependencies (simdutf, LibTest)
├── Tests/             # Test suites for AK Library
├── main.cpp           # Example application entry point
├── build.zig          # Zig build configuration
└── .gitignore         # Git ignore file
```

---

## 💻 Usage

The `main.cpp` file provides a basic example of using the AK Library. You can modify it to experiment with AK's features like `ByteString`, `JsonValue`, or `Utf8View`.

Example snippet from `main.cpp`:
```cpp
#include <AK/Vector.h>
#include <AK/ByteString.h>
#include <AK/Format.h>
#include <AK/String.h>
#include <AK/NonnullOwnPtr.h>

ErrorOr<int> hello_world(){
	auto str = TRY(ByteString::from_utf8("  Hello, World!  "sv));

    // Trim whitespace
    auto trimmed = str.trim_whitespace(TrimMode::Both);
    dbgln("Trimmed: {}", trimmed); // "Hello, World!"

    // Convert to uppercase
    auto upper = trimmed.to_uppercase();
    dbgln("Uppercase: {}", upper); // "HELLO, WORLD!"

    // Replace text
    auto replaced = upper.replace("WORLD"sv, "SERENITY"sv, ReplaceMode::All);
    dbgln("Replaced: {}", replaced); // "HELLO, SERENITY!"

    // Split on comma
    auto parts = trimmed.split(',');
    for (auto& part : parts) {
        dbgln("Part: {}", part); // "Hello", " World!"
    }

    return 0;
}

int main()
{
	auto result = hello_world();
    if (result.is_error()) {
        dbgln("Failed to process strings: {}", result.error());
        return 1;
    }

	#ifdef DEBUG
        outln("Message from DEBUG! :D");
    #endif

	AK::Vector<ByteString> suggestions;
	suggestions.append( ByteString::formatted("Hello Mundo!") );

	outln("Message from suggestions: {}", suggestions[0]);
	dbgln("Debug message :)");
	warnln("Warning message :o");
	return 0;
}
```

To add more functionality, explore the AK Library source in the `AK/` folder or refer to the SerenityOS and Ladybird documentation.

---

## 🧪 Running Tests

This project includes a test suite for the AK Library. To run all tests:
```bash
zig build test
```

Tests are located in `Tests/AK/` and are automatically discovered and compiled by the Zig build system.

---

## 🤝 Contributing

Contributions are welcome! If you have ideas for improvements or new features, feel free to:

1. Fork the repository.
2. Create a new branch for your changes.
3. Submit a pull request with a detailed description of your updates.

Please ensure your code follows the existing style and includes relevant tests.

---

## 📜 License

This project is licensed under the [MIT License](LICENSE) (or specify another license if applicable). The AK Library and other dependencies may have their own licensing terms; refer to their respective repositories for details.

---

## 🌟 Acknowledgments

- **SerenityOS**: For creating the AK Library as part of their innovative operating system.
- **Ladybird Web Browser**: For further developing and utilizing the AK Library.
- **simdutf**: For providing high-performance Unicode and Base64 operations.
- **Zig**: For a modern and efficient build system.

---

## 📞 Contact

For questions, suggestions, or feedback, feel free to open an [issue](https://github.com/Areshkew/AK-Starter-Project/issues).

---

**Start building with AK Library today!** Give this project a ⭐ if you find it useful, and share it with others who might benefit from a lightweight C++ library alternative.
