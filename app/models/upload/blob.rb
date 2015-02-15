require 'linguist'

class Upload::Blob < Upload

  include HasAttachment

  after_commit on: :create do
    LanguageDetectorJob.perform_later(self) if !encrypted?
  end

  def size
    file.size
  end

  def detect_language
    language = ::Linguist::FileBlob.new(file.path).language.try(:name)
    update_columns(lang: language) if language
  end
end
