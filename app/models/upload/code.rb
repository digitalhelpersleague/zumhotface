class Upload::Code < Upload
  def size
     code.bytesize
  end
end
