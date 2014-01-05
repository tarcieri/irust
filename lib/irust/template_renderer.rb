require 'erb'

module IRust
  class TemplateRenderer
    RUST_TEMPLATE = File.expand_path("../template.rs.erb", __FILE__)

    attr_reader :rust_code, :history

    def initialize(rust_code, history = nil)
      @rust_code, @history = rust_code, history
    end

    def render
      template = ERB.new File.read(RUST_TEMPLATE)
      template.result(binding)
    end

    def let_var
      line = rust_code
      if %w(let fn).include? line.split[0]
        q = line.split(%r{=|\s|\(})[1]
        if q == "mut"
          q = line.split(%r{=|\s|\(})[2]
        end
        q
      end
    end
  end
end
