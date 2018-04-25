# Facts about a particular Session.

view: session_trk_facts {
  derived_table: {
    sql_trigger_value: select count(*) from ${track_facts.SQL_TABLE_NAME} ;;
    indexes: ["session_id"]
    sql: SELECT s.session_id
        , MAX(map.received_at) AS ended_at
        , count(distinct map.event_id) AS num_pvs
        , count(case when map.event like '%view%' then event_id else null end) as cnt_views
        , count(case when map.event = 'log_in' then event_id else null end) as cnt_login
        , count(case when map.event = 'signed_up_for_newsletter' then event_id else null end) as cnt_subscribed_to_blog
        , count(case when map.event = 'sign_up' then event_id else null end) as cnt_signup
        , count(case when map.event = 'viewed_product_category' then event_id else null end) as cnt_plp
        , count(case when map.event = 'viewed_product' then event_id else null end) as cnt_pdp
        , count(case when map.event = 'added_product' then event_id else null end) as cnt_cart
        , count(case when map.event = 'shipping_submitted' then event_id else null end) as cnt_shipping
        , count(case when map.event = 'skin_quiz_completed' then event_id else null end) as cnt_skinquiz
        , count(case when map.event = 'order_completed' then event_id else null end) as cnt_order_completed
        , sum(order_total) order_total
      FROM ${sessions_trk.SQL_TABLE_NAME} AS s
      LEFT JOIN ${track_facts.SQL_TABLE_NAME} as map on map.session_id = s.session_id
      GROUP BY 1
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

  dimension: is_bounced_session {
    type: yesno
    sql: ${number_events} = 1 ;;
  }

  dimension: login {
    type: yesno
    sql: ${TABLE}.cnt_login > 0 ;;
  }

  dimension: subscribed_to_blog {
    label: "Subscribed to NewsLetter"
    type: yesno
    sql: ${TABLE}.cnt_subscribed_to_blog > 0 ;;
  }

  dimension: signup {
    type: yesno
    sql: ${TABLE}.cnt_signup > 0 ;;
  }
  dimension: skin_quiz {
    type: yesno
    sql: ${TABLE}.cnt_skin_quiz > 0 ;;
  }

  dimension: shipping {
    type: yesno
    sql: ${TABLE}.cnt_shipping > 0 ;;
  }

  dimension: view_pdp {
    type: yesno
    sql: ${TABLE}.cnt_pdp > 0 ;;
  }

  dimension: views {
    type: yesno
    sql: ${TABLE}.cnt_views > 0 ;;
  }

  dimension: view_plp {
    type: yesno
    sql: ${TABLE}.cnt_plp > 0 ;;
  }

  dimension: view_completed {
    type: yesno
    sql: ${TABLE}.cnt_order_completed > 0 ;;
  }

  dimension: cart {
    type: yesno
    sql: ${TABLE}.cnt_cart > 0 ;;
  }

  dimension: num_pvs {
    type: number
    sql: ${TABLE}.num_pvs ;;
  }

  measure: count_events {
    label: "Nbr Events"
    type: sum
    sql: ${number_events} ;;
  }

  measure: count_session {
    label: "Nbr Sessions"
    type: count_distinct
    sql: ${TABLE}.session_id ;;
  }

  measure: order_total {
    label: "Order Total"
    type: sum
    sql: ${TABLE}.order_total ;;
  }
  measure: count_bounced {
    type: count_distinct
    sql: ${TABLE}.session_id ;;
    filters: {field: is_bounced_session  value: "yes"}
  }

  measure: count_login {
    type: count

    filters: {
      field: login
      value: "yes"
    }
  }

  measure: count_views {
    type: count

    filters: {
      field: views
      value: "yes"
    }
  }

  measure: count_view_pdp {
    type: count

    filters: {
      field: view_pdp
      value: "yes"
    }
  }

  measure: count_shipping {
    type: count

    filters: {
      field: shipping
      value: "yes"
    }
  }

  measure: count_skinquiz {
    type: count

    filters: {
      field: skin_quiz
      value: "yes"
    }
  }

  measure: count_view_plp {
    type: count

    filters: {
      field: view_plp
      value: "yes"
    }
  }

  measure: count_order_completed {
    type: count

    filters: {
      field: view_completed
      value: "yes"
    }
    drill_fields: [order_completed.order_id]
  }

  measure: count_cart {
    type: count

    filters: {
      field: cart
      value: "yes"
    }
  }


  measure: count_subscribed_to_blog {
    type: count

    filters: {
      field: subscribed_to_blog
      value: "yes"
    }
  }

  measure: count_signup {
    type: count

    filters: {
      field: signup
      value: "yes"
    }
  }

  set: detail {
    fields: [ended_at_date, num_pvs]
  }
}
