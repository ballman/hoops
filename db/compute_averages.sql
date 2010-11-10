drop table player_averages;
select pg.player_id as id,
       pg.player_id,
       count(*) as games_played,
       avg(pg.fgm) as fgm,
       avg(pg.fga) as fga,
       cast(sum(pg.fgm) as double precision)/(cast(sum(pg.fga) as double precision) + .00000000001) as fgp,
        avg(pg.tpm) as tpm,
        avg(pg.tpa) as tpa,
        cast(sum(pg.tpm) as double precision)/(cast(sum(pg.tpa) as double precision) + .00000000001) as tpp,
        avg(pg.ftm) as ftm,
        avg(pg.fta) as fta,
        cast(sum(pg.ftm) as double precision)/(cast(sum(pg.fta) as double precision) + .00000000001) as ftp,
        avg(pg.offense_rebound) as  offense_rebound,
        avg(pg.total_rebound) as total_rebound,
        avg(pg.assist) as assist,
        avg(pg.steal) as steal,
        avg(pg.block) as block,
        avg(pg.turnover) as turnover,
        avg(pg.foul) as foul,
        avg(pg.total_point) as total_point
  into player_averages
  from player_games pg,
       team_games tg,
       games g
 where pg.type = 'MasterPlayerGame'
   and tg.type = 'MasterTeamGame'
   and pg.team_game_id = tg.id
   and tg.game_id = g.id
   and g.played_on > '2010-11-1'
 group by player_id;


insert into player_averages
select id, id, 0,
       0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0
  from players
 where id not in (select id from player_averages);
