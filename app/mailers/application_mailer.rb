class ApplicationMailer < ActionMailer::Base
  # add_template_helper ApplicationHelper
  # add_template_helper ActionView::Helpers::UrlHelper
  # add_template_helper Rails.application.routes.url_helpers
  # add_template_helper MailerHelper

  layout 'mailer'
end
