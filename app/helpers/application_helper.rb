module ApplicationHelper
  BUTTONS = [
    {
      action: :new,
      icon: :plus,
      type: :primary
    },
    {
      action: :edit,
      icon: :edit,
      type: :secondary
    },
    {
      action: :destroy,
      icon: :trash,
      type: :danger,
      method: :delete,
      confirm: {
        content: 'Please confirm you want to delete this',
        label: 'Delete',
        type: :danger
      }
    }
  ]

  def layout name, locals = {}, &block
    content_for :content, &block
    render template: "layouts/#{name}", locals: locals
  end

  def content
    content_for?(:content) ? content_for(:content) : yield
  end

  def symbols
    return '' unless @symbols.is_a? Hash

    content_tag :div, class: :symbols do
      @symbols.each { |_, symbol| concat symbol[:source].html_safe }
    end
  end

  def class_for(name, modifiers:)
    class_name = [name]

    modifiers.each do |modifier|
      if modifier.is_a? Hash
        class_name.concat! modifier.map { |key, value| "#{name}--#{key}--#{value}" }
      elsif modifier.present?
        class_name << "#{name}--#{modifier}"
      end
    end

    class_name.compact!
    class_name.join ' '
  end

  def container(*modifiers)
    @container ||= []
    @container.concat modifiers
    class_for :container, modifiers: @container
  end

  def index_view_for(collection, attributes: [])
    render 'application/index', collection: collection, attributes: attributes
  end

  def new_view_for(record)
    render 'application/new', record: record
  end

  def edit_view_for(record)
    render 'application/edit', record: record
  end

  def form_view_for(record, &block)
    render 'application/form', record: record, content: block
  end

  def use(path, *modifiers)
    @symbols ||= {}

    unless @symbols.key? path
      symbol = { name: path.to_s.parameterize.to_sym, source: File.read(__dir__ + "/../assets/images/#{path}.svg") }

      /\A.*?\bviewBox="(?:\d*\.)?\d+\s+(?:\d*\.)?\d+\s+(?<width>(?:\d*\.)?\d+)\s+(?<height>(?:\d*\.)?\d+)".*\z/m
        .match(symbol[:source])
        .named_captures
        .transform_values!(&:to_f)
        .symbolize_keys!
        .tap { |size| symbol.merge! size }

      symbol[:source].gsub! /\A(.*?<svg.*?>)(.*)(<\/svg>.*)\z/m, <<~HTML
        \\1
          <defs>
            <symbol id="symbol-#{symbol[:name]}" width="#{symbol[:width]}" height="#{symbol[:height]}" viewBow="0 0 #{symbol[:width]} #{symbol[:height]}">
              \\2
            </symbol>
          </defs>
        \\3
      HTML

      @symbols[path] = symbol
    end

    render 'application/symbol', symbol.merge(modifiers: modifiers)
  end

  def pdf(options = {}, &block)
    if block_given?
      prawn_document options, &(block.parameters.any? ? block : -> (pdf) { pdf.instance_eval &block })
    else
      prawn_document options
    end
  end

  def i(icon, options = {}, style: :solid)
    icon "fa#{style.to_s[0]}", icon.to_s, options
  end

  def button_link_to(label, path, *modifiers, method: nil, frame: nil, icon: nil, confirm: nil)
    label = label.to_s.humanize

    link_to(
      icon.present? ? i(icon) : label,
      path,
      method: method,
      class: class_for(:button, modifiers: modifiers),
      title: (label if icon.present?),
      data: {
        frame: frame.presence,
        confirm: confirm ? confirm.to_json : nil
      }
    )
  end

  BUTTONS.each do |action:, icon:, type:, on: :member, method: nil, confirm: nil|
    define_method "#{action}_button" do |record, minimal: false, frame: nil|
      model = (record.is_a?(ActiveRecord::Base) ? record.class : record).to_s

      button_link_to(
        "#{action} #{model}",
        url_for({
          controller: model.tableize,
          action: action,
          only_path: true,
          id: (record.id if record.is_a? ActiveRecord::Base)
        }),
        type,
        (:round if minimal),
        method: method,
        frame: frame,
        confirm: confirm,
        icon: (icon if minimal),
      )
    end
  end

  def markdown(source = nil, &block)
    @markdown ||= Redcarpet::Markdown.new(
      Redcarpet::Render::HTML.new(
        filter_html: true,
        hard_wrap: true,
        link_attributes: { rel: 'nofollow', target: '_blank' },
        space_after_headers: true,
        fenced_code_blocks: true
      ),
      {
        autolink: true,
        superscript: true,
        disable_indented_code_blocks: true
      }
    )

    content_tag :div, class: :markdown do
      concat @markdown.render(block_given? ? capture(&block) : source.to_s).html_safe
    end
  end
end

