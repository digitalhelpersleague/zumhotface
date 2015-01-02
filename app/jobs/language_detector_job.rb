require 'linguist'

class LanguageDetectorJob < ActiveJob::Base
  queue_as :linguist

  def perform(upload)
    language = Linguist::FileBlob.new(upload.file.path).language.try(:name)
    upload.update_attributes(lang: language) if language
  end
end
