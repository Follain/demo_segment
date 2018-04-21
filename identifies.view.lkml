view: identifies {
  sql_table_name: follain_prod.identifies ;;

  dimension: anonymous_id {
    type: string
    sql: ${TABLE}.anonymous_id ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension_group: received {
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.received_at ;;
  }

  dimension: user_id {
    type: string
    # hidden: true
    sql: ${TABLE}.user_id ;;
  }

  measure: nbr_emails {
    type: count_distinct
    sql:  ${TABLE}.email ;;
    # hidden: true
  }

  measure: count {
    type: count
    drill_fields: [users.id]
  }
}
