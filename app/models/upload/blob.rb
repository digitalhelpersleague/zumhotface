class Upload::Blob < Upload
  include LanguageDetectable

  def size
    file.size
  end
end
