view: pages {
  sql_table_name: analytics_segment.segment_pages_qtr ;;

  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}.id ;;
  }

  dimension: event_id {
    type: string
    sql: CONCAT(${received_raw}, ${uuid}) ;;
  }

  dimension: anonymous_id {
    type: string
    sql: ${TABLE}.anonymous_id ;;
  }

  dimension: context_campaign_content {
    type: string
    sql: ${TABLE}.context_campaign_content ;;
  }

  dimension: context_campaign_medium {
    type: string
    sql: ${TABLE}.context_campaign_medium ;;
  }

  dimension: context_campaign_name {
    type: string
    sql: ${TABLE}.context_campaign_name ;;
  }

  dimension: name {
    type: string
    sql: case when context_page_path ilike '%/c/%' then 'PLP'
              when context_page_path ilike '%/p/%' then 'PDP'
              when context_page_path ilike '%search%' then 'Search'
              when context_page_path ilike '%brand%' then 'Brand'
              when context_page_path ilike '%/b/%' then 'Brand'
              when context_page_path ilike '%cart%' then 'Cart'
              when context_page_path ilike '%checkout%' then 'Checkout'
              when context_page_path ilike '%skin-quiz%' then 'Skin Quiz'
              when context_page_path ilike '%by_%' then 'Product Sort'
              when ${TABLE}.name is not null then ${TABLE}.name
              else 'General' end
              ;;
  }

  dimension_group: received {
    type: time
    timeframes: [raw, time, date, week, month]
    sql: ${TABLE}.received_at ;;
  }

  dimension: referrer {
    type: string
    sql: ${TABLE}.referrer ;;
  }

  dimension: title {
    type: string
    sql: ${TABLE}.title ;;
  }

  dimension: url {
    type: string
    sql: ${TABLE}.url ;;
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

  measure: count {
    type: count
    drill_fields: [id, context_campaign_name, name, users.id]
  }

  measure: count_visitors {
    type: count_distinct
    sql: ${page_facts.looker_visitor_id} ;;
  }

  measure: count_pageviews {
    type: count
    drill_fields: [context_campaign_name]
  }

  measure: avg_page_view_duration_minutes {
    type: average
    value_format_name: decimal_1
    sql: ${page_facts.duration_page_view_seconds}/60.0 ;;
  }

  measure: count_distinct_pageviews {
    type: number
    sql: COUNT(DISTINCT CONCAT(${page_facts.looker_visitor_id}, ${url})) ;;
  }
}
