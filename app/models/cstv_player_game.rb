class CstvPlayerGame < PlayerGame

  def boxscore_name
    player.cstv_bs_name
  end

  private
  def match_two_name(first_name, last_name)
    (player.first_name[0..first_name.length-1].casecmp(first_name) == 0 &&
     player.last_name[0..last_name.length-1].casecmp(last_name) == 0)
  end
  def match_three_name(first_name, last_name, suffix_name)
    (player.first_name[0..first_name.length-1].casecmp(first_name) == 0 &&
     player.last_name[0..last_name.length-1].casecmp(last_name) == 0 &&
     player.suffix_name[0..suffix_name.length-1].casecmp(suffix_name) == 0)
  end
end
