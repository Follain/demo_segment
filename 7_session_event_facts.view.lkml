view: session_event_facts {
  sql_table_name: analytics_segment.segment_session_event_facts ;;

  dimension: session_id {
    hidden: yes
    primary_key: yes
    sql: ${TABLE}.session_id ;;
  }

  dimension_group: ended_at {
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.ended_at ;;
  }

  dimension: number_events {
    type: number
    sql: ${TABLE}.num_pvs ;;
  }

  measure: number_sessions {
    type: count_distinct
    sql: ${TABLE}.session_id ;;
  }

  dimension: event {
    type: string
    sql: ${TABLE}.event ;;
  }

  set: detail {
    fields: [ended_at_date, event]
  }
}
