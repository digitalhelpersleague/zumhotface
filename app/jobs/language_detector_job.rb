class LanguageDetectorJob < ActiveJob::Base
  queue_as :linguist

  def perform(upload)
    upload.detect_language
  end
end
