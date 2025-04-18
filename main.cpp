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