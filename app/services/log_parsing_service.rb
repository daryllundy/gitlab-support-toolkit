class LogParsingService
  def initialize(log_file)
    @log_file = log_file
    @analysis = nil
  end

  def parse(analysis_type = 'error_detection')
    @analysis = create_analysis(analysis_type)
    
    begin
      @analysis.update!(status: 'running', started_at: Time.current)
      
      content = read_log_content
      results = case analysis_type.to_s
      when 'error_detection'
        detect_errors(content)
      when 'performance_analysis'
        analyze_performance(content)
      when 'security_scan'
        scan_security(content)
      else
        custom_analysis(content)
      end
      
      @analysis.update!(
        status: 'completed',
        completed_at: Time.current,
        result_summary: results[:summary],
        detailed_results: results[:details],
        errors_found: results[:errors_count],
        warnings_found: results[:warnings_count],
        execution_time_seconds: (Time.current - @analysis.started_at).round(2)
      )
      
      create_error_patterns(results[:patterns]) if results[:patterns].any?
      
      @analysis
    rescue => e
      @analysis.update!(
        status: 'failed',
        completed_at: Time.current,
        result_summary: "Analysis failed: #{e.message}",
        execution_time_seconds: (Time.current - @analysis.started_at).round(2)
      )
      raise e
    end
  end

  private

  def create_analysis(analysis_type)
    @log_file.analyses.create!(
      analysis_type: analysis_type,
      status: 'pending'
    )
  end

  def read_log_content
    if @log_file.file.attached?
      @log_file.file.download
    else
      File.read(@log_file.file_path) rescue ""
    end
  end

  def detect_errors(content)
    lines = content.lines
    error_patterns = []
    errors_count = 0
    warnings_count = 0
    
    # Common GitLab error patterns
    error_regexes = [
      { pattern: /ERROR.*(?:500|Internal Server Error)/i, severity: 'critical', type: 'Server Error' },
      { pattern: /FATAL.*(?:database|connection)/i, severity: 'critical', type: 'Database Fatal' },
      { pattern: /ERROR.*(?:timeout|connection.*failed)/i, severity: 'error', type: 'Connection Error' },
      { pattern: /WARN.*(?:deprecated|deprecation)/i, severity: 'warning', type: 'Deprecation Warning' },
      { pattern: /ERROR.*(?:authentication|authorization)/i, severity: 'error', type: 'Auth Error' },
      { pattern: /ERROR.*(?:git|repository)/i, severity: 'error', type: 'Git Error' },
      { pattern: /\[ERROR\]|\bERROR\b/i, severity: 'error', type: 'General Error' },
      { pattern: /\[WARN\]|\bWARN\b/i, severity: 'warning', type: 'General Warning' }
    ]
    
    lines.each_with_index do |line, index|
      error_regexes.each do |regex_info|
        if line.match?(regex_info[:pattern])
          pattern_data = error_patterns.find { |p| p[:pattern] == regex_info[:pattern].source }
          
          if pattern_data
            pattern_data[:matches] << { line_number: index + 1, content: line.strip }
            pattern_data[:count] += 1
          else
            error_patterns << {
              pattern: regex_info[:pattern].source,
              pattern_type: 'regex',
              severity: regex_info[:severity],
              description: regex_info[:type],
              matches: [{ line_number: index + 1, content: line.strip }],
              count: 1
            }
          end
          
          case regex_info[:severity]
          when 'critical', 'error'
            errors_count += 1
          when 'warning'
            warnings_count += 1
          end
        end
      end
    end
    
    summary = generate_error_summary(error_patterns, errors_count, warnings_count)
    
    {
      summary: summary,
      details: {
        total_lines: lines.count,
        patterns_found: error_patterns.count,
        analysis_type: 'error_detection'
      },
      errors_count: errors_count,
      warnings_count: warnings_count,
      patterns: error_patterns
    }
  end

  def analyze_performance(content)
    lines = content.lines
    performance_patterns = []
    
    # Performance-related patterns
    perf_regexes = [
      { pattern: /(?:slow|timeout|performance)/i, severity: 'warning', type: 'Performance Issue' },
      { pattern: /(?:memory|cpu|disk).*(?:high|exceeded|limit)/i, severity: 'error', type: 'Resource Limit' },
      { pattern: /(?:query|database).*(?:slow|timeout)/i, severity: 'warning', type: 'Database Performance' }
    ]
    
    lines.each_with_index do |line, index|
      perf_regexes.each do |regex_info|
        if line.match?(regex_info[:pattern])
          performance_patterns << {
            pattern: regex_info[:pattern].source,
            pattern_type: 'regex',
            severity: regex_info[:severity],
            description: regex_info[:type],
            matches: [{ line_number: index + 1, content: line.strip }],
            count: 1
          }
        end
      end
    end
    
    {
      summary: "Performance analysis completed. Found #{performance_patterns.count} performance-related entries.",
      details: {
        total_lines: lines.count,
        patterns_found: performance_patterns.count,
        analysis_type: 'performance_analysis'
      },
      errors_count: performance_patterns.count { |p| p[:severity] == 'error' },
      warnings_count: performance_patterns.count { |p| p[:severity] == 'warning' },
      patterns: performance_patterns
    }
  end

  def scan_security(content)
    lines = content.lines
    security_patterns = []
    
    # Security-related patterns
    security_regexes = [
      { pattern: /(?:unauthorized|forbidden|access.*denied)/i, severity: 'error', type: 'Access Denied' },
      { pattern: /(?:authentication.*failed|invalid.*credentials)/i, severity: 'warning', type: 'Auth Failure' },
      { pattern: /(?:sql.*injection|xss|csrf)/i, severity: 'critical', type: 'Security Vulnerability' }
    ]
    
    lines.each_with_index do |line, index|
      security_regexes.each do |regex_info|
        if line.match?(regex_info[:pattern])
          security_patterns << {
            pattern: regex_info[:pattern].source,
            pattern_type: 'regex',
            severity: regex_info[:severity],
            description: regex_info[:type],
            matches: [{ line_number: index + 1, content: line.strip }],
            count: 1
          }
        end
      end
    end
    
    {
      summary: "Security scan completed. Found #{security_patterns.count} security-related entries.",
      details: {
        total_lines: lines.count,
        patterns_found: security_patterns.count,
        analysis_type: 'security_scan'
      },
      errors_count: security_patterns.count { |p| p[:severity] == 'critical' },
      warnings_count: security_patterns.count { |p| p[:severity] == 'warning' },
      patterns: security_patterns
    }
  end

  def custom_analysis(content)
    {
      summary: "Custom analysis completed.",
      details: { total_lines: content.lines.count, analysis_type: 'custom' },
      errors_count: 0,
      warnings_count: 0,
      patterns: []
    }
  end

  def generate_error_summary(patterns, errors_count, warnings_count)
    if patterns.empty?
      "No errors or warnings found in the log file."
    else
      critical_count = patterns.count { |p| p[:severity] == 'critical' }
      summary = "Analysis completed: #{errors_count} errors, #{warnings_count} warnings found."
      summary += " #{critical_count} critical issues detected." if critical_count > 0
      summary
    end
  end

  def create_error_patterns(patterns)
    patterns.each do |pattern_data|
      @analysis.error_patterns.create!(
        pattern: pattern_data[:pattern],
        pattern_type: pattern_data[:pattern_type],
        severity: pattern_data[:severity],
        description: pattern_data[:description],
        match_count: pattern_data[:count],
        sample_matches: pattern_data[:matches].first(5).map { |m| "Line #{m[:line_number]}: #{m[:content]}" }.join("\n"),
        match_data: pattern_data[:matches]
      )
    end
  end
end