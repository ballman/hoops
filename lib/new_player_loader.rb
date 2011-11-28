ENV["RAILS_ENV"] = 'development' if __FILE__ == $PROGRAM_NAME
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path(File.join(File.dirname(__FILE__),'..','config','environment'))
#require 'spec/autorun'
#require 'spec/rails'
require 'new_player'

class NewPlayerLoader
  attr_accessor :team

  def parse(file)
    line_index = 0
    file.each do |line|
      line_index += 1
      if ($running_main && line_index % 100 == 0)
        print "."
        STDOUT.flush
      end
      next if read_team(line)
      player = nil
      if (player = parse_player_line(line))
        if player.save
          # ok
        else
          puts "Line #{line_index}: Player invalid:"
          player.errors.each { |e| puts "   #{e}" }
        end
      else
        puts "LINE SKIPPED: #{line_index}"
      end
    end
  end    

  def read_team(line)
    if (line =~ /(\d+) :::: (.*)/)
      @team = $1.to_i
      true
    else
      false
    end
  end

  def parse_player_line(line)
    if line =~ /\s*(\d+)\s+(.+?)\s+([a-zA-Z\/\-]+?)\s+(\d[-\']\d\d?"?)\s+(\d+?)\s+(.+?)\s+(.+)/
      NewPlayer.new(:number => $1, :name => $2, :position => $3,
                    :height => $4, :weight => $5, :acad_year => $6,
                    :hometown => $7, :team_id => self.team)
    else
      nil
    end

  end

end

if __FILE__ == $PROGRAM_NAME
  ENV["RAILS_ENV"] = 'development'
  puts "Loading to #{ENV['RAILS_ENV']}"
  $running_main = 1
  NewPlayer.connection.execute("truncate table new_players;")
  loader = NewPlayerLoader.new
  loader.parse(File.open('2011-2012.txt'))
end

