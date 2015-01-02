module LanguageDetectable
  extend ActiveSupport::Concern

  included do
    after_commit on: :create do
      LanguageDetectorJob.perform_later(self) if file.try(:path) && !encrypted?
    end
  end
end
