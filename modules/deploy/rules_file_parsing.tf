locals {

  _parsed_rules = flatten([
    for dq_file in local.data_quality_spec_file : [
      for rule in try(yamldecode(file("${path.module}/${dq_file}"))).rules: {
      column               = try(rule.column, null)
      ignore_null          = try(rule.ignoreNull, rule.ignore_null, null)
      dimension            = rule.dimension
      description          = try(rule.description, null)
      name                 = try(rule.name, null)
      threshold            = try(rule.threshold, null)
      non_null_expectation = try(rule.nonNullExpectation, rule.non_null_expectation, null)
      range_expectation = can(rule.rangeExpectation) || can(rule.range_expectation) ? {
        min_value          = try(rule.rangeExpectation.minValue, rule.range_expectation.min_value, null)
        max_value          = try(rule.rangeExpectation.maxValue, rule.range_expectation.max_value, null)
        strict_min_enabled = try(rule.rangeExpectation.strictMinEnabled, rule.range_expectation.strict_min_enabled, null)
        strict_max_enabled = try(rule.rangeExpectation.strictMaxEnabled, rule.range_expectation.strict_max_enabled, null)
      } : null
      regex_expectation = can(rule.regexExpectation) || can(rule.regex_expectation) ? {
        regex = try(rule.regexExpectation.regex, rule.regex_expectation.regex, null)
      } : null
      set_expectation = can(rule.setExpectation) || can(rule.set_expectation) ? {
        values = try(rule.setExpectation.values, rule.set_expectation.values, null)
      } : null
      uniqueness_expectation = try(rule.uniquenessExpectation, rule.uniqueness_expectation, null)
      statistic_range_expectation = can(rule.statisticRangeExpectation) || can(rule.statistic_range_expectation) ? {
        statistic          = try(rule.statisticRangeExpectation.statistic, rule.statistic_range_expectation.statistic)
        min_value          = try(rule.statisticRangeExpectation.minValue, rule.statistic_range_expectation.min_value, null)
        max_value          = try(rule.statisticRangeExpectation.maxValue, rule.statistic_range_expectation.max_value, null)
        strict_min_enabled = try(rule.statisticRangeExpectation.strictMinEnabled, rule.statistic_range_expectation.strict_min_enabled, null)
        strict_max_enabled = try(rule.statisticRangeExpectation.strictMaxEnabled, rule.statistic_range_expectation.strict_max_enabled, null)
      } : null
      row_condition_expectation = can(rule.rowConditionCheckExpectation) || can(rule.row_condition_check_expectation) ? {
        sql_expression = try(rule.rowConditionCheckExpectation.sqlExpression, rule.row_condition_check_expectation.sql_expression, null)
      } : null
      table_condition_expectation = can(rule.tableConditionExpectation) || can(rule.table_condition_expectation) ? {
        sql_expression = try(rule.tableConditionExpectation.sqlExpression, rule.table_condition_expectation.sql_expression, null)
      } : null
    }
  ]
  ])
    _file_data_quality_spec_raw = [
    for dq_file in local.data_quality_spec_file : yamldecode(file("${path.module}/${dq_file}"))
  ]

  # Use these in Dataplex definition
  sampling_percent = try(local._file_data_quality_spec_raw.samplingPercent, local._file_data_quality_spec_raw.sampling_percent, null)
  row_filter       = try(local._file_data_quality_spec_raw.rowFilter, local._file_data_quality_spec_raw.row_filter, null)
  rules            = local._parsed_rules
}
