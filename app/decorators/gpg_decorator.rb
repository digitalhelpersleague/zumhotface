class GpgDecorator < ApplicationDecorator
  delegate_all

  decorates :gpg_key

end
