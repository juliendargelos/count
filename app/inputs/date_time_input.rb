class DateTimeInput < SimpleForm::Inputs::DateTimeInput
  def input(wrapper_options)
    template.content_tag :div, super, class: 'form__group form__group--select'
  end
end
