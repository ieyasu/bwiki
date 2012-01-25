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
  WIKI_WORD_PAT = /\A(?> (?:[A-Z]\d*[a-z]+[a-z0-9]*) |
                         (?:[A-Z](?![a-z0-9]))+
                     ){2,}?\Z/x

  # Given a word, decides if it's a valid WikiWord or not.
  def wikiword?(s)
    s =~ WIKI_WORD_PAT
  end
end
