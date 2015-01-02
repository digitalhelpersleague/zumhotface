class Upload::Code < Upload
  include LanguageDetectable

  def size
     code.bytesize
  end
end
