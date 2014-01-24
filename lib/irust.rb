require "readline"
require "tmpdir"
require "open3"
require "colorize"

require "irust/template_renderer"

module IRust
  module_function

  def detect_rust
    rust_version = `rustc -v`
    puts "Using #{rust_version.split("\n").first}"
  rescue Errno::ENOENT
    STDERR.puts "No rustc detected! Please install Rust first!"
    STDERR.puts "See the Quick Start at: https://github.com/mozilla/rust/blob/master/README.md"
    exit 1
  end

  def read
    Readline.readline("irust> ", true)
  end

  def rust_program(line, history)
    IRust::TemplateRenderer.new(line, history).render
  end

  def compile(tmpdir, src)
    Dir.chdir(tmpdir) do
      stdin, stderr, status = Open3.capture3("rustc irust.rs")
      return true if status.success?

      error = "--- BEGIN FAILED PROGRAM ---\n"
      src.split("\n").each_with_index do |line, i|
          error << "#{i + 1}: #{line}\n"
      end
      error << "---- END FAILED PROGRAM ----"

      STDERR.puts error.red
      STDERR.puts stderr
      false
    end
  end

  def eval(line, history = nil)
    exit 0 if line.nil?

    Dir.mktmpdir do |tmpdir|
      src     = rust_program(line, history)
      srcfile = File.join(tmpdir, "irust.rs")
      File.write(srcfile, src)

      if compile(tmpdir, src)
        system srcfile.sub(/\.rs$/, '')
        history + ";\n" + line
      else
        history
      end
    end
  end

  def run
    detect_rust
    history = ""
    loop { history = eval read, history }
  end
end

