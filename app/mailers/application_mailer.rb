# rubocop:disable Style/Documentation
# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'
end
# rubocop:enable Style/Documentation
