view: tracks_flow {
  sql_table_name: analytics_segment.segment_tracks_flow ;;

  dimension: event_id {
    primary_key: yes
    sql: ${TABLE}.event_id ;;
    hidden: yes
  }

  dimension: session_id {
    hidden: yes
    sql: ${TABLE}.session_id ;;
  }

  dimension: track_sequence_number {
    type: number
    hidden: yes
    sql: ${TABLE}.track_sequence_number ;;
  }

  dimension: event {
    #     hidden: true
    sql: ${TABLE}.event ;;
  }

  dimension: user_id {
    hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  dimension_group: received_at {
    type: time
    datatype: datetime
    timeframes: [date, week, month, year]
    sql: ${TABLE}.received_at ;;
  }

  dimension: event_2 {
    label: "2nd Event"
    sql: ${TABLE}.event_2 ;;
  }

  measure: event_1_count {
    type: count
  }

  measure: event_2_drop_off {
    label: "2nd Event Remaining Count"
    type: count

    filters: {
      field: event_2
      value: "-NULL"
    }
  }

  measure: event_2_3_dropoff_percent {
    value_format_name: percent_0
    type: number
    sql: cast(${event_3_drop_off} as float)/cast(${event_2_drop_off} as float) ;;
  }

  measure: event_3_4_dropoff_percent {
    value_format_name: percent_0
    type: number
    sql: ${event_4_drop_off}/${event_3_drop_off} ;;
  }

  dimension: event_3 {
    label: "3rd Event"
    sql: ${TABLE}.event_3 ;;
  }

  measure: event_3_drop_off {
    label: "3rd Event Remaining Count"
    type: count

    filters: {
      field: event_3
      value: "-NULL"
    }
  }

  dimension: event_4 {
    label: "4th Event"
    sql: ${TABLE}.event_4 ;;
  }

  measure: event_4_drop_off {
    label: "4th Event Remaining Count"
    type: count

    filters: {
      field: event_4
      value: "-NULL"
    }
  }

  dimension: event_5 {
    label: "5th Event"
    sql: ${TABLE}.event_5 ;;
  }

  measure: event_5_drop_off {
    label: "5th Event Remaining Count"
    type: count

    filters: {
      field: event_5
      value: "-NULL"
    }
  }

  set: detail {
    fields: [
      event_id,
      session_id,
      track_sequence_number,
      event,
      user_id,
      event_2,
      event_3,
      event_4,
      event_5
    ]
  }
}
