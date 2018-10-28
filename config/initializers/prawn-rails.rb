PrawnRails.config do |config|
  config.page_layout = :portrait
  config.page_size   = "A4"
  config.skip_page_creation = false
end

class Prawn::Document
  alias_method :base_initialize, :initialize
  def initialize(options = {}, &block)
    @text_transform = {
      humanize: true,
      spaced: false,
      upcase: false
    }

    base_initialize options, &block
  end

  def lib_font(name, style: :extrabold, extension: :ttf)
    font Rails.root + "lib/fonts/#{name.to_s.camelize}-#{style.to_s.camelize}.#{extension}"
  end

  def text_transform(spaced: nil, upcase: nil)
    state = @text_transform.dup if block_given?

    @text_transform[:spaced] = !!spaced unless spaced.nil?
    @text_transform[:upcase] = !!upcase unless upcase.nil?

    if block_given?
      yield
      @text_transform = state
    end
  end

  def spaced_text(string, options = {})
    text string.to_s.split('').join(' '), options
  end

  alias_method :base_text, :text
  def text(string, options = {})
    string = string.to_s

    string = string.humanize if @text_transform[:humanize]
    string = string.split('').join ' ' if @text_transform[:spaced]
    string = string.upcase if @text_transform[:upcase]

    base_text string, options
  end

  [:top, :right, :bottom, :left].each do |name|
    define_method("margin_#{name}") { page.margins[name] }
  end

  def margin_width
    margin_left + margin_right
  end

  def margin_height
    margin_top + margin_bottom
  end

  def inner_width
    bounds.width
  end

  def width
    inner_width + margin_width
  end

  def inner_height
    bounds.height
  end

  def height
    inner_height + margin_height
  end
end
