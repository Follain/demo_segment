## Intermediate Table

view: mapped_tracks {
  sql_table_name: analytics_segment.segment_mapped_tracks ;;


  dimension: anonymous_id {
    sql: ${TABLE}.anonymous_id ;;
  }

  dimension: uuid {
    sql: ${TABLE}.id ;;
  }

  dimension: event_id {
    sql: ${TABLE}.event_id ;;
  }

  dimension: ga_grouping {
    sql: ${TABLE}.ga_grouping ;;
  }

  dimension: device_type {
    label: "Device Type"
    sql: ${TABLE}.device_type ;;
    suggest_explore:   device_list
    suggest_dimension: device_list.device_type
  }

  dimension: looker_visitor_id {
    sql: ${TABLE}.looker_visitor_id ;;
  }

  dimension_group: received_at {
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.received_at ;;
  }

  dimension: event {
    sql: ${TABLE}.event ;;
  }

  dimension: idle_time_minutes {
    type: number
    sql: ${TABLE}.idle_time_minutes ;;
  }

  set: detail {
    fields: [event_id, looker_visitor_id, received_at_date, event, idle_time_minutes]
  }
}
