view: event_facts {
  sql_table_name: analytics_segment.segment_event_facts ;;

  dimension: event_id {
    primary_key: yes
    #     hidden: true
    sql: ${TABLE}.event_id ;;
  }

  dimension: uuid {
    type: string
    hidden: yes
    sql: ${TABLE}.id ;;
  }

  dimension: session_id {
    sql: ${TABLE}.session_id ;;
  }

  dimension: first_referrer {
    sql: ${TABLE}.first_referrer ;;
  }


  dimension: ga_grouping {
    label: "GA Grouping GA-Equiv"
    sql: ${TABLE}.m_ga_grouping ;;
  }

  dimension: f_session_ga_grouping {
    sql: ${TABLE}.f_session_ga_grouping ;;
  }
  dimension: l_session_ga_grouping {
    sql: ${TABLE}.l_session_ga_grouping ;;
  }
  dimension: fnd_session_ga_grouping {
    sql: ${TABLE}.fnd_session_ga_grouping ;;
  }
  dimension: lnd_session_ga_grouping {
    sql: ${TABLE}.lnd_session_ga_grouping ;;
  }

  dimension: event_ga_grouping {
    sql: ${TABLE}.event_ga_grouping ;;
  }

  dimension: first_referrer_domain {
    sql: split_part(${first_referrer},'/',3) ;;
  }

  dimension: first_referrer_domain_mapped {
    sql: CASE WHEN ${first_referrer_domain} like '%facebook%' THEN 'facebook' WHEN ${first_referrer_domain} like '%google%' THEN 'google' ELSE ${first_referrer_domain} END ;;
  }

  dimension: looker_visitor_id {
    type: string
    sql: ${TABLE}.looker_visitor_id ;;
  }

  dimension: anonymous_id {
    type: string
    sql: ${TABLE}.anonymous_id ;;
  }

  dimension: sequence_number {
    type: number
    sql: ${TABLE}.track_sequence_number ;;
  }

  dimension: source_sequence_number {
    type: number
    sql: ${TABLE}.source_sequence_number ;;
  }

  measure: count_visitors {
    type: count_distinct
    sql: ${looker_visitor_id} ;;
  }
  measure: count_session {
    label: "Nbr Sessions (GA equiv)"
    type: count_distinct
    sql: ${session_id} ;;
  }
}
