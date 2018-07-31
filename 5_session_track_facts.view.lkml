# Facts about a particular Session.

view: session_trk_facts {
  sql_table_name: analytics_segment.segment_session_track_facts ;;

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
    sql: ${TABLE}.events_count;;
  }

  dimension: is_bounced_session {
    type: yesno
    sql: ${number_events} = 1 ;;
  }

  dimension: login {
    type: yesno
    sql: ${TABLE}.login_count > 0 ;;
  }

  dimension: subscribed {
    label: "Subscribed to NewsLetter"
    type: yesno
    sql: ${TABLE}.subscribed_count > 0 ;;
  }

  dimension: signup {
    type: yesno
    sql: ${TABLE}.count_signup > 0 ;;
  }
  dimension: skin_quiz {
    type: yesno
    sql: ${TABLE}.count_skin_quiz > 0 ;;
  }

  dimension: shipping {
    type: yesno
    sql: ${TABLE}.shipping_count > 0 ;;
  }

  dimension: view_pdp {
    type: yesno
    sql: ${TABLE}.pdp_count > 0 ;;
  }

  dimension: views {
    type: yesno
    sql: ${TABLE}.views_count > 0 ;;
  }

  dimension: view_plp {
    type: yesno
    sql: ${TABLE}.plp_count > 0 ;;
  }

  dimension: order_completed {
    type: yesno
    sql: ${TABLE}.order_completed_count > 0 ;;
  }

  dimension: cart {
    label: "Added to Cart"
    type: yesno
    sql: ${TABLE}.cart_count > 0 ;;
  }

  dimension: num_pvs {
    label: "Nbr Events"
    type: number
    sql: ${TABLE}.events_count ;;
  }


  measure: count_session {
    label: "Nbr Sessions"
    type: count_distinct
    sql: ${TABLE}.session_id ;;
  }

  measure: order_total {
    hidden: yes
    label: "Revenue"
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
      field: order_completed
      value: "yes"
    }
    drill_fields: [order_completed.order_id]
  }

  measure: count_cart {
    label: "Count Added to Cart"
    type: count

    filters: {
      field: cart
      value: "yes"
    }
  }


  measure: count_subscribed {
    type: count

    filters: {
      field: subscribed
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
