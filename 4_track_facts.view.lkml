# Determines event sequence numbers within session

view: track_facts {
  sql_table_name: analytics_segment.segment_track_facts ;;

  dimension: event_id {
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.event_id ;;
  }

  dimension: event {
    #     hidden: true
    sql: ${TABLE}.event ;;
  }

  dimension: uuid {
    hidden: yes
    sql: ${TABLE}.id ;;
  }

  dimension: session_id {
    sql: ${TABLE}.session_id ;;
  }

  measure: count_session {
    type: count_distinct
    sql: ${TABLE}.session_id ;;
  }

  dimension: looker_visitor_id {
    sql: ${TABLE}.looker_visitor_id ;;
  }

  dimension: sequence_number {
    type: number
    sql: ${TABLE}.track_sequence_number ;;
  }

  measure: count_visitors {
    type: count_distinct
    sql: ${looker_visitor_id} ;;
  }
}
