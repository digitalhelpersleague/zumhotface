class AttachmentDecorator < ApplicationDecorator
  delegate_all

  decorates :attachment

end
