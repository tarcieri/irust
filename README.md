# iRust: Interactive Rust REPL

Rust does not presently have a Read Eval Print Loop (REPL) that allows
interactive usage of the language on-the-fly without the need to write full
programs. Or rather, Rust does ship a REPL, but it's broken and won't be fixed
until Rust natively supports JIT compilation.

iRust is a Ruby-powered band-aid of a Rust REPL that shells out to the Rust
compiler for you and lets you use the language semi-interactively. It's not
great, but if you're looking for a way to play around with Rust quickly and
easily, it might get the job done.

## Installation

To use iRust you must first install Rust. Please refer to the
[Rust README](https://github.com/mozilla/rust) for Rust installation directions.
Or if you're an impatient Mac user and you have
[Homebrew](https://github.com/homebrew/homebrew) installed, run:

    $ brew install rust

After you've installed Rust, you'll need Ruby. You can find installers for Ruby
for various platforms here:

* **Windows**: [RubyInstaller](http://rubyinstaller.org/)
* **Mac or Linux**: [RVM](https://rvm.io/)
* **Mac or Linux**: [chruby](https://github.com/postmodern/chruby)
* **Java**: [JRuby](http://www.jruby.org/download)

Next, install the irust gem:

    $ gem install irust

Congrats, it should be installed and working now!

## Usage

Now that you have iRust installed, run:

    $ irust

This should give you the following prompt:

    Using rustc 0.9-pre (619c4fc 2013-12-23 11:26:34 -0800)
    irust>

Now type some fancy Rust expressions and watch them get magically evaluated
before your eyes!

    irust> 2+2
    4 : int
    irust>

Technology!

## Contributing

* Fork this repository on github
* Make your changes and send us a pull request
* If we like them we'll merge them

## License

Copyright (c) 2014 Tony Arcieri. Distributed under the MIT License. See
LICENSE.txt for further details.
