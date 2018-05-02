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
    sql: case when ${TABLE}.context_page_url  like '%modal_campaign%'
              then split_part (split_part (  ${TABLE}.context_page_url,'modal_campaign=',2),'&',1)
              else
              ${TABLE}.context_campaign_name end ;;}

  dimension: context_campaign_medium {
    label: "Campaign Medium"
    type: string
    sql: ${TABLE}.context_campaign_medium;;
  }


  dimension: ga_grouping {
    label: "Ga Grouping"
    type: string
    sql: case  when ${TABLE}.context_campaign_source = 'shareasale'     then 'Affiliate'
               when ${TABLE}.context_page_referrer ilike '%shareasale%'  then 'Affiliate'
               when ${TABLE}.context_campaign_medium = 'referral'       then 'Organic Social'
               when ${TABLE}.context_campaign_medium = 'profile-link'   then 'Organic Social'
               when ${TABLE}.context_campaign_source = 'story'          then 'Organic Social'
               when ${TABLE}.context_campaign_source = 'instagram'      then 'Organic Social'
               when ${TABLE}.context_campaign_medium = 'instagram'      then 'Organic Social'
               when ${TABLE}.context_campaign_source = 'instagram_paid' then 'Paid Social'
               when ${TABLE}.context_campaign_source = 'facebook'       then 'Paid Social'
               when ${TABLE}.context_page_url         like '%gclid%'    then 'Paid Search'
               when ${TABLE}.context_page_search      like '%gclid%'    then 'Paid Search'
               when ${TABLE}.context_campaign_medium = 'cpc'            then 'Paid Search'
               when ${TABLE}.context_campaign_medium = 'email'          then 'Email'
               when ${TABLE}.context_campaign_source ='Mailer'          then 'Email'
               when ${TABLE}.context_campaign_source ='(direct)'        then 'Direct'
               when ${TABLE}.context_campaign_medium ilike'organic%'    then 'Organic Search'
               when ${TABLE}.context_campaign_medium is null            then 'Organic Search'
               else 'Organic Search'
               end;;}

  dimension: context_campaign_source {
    label: "Campaign Source"
    sql: ${TABLE}.context_campaign_source;;
  }

  dimension: context_user_agent {sql:context_user_agent;;}

dimension: context_device_source {
  label: "Device Source"
    sql: case
      when  split_part( ${TABLE}.context_user_agent,'(',2)  ilike '%iphone%' then 'Iphone'
      when  split_part( ${TABLE}.context_user_agent,'(',2)  ilike '%ipad%' then 'Ipad'
      when  split_part( ${TABLE}.context_user_agent,'(',2)  ilike '%android%' then 'Android'
      when  split_part( ${TABLE}.context_user_agent,'(',2) like  '%Windows%' then 'WindowsPc'
      when  split_part( ${TABLE}.context_user_agent,'(',2)  like '%Macintosh%' then 'MacPc'
      when  split_part( ${TABLE}.context_user_agent,'(',2)  like '%AppleWeb%' then 'MacPc'
      when  split_part( ${TABLE}.context_user_agent,'(',2)  like '%Googlebot%' then 'Bot'
      else 'Bot'
      end ;;}

dimension: device_type{
  label: "Device type"
  sql:  case
      when  split_part( ${TABLE}.context_user_agent,'(',2)  ilike '%iphone%' then 'Mobile'
      when  split_part( ${TABLE}.context_user_agent,'(',2)  ilike '%ipad%' then 'Tablet'
      when  split_part( ${TABLE}.context_user_agent,'(',2)  ilike '%android%' then 'Mobile'
      when  split_part( ${TABLE}.context_user_agent,'(',2)  like '%Windows%' then 'Pc'
      when  split_part( ${TABLE}.context_user_agent,'(',2)  like '%Macintosh%' then 'Pc'
      when  split_part( ${TABLE}.context_user_agent,'(',2)  like '%AppleWeb%' then 'Pc'
      when  split_part( ${TABLE}.context_user_agent,'(',2)  like '%Linux%' then 'Pc'
      when  split_part( ${TABLE}.context_user_agent,'(',2)  ilike '%bot%' then 'Bot'
      when  ${TABLE}.context_user_agent ilike '%scrape%' then 'Bot'
      when  ${TABLE}.context_user_agent ilike '%bot%' then 'Bot'
      when  ${TABLE}.context_user_agent ilike '%hubspot%' then 'Bot'
      when  ${TABLE}.context_user_agent ilike '%seo%' then 'Bot'
      when  ${TABLE}.context_user_agent ilike '%tablet%' then 'Tablet'
      when  ${TABLE}.context_user_agent ilike '%mobile%' then 'Mobile'
      when  ${TABLE}.context_user_agent ilike '%desktop%' then 'Pc'
      else 'Bot'
      end;;}

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
