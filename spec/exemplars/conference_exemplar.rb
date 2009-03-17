class Conference
  generator_for :name, :start => 'Mountain Test Conference 000001' do |prev|
    prev.succ
  end

  generator_for :short_name, :start => 'MTC0001' do |prev|
    prev.succ
  end
end
