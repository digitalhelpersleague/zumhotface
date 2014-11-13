class Storage
  attr_accessor :total
  attr_accessor :free
  attr_accessor :used

  def initialize(total: nil, used: nil)
    @total = total
    @used = used.to_i
    if @total.nil?
      @free = `#{which('df')} -B1 . | tail -n1 | awk '{ print $4 }'`.strip.to_i
      @total = @free + @used
    else
      @free = @total - @used
    end
  end

  private

  def which(executable)
    if File.file?(executable) && File.executable?(executable)
      executable
    elsif ENV['PATH']
      path = ENV['PATH'].split(File::PATH_SEPARATOR).find do |p|
        File.executable?(File.join(p, executable))
      end
      path && File.expand_path(executable, path)
    end
  end

end
