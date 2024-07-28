# bstdlib
Better standard library for Lua. Documentation coming soon.
### Building
To build bstdlib to your liking, use `./macro.ts` (requires bun). Syntax is `./macro.ts input.lua output.lua [...options]`. Currently only supports defining macros with `-Dname=value` (gcc syntax) if value is not specified it'll default to "".
For example: `./macro.ts bstd.lua output.lua -DINCL_FSTR -DTARGET=OpenOS` will include format strings and target OpenOS. You can build it with default settings by just omitting the `-D` flags like this: `./macro.ts bstd.lua output.lua`, also if the second argument (output file) is `-` it'll print to stdout.  
The version from GitHub Actions is the default build of bstd.lua in this repository targetting OpenOS without `filesystem`. Use it if you can't build bstd or is too lazy to.
### Macro flags
- `NO_FILESYSTEM`: Exclude `filesystem` (required if you're running in a standalone lua interpreter)
- `NO_STRING`: Exclude `string`
- `NO_TABLE`: Exclude `table`
- `NO_URL`: Exclude `url`
- `NO_BYTES`: Exclude `bytes`
- `INCL_FSTR`: Include bstd format strings
- `TARGET=OpenOS`: Target OpenOS (to be done)
### macro.ts
This is a macro preprocessor that is used in this project. Written for Bun, might not work on other runtimes. Once it gets mature enough it'll probably be moved to its own repository.
### Running Tests
First, build bstdlib with `./macro.ts bstd.lua bstdduck.lua -DNO_FILESYSTEM` then just run `lua test.lua`. You'll have to do this in OpenOS if you want to test filesystem as well (TBD)
