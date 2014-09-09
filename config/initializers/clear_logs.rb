# Every time you run rails server or rails console it checks log sizes 
# and clears the logs for you if necessary.

if Rails.env.development?
  MAX_LOG_SIZE = 5.megabytes
  
  logs = File.join(Rails.root, 'log', "#{Rails.env}.log")
  if Dir[logs].any? {|log| File.size?(log).to_i > MAX_LOG_SIZE }
    $stdout.puts "Runing rake log:clear"
    `rake log:clear`
  end 
end
