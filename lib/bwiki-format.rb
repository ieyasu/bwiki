require 'bluecloth'

class String
  # Inspects the end of the string to see if it has a recognized plural
  # word form and either returns the word split at the plural suffix
  #  boundary or just [self, nil].
  def split_plural
    i =
      case self
      when /\w(?:s|z|ch|sh|x)es$/i
        -2 # end in s, z, ch, sh, x -> remove 'es'
      when /\wos$/i
        -1 # end in os -> o
      when /\woes$/i
        -2 # end in oes -> o
      when /\wies$/i
        -3 # end in 'ies' -> 'y'
      when /\ws$/i
        -1 # simple plural -> remove ending 's'
      else
        return self, nil # not a plural
      end
    return self[0...i], self[i..-1]
  end
end

module BWiki
  # Note: (?> ...) prevents backtracking so, e.g. 'NASA' doesn't get
  # minimally matched by the second line in order to get the requisite
  # 2+ repetitions.
  WIKI_WORD_STR = "(?> (?:[A-Z]\\d*[a-z]+[a-z0-9]*) |" +
                      "(?:[A-Z](?![a-z0-9]))+ ){2,}"
  WIKI_WORD_PAT = Regexp.new("\\b#{WIKI_WORD_STR}\\b", Regexp::EXTENDED)
  PAGE_URL = Regexp.new("(#{WIKI_WORD_STR})", Regexp::EXTENDED)

  # Given a word, decides if it's a valid WikiWord or not.
  def wikiword?(s)
    s =~ WIKI_WORD_PAT
  end

  def fmt_wiki_words(text)
    text.gsub(WIKI_WORD_PAT) do |word|
      if File.exist?("content/pages/#{word}")
        "<a href='#{word}'>#{word}</a>"
      else
        s, plu = word.split_plural
        if File.exist?("content/pages/#{s}")
          "<a href='#{s}'>#{s}</a>#{plu}"
        else
          link = "#{s}<a href='#{s}/edit'>?</a>"
          link << "#{plu}<a href='#{word}/edit'>?</a>" if plu
          link
        end
      end
    end
  end

  # Formats wiki words, urls, then send the result through markdown
  def fmt_urls(text)
    text.gsub(%r!\b(?:(?:https?|ftp)://|mailto:)\S+!) do |url|
      "<a href='#{url}'>#{url}</a>"
    end
  end

  # formats chunks of wiki text, transforming wiki words -> urls -> markdown
  def fmt_wiki_chunk(text)
    BlueCloth.new(fmt_urls fmt_wiki_words text).to_html
  end

  # strip the <p> tags enclosing a wiki text chunk
  def strip_para(text)
    text = text[3..-1] if text =~ /\A<p>/
    text = text[0..-5] if text =~ %r!</p>\Z!
    text
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
    "<#{tag}#{atts}>#{strip_para fmt_wiki_chunk text}</#{tag}>"
  end

  TABLE_PAT = /(?:^\|(?:(?:[^|\r\n\\]|\\.|\\[\r \t]*\n)*\|)+[ \t]*\r?\n)+/
  ROW_PAT = /^(?:\|(?!\r?\n)(?:[^|\\]|\\.)+(?=\|))+\|\r?\n/x
  CELL_PAT = /\|(?:((?:[_<>=#^~]|(?:[\\\/]\d+))+)\.)?((?:[^|\\]|\\.)+)(?=\|)/mx

  def fmt_tables(text)
    out = ''
    i = 0
    while (j = text.index(TABLE_PAT, i))
      out << fmt_wiki_chunk(text[i...j]) if i < j

      table = $~[0]
      out << "<table class='wiki'>\n"
      table.scan(ROW_PAT) do |row|
        out << "  <tr>\n"
        row.scan(CELL_PAT) do |cell|
          out << "    #{fmt_cell $1, $2.strip}\n"
        end
        out << "  </tr>\n"
      end
      out << "</table>\n"

      i = j + table.length
    end

    out << fmt_wiki_chunk(text[i..-1]) if i < text.length

    out
  end

  def fmt_page(path)
    File.open(path) do |fin|
      fmt_tables fin.read
    end
  end
end
