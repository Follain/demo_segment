view: tracks {
  sql_table_name: analytics_segment.segment_tracks_qtr ;;

  dimension: anonymous_id {
    type: string
    sql: ${TABLE}.anonymous_id ;;
  }

  dimension: event {
    type: string
    sql: ${TABLE}.event ;;
  }

  dimension: event_text {
    type: string
    sql: ${TABLE}.event_text ;;
  }

  dimension: campaign_name
  {   label: "Campaign Name"
    type: string
    sql:  ${TABLE}.campaign_name end ;;}

  dimension: context_campaign_medium {
    label: "Campaign Medium"
    type: string
    sql: ${TABLE}.context_campaign_medium;;
  }


  dimension: ga_grouping {
    label: "Ga Grouping"
    type: string
    sql: ${TABLE}.ga_grouping;;}

  dimension: context_campaign_source {
    label: "Campaign Source"
    sql: ${TABLE}.context_campaign_source;;
  }

  dimension: context_user_agent {sql:context_user_agent;;}

dimension: device_source {
  label: "Device Source"
    sql: ${TABLE}.device_source;;}

dimension: device_type{
  label: "Device type"
  sql:  ${TABLE}.device_type;;}

  dimension_group: received {
    type: time
    timeframes: [raw, time, date, week, month]
    sql: ${TABLE}.received_at ;;
  }

  dimension: user_id {
    type: string
    hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  dimension: uuid {
    type: number
    hidden: yes
    value_format_name: id
    sql: ${TABLE}.id ;;
  }

  dimension: event_id {
    type: string
    sql: CONCAT(${received_raw}, ${uuid}) ;;
  }

  measure: count {
    label: "Nbr Registered Users"
    type: count
    drill_fields: [users.id]
  }

  ## Advanced Fields (require joins to other views)

  dimension: weeks_since_first_visit {
    type: number
    sql: FLOOR(date_part('minute',${received_date}-${user_session_facts.first_date})/7) ;;
  }

  dimension: is_new_user {
    sql: CASE
      WHEN ${received_date} = ${user_session_facts.first_date} THEN 'New User'
      ELSE 'Returning User' END
       ;;
  }

  measure: nbr_new_users {
    type: count_distinct
    sql: ${anonymous_id} ;;
    filters: {field: is_new_user value: "New User"}
  }

  measure: count_percent_of_total {
    type: percent_of_total
    sql: ${count} ;;
    value_format_name: decimal_1
  }

  ## Advanced -- Session Count Funnel Meausures

  filter: event1 {
      suggest_explore: event_list
      suggest_dimension: event_list.event_types

  }

  measure: event1_session_count {
    type: number
    sql: COUNT(
        DISTINCT(
          CASE
            WHEN
            {% condition event1 %} ${event} {% endcondition %}
              THEN ${track_facts.session_id}
            ELSE NULL END
        )
      )
       ;;
  }

  filter: event2 {
    suggest_explore: event_list
    suggest_dimension: event_list.event_types
  }

  measure: event2_session_count {
    type: number
    sql: COUNT(
        DISTINCT(
          CASE
            WHEN
            {% condition event2 %} ${event} {% endcondition %}
              THEN ${track_facts.session_id}
            ELSE NULL END
        )
      )
       ;;
  }

  filter: event3 {
    suggest_explore: event_list
    suggest_dimension: event_list.event_types
  }

  measure: event3_session_count {
    type: number
    sql: COUNT(
        DISTINCT(
          CASE
            WHEN
            {% condition event3 %} ${event} {% endcondition %}
              THEN ${track_facts.session_id}
            ELSE NULL END
        )
      )
       ;;
  }

  filter: event4 {
    suggest_explore: event_list
    suggest_dimension: event_list.event_types
  }

  measure: event4_session_count {
    type: number
    sql: COUNT(
        DISTINCT(
          CASE
            WHEN
            {% condition event4 %} ${event} {% endcondition %}
              THEN ${track_facts.session_id}
            ELSE NULL END
        )
      )
       ;;
  }
}
