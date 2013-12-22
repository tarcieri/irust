require "readline"
require "tmpdir"
require "open3"

module IRust
  module_function

  def read
    Readline.readline("irust> ", true)
  end

  def rust_program(line)
<<-RUST
#[feature(globs, macro_rules, struct_variant)];
extern mod extra;

fn main() {
  let r = {
    fn type_of<T>(_: &T) -> &'static str { unsafe {
    (*std::unstable::intrinsics::get_tydesc::<T>()).name } } struct
    Foo<T>(T);
    #{line}
  };
  println!("{:?}", r)
}
RUST
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

  def eval(line)
    Dir.mktmpdir do |tmpdir|
      input_src = File.join(tmpdir, "irust.rs")
      File.write input_src, rust_program(line)

      if compile(tmpdir)
        system input_src.sub(/\.rs$/, '')
      end
    end
  end

  def run
    loop { eval read }
  end
end
