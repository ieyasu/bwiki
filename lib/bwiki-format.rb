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

  TABLE_PAT = /(?:^\|(?:(?:[^|\r\n\\]|\\.|\\[\r \t]*\n)*\|)+[ \t]*\r?\n)+/
  ROW_PAT = /^(?:\|(?!\r?\n)(?:[^|\\]|\\.)+(?=\|))+\|\r?\n/x
  CELL_PAT = /\|((?:[^|\\]|\\.)+)(?=\|)/mx

  def fmt_tables(text)
    text.gsub(TABLE_PAT) do |table|
      buf = "<table class='wiki'>\n"
      table.scan(ROW_PAT) do |row|
        buf << "  <tr>\n"
        row.scan(CELL_PAT) do |cell|
          buf << "    <td>#{$1}</td>\n"
        end
        buf << "  </tr>\n"
      end
      buf << "</table>\n"
    end
  end
end
