view: user_session_facts {
  sql_table_name: analytics_segment.segment_user_session_facts ;;

  #     Define your dimensions and measures here, like this:
  dimension: looker_visitor_id {
    hidden: yes
    primary_key: yes
    sql: ${TABLE}.looker_visitor_id ;;
  }

  dimension: number_of_sessions {
    type: number
    sql: ${TABLE}.number_of_sessions ;;
  }

  dimension: number_of_sessions_tiered {
    type: tier
    sql: ${number_of_sessions} ;;
    tiers: [
      1,
      2,
      3,
      4,
      5,
      10
    ]
  }

  dimension_group: first {
    type: time
    timeframes: [date, week, month]
    sql: ${TABLE}.first_date ;;
  }

  dimension_group: last {
    type: time
    timeframes: [date, week, month]
    sql: ${TABLE}.last_date ;;
  }
}
