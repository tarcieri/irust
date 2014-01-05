require "readline"
require "tmpdir"
require "open3"

require "irust/template_renderer"

module IRust
  module_function

  def read
    Readline.readline("irust> ", true)
  end

  def rust_program(line, history)
    IRust::TemplateRenderer.new(line, history).render
  end

  def compile(tmpdir)
    Dir.chdir(tmpdir) do
      stdin, stderr, status = Open3.capture3("rustc irust.rs")

      if status.success?
        true
      else
        STDERR.puts stderr
        false
      end
    end
  end

  def eval(line, history = nil)
    exit 0 if line.nil?

    Dir.mktmpdir do |tmpdir|
      input_src = File.join(tmpdir, "irust.rs")
      File.write input_src, rust_program(line, history)

      if compile(tmpdir)
        system input_src.sub(/\.rs$/, '')
        history + ";\n" + line
      else
        history
      end
    end
  end

  def run
    history = ""
    loop { history = eval read, history }
  end
end

