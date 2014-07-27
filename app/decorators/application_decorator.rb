class ApplicationDecorator < Draper::Decorator

  decorates_finders
  delegate_all

  include Draper::LazyHelpers

end
