module BWiki
  # Takes a string ending in a word which may or may not be plural.
  # If it is a recognized plural form, returns the string with the
  # ending word in singular form.
  def depluralize(word)
    case word
    when /\w(?:s|z|ch|sh|x)es$/i
      word[0..-3] # end in s, z, ch, sh, x -> remove 'es'
    when /\wos$/i
      word[0..-2] # end in os -> o
    when /\woes$/i
      word[0..-3] # end in oes -> o
    when /\wies$/i
      word[0..-4] + 'y' # end in 'ies' -> 'y'
    when /\ws$/i
      word[0..-2] # simple plural -> remove ending 's'
    else
      word # not a plural
    end
  end

  # Note: (?> ...) prevents backtracking so, e.g. 'NASA' doesn't get
  # minimally matched by the second line in order to get the requisite
  # 2+ repetitions.
  WIKI_WORD_STR = "(?> (?:[A-Z]\\d*[a-z]+[a-z0-9]*) |" +
                      "(?:[A-Z](?![a-z0-9]))+ ){2,}"
  WIKI_WORD_PAT = Regexp.new("\\A#{WIKI_WORD_STR}\\Z", Regexp::EXTENDED)
  PAGE_URL = Regexp.new("(#{WIKI_WORD_STR})", Regexp::EXTENDED)

  # Given a word, decides if it's a valid WikiWord or not.
  def wikiword?(s)
    s =~ WIKI_WORD_PAT
  end

  def fmt_cell(opts, text)
    tag = 'td'
    atts = ''
    if opts
      opts.scan(/.\d*/) do |opt|
        case opt
        when '_' then tag = 'th'
        when '<' then atts << " align='left'"
        when '>' then atts << " align='right'"
        when '=' then atts << " align='center'"
        when '#' then atts << " align='justify'"
        when '^' then atts << " valign='top'"
        when '~' then atts << " valign='bottom'"
        when %r!\\(\d+)! then atts << " colspan='#{$1}'"
        when %r!/(\d+)!  then atts << " rowspan='#{$1}'"
        end
      end
    elsif text[0] == '\\'
      text = text[1..-1]
    end
    "<#{tag}#{atts}>#{text}</#{tag}>"
  end

  TABLE_PAT = /(?:^\|(?:(?:[^|\r\n\\]|\\.|\\[\r \t]*\n)*\|)+[ \t]*\r?\n)+/
  ROW_PAT = /^(?:\|(?!\r?\n)(?:[^|\\]|\\.)+(?=\|))+\|\r?\n/x
  CELL_PAT = /\|(?:((?:[_<>=#^~]|(?:[\\\/]\d+))+)\.)?((?:[^|\\]|\\.)+)(?=\|)/mx

  def fmt_tables(text)
    text.gsub(TABLE_PAT) do |table|
      buf = "<table class='wiki'>\n"
      table.scan(ROW_PAT) do |row|
        buf << "  <tr>\n"
        row.scan(CELL_PAT) do |cell|
          buf << "    #{fmt_cell $1, $2.strip}\n"
        end
        buf << "  </tr>\n"
      end
      buf << "</table>\n"
    end
  end
end
