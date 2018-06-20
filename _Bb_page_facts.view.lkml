view: page_facts {
  sql_table_name: analytics_segment.segment_page_facts ;;

  dimension: event_id {
    hidden: yes
    primary_key: yes
    sql: ${TABLE}.event_id ;;
  }
  dimension: ga_grouping {
    label: "GA Grouping"
    type: string
    sql: ${TABLE}.ga_grouping ;;
  }
  dimension: device_type {
    label: "Device Type"
    sql: ${TABLE}.device_type ;;
    suggest_explore:   device_list
    suggest_dimension: device_list.device_type
  }

  dimension: duration_page_view_seconds {
    type: number
    sql: ${TABLE}.lead_idle_time_condition ;;
  }

  dimension: is_last_page {
    type: yesno
    sql: ${duration_page_view_seconds} is NULL ;;
  }

  dimension: looker_visitor_id {
    hidden: yes
    type: string
    sql: ${TABLE}.looker_visitor_id ;;
  }

  dimension_group: received {
    hidden: yes
    type: time
    datatype: timestamp
    timeframes: [
      raw,
      time,
      date,
      month,
      day_of_week,
      year
    ]
    sql: ${TABLE}.received_at ;;
  }

  set: detail {
    fields: [event_id, duration_page_view_seconds]
  }
}
