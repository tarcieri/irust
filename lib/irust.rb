require "readline"
require "tmpdir"
require "open3"

module IRust
  module_function

  def read
    Readline.readline("irust> ", true)
  end

  def rust_program(hist,line)
    p=<<-RUST
#[feature(globs, macro_rules, struct_variant)];
extern mod extra;

fn main() {
  fn type_of<T>(_: &T) -> &'static str { unsafe {
    (*std::unstable::intrinsics::get_tydesc::<T>()).name } } struct
    Foo<T>(T);
  #{hist};
RUST
    if %w(let fn).include? line.split[0]
      q = line.split(/=|\s/)[1]
      if q == "mut"
        q = line.split(/=|\s/)[2]
      end
      p += <<-RUST
  #{line};
  println!("#{q} = {:?} : {:s}", #{q}, type_of(&#{q}))
}
RUST
    else
      p += <<-RUST
  let _it = {
    #{line}
  };
  println!("{:?} : {:s}", _it, type_of(&_it))
}
RUST
    end
    p
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

  def eval(hist,line)
    exit 0 if line.nil?

    Dir.mktmpdir do |tmpdir|
      input_src = File.join(tmpdir, "irust.rs")
      File.write input_src, rust_program(hist,line)

      if compile(tmpdir)
        system input_src.sub(/\.rs$/, '')
        hist+";\n"+line
      else
        hist
      end
    end
  end

  def run
    hist = ""
    loop { hist = eval hist,read }
  end
end

