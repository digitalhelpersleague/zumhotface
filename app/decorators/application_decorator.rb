class AttachmentDecorator < ApplicationDecorator

  decorates_finders
  delegate_all

  include Draper::LazyHelpers

end
