# Live for RubyMotion
Live is a gem for RubyMotion that aims to implement some of the
ideas presented in Bret Victor's [inventing on principle](https://vimeo.com/36579366) keynote.
It interfaces with the REPL and
allows to control it from the comfort of your preferred text editor.
The resulting code can then be copied to the source files
with minimal adjustments required.

### Collaborate

Contributors are welcome and get push access once their first commit is accepted.

### Installation

```console
$ [sudo] gem install motion-live
```

### Usage

Add the following line near the top of your `Rakefile`:

```
require 'motion-live'
```

Run motion-live:

```console
$ rake live
```

At this point you can just edit `LiveScratchpad.rb`,
hit save, and see the changes being propagated to the application.

By the default only the lines that weren't present in the previous
scratchpad are sent to the REPL.
This behaviour is more efficient and well suited for
changing the state of the application.
However, it is less convenient for redefining logic.
In this case is possible to include the `#nodiff` magic
comment, which forces to send the whole file.

### Known Caveats

- The code is interacting with REPL through a leaky abstraction. For example, using the nodiff mode in the demo shown in the video would result in new views being created every time the file is saved.
- Methods and classes which are not actually used by the compiled code might be striped and thus will not be available at runtime.
- Long declarations might choke the REPL and crash the simulator.
- This is a 0.1 release.

### License

The project is available under the MIT license.

