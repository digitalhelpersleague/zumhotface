require 'linguist'

class Jobs::LanguageDetector
  @queue = :language

  def self.perform(sid)
    @upload = Upload.find_by_sid!(sid)
    language = Linguist::FileBlob.new(@upload.file.path).language.try(:name)
    @upload.update_attributes(lang: language) if language
  end

end
