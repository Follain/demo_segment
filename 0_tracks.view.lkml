view: tracks {
  sql_table_name: follain_prod.tracks ;;

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

  dimension: context_campaign_name

  {   label: "Campaign Name"
    type: string
    sql: ${TABLE}.context_campaign_name  ;;}

  dimension: context_campaign_medium {
    label: "Campaign Medium"
    type: string
    sql: ${TABLE}.context_campaign_medium  ;;
  }

  dimension: context_campaign_source {
    label: "Campaign Source"
    type: string
    sql: ${TABLE}.context_campaign_source  ;;
  }

dimension: context_device_source {
    sql: case
when  split_part(context_user_agent,'/',2)  ilike '%iphone%' then 'Iphone'
when  split_part(context_user_agent,'/',2)  ilike '%ipad%' then 'Ipad'
when  split_part(context_user_agent,'/',2)  ilike '%android%' then 'Android'
when  split_part(context_user_agent,'/',2) like '%Windows%' then 'WindowsPc'
when  split_part(context_user_agent,'/',2)  like '%Macintosh%' then 'MacPc'
when  split_part(context_user_agent,'/',2)  like '%AppleWeb%' then 'MacPc'
when  split_part(context_user_agent,'/',2)  like '%Googlebot%' then 'Bot'

end ;;}

dimension: context_device_type{
  sql: case
when  split_part(context_user_agent,'/',2)  ilike '%iphone%' then 'Mobile'
when  split_part(context_user_agent,'/',2)  ilike '%ipad%' then 'Mobile'
when  split_part(context_user_agent,'/',2)  ilike '%android%' then 'Mobile'
when  split_part(context_user_agent,'/',2)  like '%Windows%' then 'Pc'
when  split_part(context_user_agent,'/',2)  like '%Macintosh%' then 'Pc'
when  split_part(context_user_agent,'/',2)  like '%AppleWeb%' then 'Pc'
when  split_part(context_user_agent,'/',2)  like '%Linux%' then 'Pc'
when  split_part(context_user_agent,'/',2)  like '%Googlebot%' then 'Bot'
end;;}

  dimension_group: received {
    type: time
    timeframes: [raw, time, date, week, month]
    sql: ${TABLE}.received_at ;;
  }

  dimension: user_id {
    type: string
    # hidden: true
    sql: ${TABLE}.user_id ;;
  }

  dimension: uuid {
    type: number
    value_format_name: id
    sql: ${TABLE}.id ;;
  }

  dimension: event_id {
    type: string
    sql: CONCAT(${received_raw}, ${uuid}) ;;
  }

  measure: count {
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
