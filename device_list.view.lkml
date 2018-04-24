view: device_list {
  derived_table: {
    sql_trigger_value: SELECT FLOOR((EXTRACT(EPOCH FROM now() AT TIME ZONE 'US/Pacific') - 60*60*2)/(60*60*24)) ;;
    indexes: ["device_type"]
    sql: SELECT distinct
        case
        when  split_part( ${TABLE}.context_user_agent,'/',2)  ilike '%iphone%' then 'Mobile'
        when  split_part( ${TABLE}.context_user_agent,'/',2)  ilike '%ipad%' then 'Mobile'
        when  split_part( ${TABLE}.context_user_agent,'/',2)  ilike '%android%' then 'Mobile'
        when  split_part( ${TABLE}.context_user_agent,'/',2)  like '%Windows%' then 'Pc'
        when  split_part( ${TABLE}.context_user_agent,'/',2)  like '%Macintosh%' then 'Pc'
        when  split_part( ${TABLE}.context_user_agent,'/',2)  like '%AppleWeb%' then 'Pc'
        when  split_part( ${TABLE}.context_user_agent,'/',2)  like '%Linux%' then 'Pc'
        when  split_part( ${TABLE}.context_user_agent,'/',2)  like '%Googlebot%' then 'Bot'
        end device_type
      FROM follain_prod.tracks
      where received_at >= now() - interval '1 months'
       ;;
  }

  dimension: device_type {
    primary_key: yes
    type: string
    sql: ${TABLE}.device_type ;;
  }
}
