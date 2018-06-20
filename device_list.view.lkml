view: device_list {
  derived_table: {
    sql_trigger_value: SELECT FLOOR((EXTRACT(EPOCH FROM now() AT TIME ZONE 'US/Pacific') - 60*60*2)/(60*60*24)) ;;
    indexes: ["device_type"]
    sql: select distinct device_type
      FROM analytics_segment.segment_tracks_qtr
      where received_at >= now() - interval '1 months'
       ;;
  }

  dimension: device_type {
    primary_key: yes
    type: string
    sql: ${TABLE}.device_type ;;
  }
}
