class Upload::Blob < Upload
  include LanguageDetectable

  def size
    file_file_size
  end
end
