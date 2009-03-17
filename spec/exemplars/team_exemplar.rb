class Team
  generator_for :name, :start => 'University of Test 0000001' do |prev|
    prev.succ
  end
end
