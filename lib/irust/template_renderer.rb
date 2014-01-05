require 'erb'

module IRust
  class TemplateRenderer
    RUST_TEMPLATE = File.expand_path("../template.rs.erb", __FILE__)

    attr_reader :rust_code, :history

    def initialize(rust_code, history = nil)
      @rust_code, @history = rust_code, history
    end

    def render
      template = File.read(RUST_TEMPLATE)
      ERB.new(template).result(binding)
    end

    def let_var
      rust_code[/^\s*(let|fn)\s+(mut\s+)?(\w+)/, 3]
    end
  end
end
