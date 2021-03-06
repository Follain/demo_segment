# Define Session Time Out Value
# Intermediate Tables

view: sessions_trk {
  sql_table_name: analytics_segment.segment_session_tracks ;;

  dimension: session_id {
    primary_key: yes
    sql: ${TABLE}.session_id ;;
  }

  dimension: looker_visitor_id {
    type: string
    sql: ${TABLE}.looker_visitor_id ;;
  }


  dimension: email {
    type: string
    sql: case when ${TABLE}.looker_visitor_id like'%@%' then ${TABLE}.looker_visitor_id end ;;
  }

  dimension: has_email {
    type: yesno
    sql:${TABLE}.looker_visitor_id like'%@%' ;;
  }

  dimension: ga_grouping {
    label: "Initial GA Grouping"
    type: string
    sql: ${TABLE}.ga_grouping ;;
  }

  dimension_group: start {
    type: time
    timeframes: [quarter,quarter_of_year,month_num,time, date,year, week, month, hour_of_day, day_of_week, day_of_week_index ]
    sql: ${TABLE}.session_start_at ;;
  }

  dimension: start_week_of_year{
  group_label: "Start Date"
  type: number
  sql: EXTRACT(week FROM (${TABLE}.start_at AT TIME ZONE 'UTC' + '1 day'::interval));;
  }

  dimension: sequence_number {
    type: number
    sql: ${TABLE}.session_sequence_number ;;
  }
  dimension: device_type {
    label: "Initial Device Type"
    sql: ${TABLE}.device_type ;;
    suggest_explore:   device_list
    suggest_dimension: device_list.device_type
  }
  dimension: is_first_session {
    #     type: yesno
    sql: CASE WHEN ${sequence_number} = 1 THEN 'First Session'
           ELSE 'Repeat Session'
      END
       ;;
  }

  dimension_group: next_session_start_at {
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.next_session_start_at ;;
  }

  dimension: session_duration_minutes {
    type: number
    sql: date_part('minute',${session_trk_facts.ended_at_time}::timestamp-${start_time}::timestamp) ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }
  measure: count_session {
    type: count_distinct
    sql: ${TABLE}.session_id ;;
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
    fields: [session_id, looker_visitor_id, start_date, sequence_number, next_session_start_at_date]
  }
}
