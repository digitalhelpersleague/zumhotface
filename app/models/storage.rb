class Storage
  attr_accessor :total
  attr_accessor :free
  attr_accessor :used

  def initialize(total: nil, used: nil)
    @total = total
    @used = used.to_i
    if @total.nil?
      @free = `df -B1 . | tail -n1 | awk '{ print $4 }'`.strip.to_i
      @total = @free + @used
    else
      @free = @total - @used
    end
  end
end
