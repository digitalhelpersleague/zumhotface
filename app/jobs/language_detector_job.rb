require 'linguist'

class LanguageDetectorJob < ActiveJob::Base
  queue_as :linguist

  def perform(upload)
    #return self.class.perform_later(upload) unless File.exists?(upload.file.path)
    language = Linguist::FileBlob.new(upload.file.path).language.try(:name)
    upload.update_attributes(lang: language) if language
  end
end
