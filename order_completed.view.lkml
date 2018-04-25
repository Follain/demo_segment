view: order_completed {
  sql_table_name: follain_prod.order_completed ;;

  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}.id ;;
  }

  dimension: anonymous_id {
    hidden: yes
    type: string
    sql: ${TABLE}.anonymous_id ;;
  }

  dimension: campaign_id {
    hidden: yes
    type: number
    sql: ${TABLE}.campaign_id ;;
  }

  dimension: checkout_id {
    hidden: yes
    type: string
    sql: ${TABLE}.checkout_id ;;
  }

  dimension: context_ip {
    hidden: yes
    type: string
    sql: ${TABLE}.context_ip ;;
  }

  dimension: context_library_name {
    hidden: yes
    type: string
    sql: ${TABLE}.context_library_name ;;
  }

  dimension: context_library_version {
    hidden: yes
    type: string
    sql: ${TABLE}.context_library_version ;;
  }

  dimension: context_page_path {
    hidden: yes
    type: string
    sql: ${TABLE}.context_page_path ;;
  }

  dimension: context_page_referrer {
    hidden: yes
    type: string
    sql: ${TABLE}.context_page_referrer ;;
  }

  dimension: context_page_title {
    hidden: yes
    type: string
    sql: ${TABLE}.context_page_title ;;
  }

  dimension: context_page_url {
    hidden: yes
    type: string
    sql: ${TABLE}.context_page_url ;;
  }

  dimension: context_user_agent {
    hidden: yes
    type: string
    sql: ${TABLE}.context_user_agent ;;
  }

  dimension: currency {
    hidden: yes
    type: string
    sql: ${TABLE}.currency ;;
  }

  dimension: email {
    hidden: yes
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: event {
    hidden: yes
    type: string
    sql: ${TABLE}.event ;;
  }

  dimension: event_text {
    hidden: yes
    type: string
    sql: ${TABLE}.event_text ;;
  }

  dimension: first_referral_source {
    type: string
    sql: ${TABLE}.first_referral_source ;;
  }

  dimension: first_referral_source_type {
    type: string
    sql: ${TABLE}.first_referral_source_type ;;
  }

  dimension: gift_cards_applied {
    hidden: yes
    type: string
    sql: ${TABLE}.gift_cards_applied ;;
  }

  dimension: last_referral_source {
    type: string
    sql: ${TABLE}.last_referral_source ;;
  }

  dimension: last_referral_source_type {
    type: string
    sql: ${TABLE}.last_referral_source_type ;;
  }

  dimension: message_id {
    hidden: yes
    type: string
    sql: ${TABLE}.message_id ;;
  }

  dimension: order_confirmation_number {
    hidden: yes

    type: string
    sql: ${TABLE}.order_confirmation_number ;;
  }

  dimension_group: order {
    hidden: yes
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.order_date ;;
  }

  dimension: order_id {
    label: "Order Number"
    type: string
    sql: ${TABLE}.order_id ;;
  }


  dimension_group: original_timestamp {
    hidden: yes
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.original_timestamp ;;
  }

  dimension_group: payment_exp {
    hidden: yes
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.payment_exp ;;
  }

  dimension: payment_last_four {
    hidden: yes
    type: string
    sql: ${TABLE}.payment_last_four ;;
  }

  dimension: payment_type {
    hidden: yes
    type: string
    sql: ${TABLE}.payment_type ;;
  }

  dimension: products {
    hidden: yes
    type: string
    sql: ${TABLE}.products ;;
  }

  dimension_group: received {
    hidden: yes
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.received_at ;;
  }

  dimension: revenue {
    hidden: yes
    type: number
    sql: ${TABLE}.revenue ;;
  }

  dimension_group: sent {
    hidden: yes
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.sent_at ;;
  }

  dimension: ship_city {
    hidden: yes
    type: string
    sql: ${TABLE}.ship_city ;;
  }

  dimension: ship_first_name {
    hidden: yes
    type: string
    sql: ${TABLE}.ship_first_name ;;
  }

  dimension: ship_last_name {
    hidden: yes
    type: string
    sql: ${TABLE}.ship_last_name ;;
  }

  dimension: ship_state {
    hidden: yes
    type: string
    sql: ${TABLE}.ship_state ;;
  }

  dimension: ship_street_address {
    hidden: yes
    type: string
    sql: ${TABLE}.ship_street_address ;;
  }

  dimension: ship_zip {
    hidden: yes
    type: string
    sql: ${TABLE}.ship_zip ;;
  }

  measure: shipping {
    type: sum
    sql: ${TABLE}.shipping ;;
    value_format_name: usd
  }

  dimension: shipping_cost {
    hidden: yes
    type: string
    sql: ${TABLE}.shipping_cost ;;
  }

  dimension: shipping_type {
    hidden: yes
    type: string
    sql: ${TABLE}.shipping_type ;;
  }

  measure: tax {
    type: sum
    sql: ${TABLE}.tax ;;
    value_format_name: usd
  }

  dimension: tax_amount {
    hidden: yes
    type: string
    sql: ${TABLE}.tax_amount ;;
  }

  dimension: template_id {
    hidden: yes
    type: number
    sql: ${TABLE}.template_id ;;
  }

  dimension_group: timestamp {
    hidden: yes
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.timestamp ;;
  }

  measure: order_total {
    type: sum
    sql: ${TABLE}.total ;;
    value_format_name: usd
  }

  dimension: user_id {
    type: string
    sql: ${TABLE}.user_id ;;
  }

  dimension_group: uuid_ts {
    hidden: yes
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.uuid_ts ;;
  }

  dimension: value {
    hidden: yes
    type: number
    sql: ${TABLE}.value ;;
  }

  measure: count {
    hidden: yes
    type: count
    drill_fields: [id, context_library_name, ship_first_name, ship_last_name]
  }
}
