select rtrim(t.name), ta.*
  from team t, team_diff_averages ta
   where t.in_64 = true
      and ta.team_id = t.id;

select stddev(fgm),           
stddev(fga             ),
stddev(fgp             ),
stddev(tpm             ),
stddev(tpa             ),
stddev(tpp             ),
stddev(ftm             ),
stddev(fta             ),
stddev(ftp             ),
stddev(offense_rebound ),
stddev(total_rebound   ),
stddev(assist          ),
stddev(steal           ),
stddev(block           ),
stddev(turnover        ),
stddev(foul            ),
stddev(total_point     ),
stddev(ppp             ),
stddev(eff_fgp         ),
stddev(get_ft          ),
stddev(orp             ),
stddev(to_rate         ),
stddev(poss            )
 from team_diff_averages;

 select avg(fgm),           
 avg(fga             ),
 avg(fgp             ),
 avg(tpm             ),
 avg(tpa             ),
 avg(tpp             ),
 avg(ftm             ),
 avg(fta             ),
 avg(ftp             ),
 avg(offense_rebound ),
 avg(total_rebound   ),
 avg(assist          ),
 avg(steal           ),
 avg(block           ),
 avg(turnover        ),
 avg(foul            ),
 avg(total_point     ),
 avg(ppp             ),
 avg(eff_fgp         ),
 avg(get_ft          ),
 avg(orp             ),
 avg(to_rate         ),
 avg(poss            )
  from team_diff_averages;

