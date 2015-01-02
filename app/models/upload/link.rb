class Upload::Link < Upload

  def size
    link.bytesize
  end
end
