# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

# Rails Validation message don't make change style of page
ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
    html_tag.html_safe
end