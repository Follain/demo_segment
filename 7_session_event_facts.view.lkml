view: session_event_facts {
  derived_table: {
    sql_trigger_value: select count(*) from ${track_facts.SQL_TABLE_NAME} ;;
    indexes: ["session_id"]
    sql: SELECT s.session_id,
        case when map.event  in ( 'log_in' ,
         'sign_up',
         'viewed_product_category',
         'viewed_product' ,
         'brand' ,
         'update_cart' ,
         'updated_quantity',
         'updated_qty',
         'shipping_submitted') then map.event
        when map.event ilike 'skin_%' then 'skin-quiz'
        else 'Other' end as event
        , MAX(map.received_at) AS ended_at
        , count(distinct map.event_id) AS num_pvs
      FROM ${sessions_trk.SQL_TABLE_NAME} AS s
      LEFT JOIN ${track_facts.SQL_TABLE_NAME} as map on map.session_id = s.session_id
      GROUP BY 1,2
       ;;
  }

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
