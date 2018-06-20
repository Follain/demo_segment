view: sessions_pg_trk {
  sql_table_name: analytics_segment.segment_session_page_tracks ;;

  dimension: session_id {
    hidden: yes
    sql: ${TABLE}.session_id ;;
  }

  dimension: ga_grouping {
    label: "Initial GA Grouping"
    type: string
    sql: ${TABLE}.ga_grouping ;;
  }
  dimension: device_type {
    label: "Initial Device Type"
    sql: ${TABLE}.device_type ;;
    suggest_explore:   device_list
    suggest_dimension: device_list.device_type
  }
  dimension: looker_visitor_id {
    type: number
    sql: ${TABLE}.looker_visitor_id ;;
  }

  dimension_group: start {
    type: time
    timeframes: [time, date, week, month, raw]
    sql: ${TABLE}.session_start_at ;;
  }

  dimension: session_sequence_number {
    type: number
    sql: ${TABLE}.session_sequence_number ;;
  }

  dimension_group: next_session_start_at {
    type: time
    timeframes: [time, date, week, month, raw]
    sql: ${TABLE}.next_session_start_at ;;
  }

  dimension: is_first_session {
    #     type: yesno
    sql: CASE WHEN ${session_sequence_number} = 1 THEN 'First Session'
           ELSE 'Repeat Session'
      END
       ;;
  }

  dimension: session_duration_minutes {
    type: number
    sql: DATE_part('minutes', ${session_pg_trk_facts.end_time}::timestamp-${start_time}::timestamp) ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: percent_of_total_count {
    type: percent_of_total
    sql: ${count} ;;
  }

  measure: count_visitors {
    type: count_distinct
    sql: ${looker_visitor_id} ;;
  }

  measure: avg_sessions_per_user {
    type: number
    value_format_name: decimal_2
    sql: ${count}::numeric / nullif(${count_visitors}, 0) ;;
  }

  measure: avg_session_duration_minutes {
    type: average
    sql: ${session_duration_minutes} ;;
    value_format_name: decimal_1
  }

  set: detail {
    fields: [session_id, looker_visitor_id, start_date, session_sequence_number, next_session_start_at_date]
  }
}
