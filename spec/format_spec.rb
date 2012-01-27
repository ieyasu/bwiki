require 'bwiki-format'
include BWiki

describe "plural splitter" do
  it "doesn't depluralize singular words" do
    'thing'.split_plural.should eq(['thing', nil])
    'twenty'.split_plural.should eq(['twenty', nil])
    'snake'.split_plural.should eq(['snake', nil])
    'horse'.split_plural.should eq(['horse', nil])
    'monkey'.split_plural.should eq(['monkey', nil])
  end

  # rule: add 's'
  it "does simple depluralization" do
    'RFCs'.split_plural.should eq(['RFC', 's'])
    'peas'.split_plural.should eq(['pea', 's'])
  end

  # rule: nouns ending in s, z, ch, sh, x: add 'es'
  it "depluralizes nouns ending in s, z, ch, sh, x" do
    'OSes'.split_plural.should eq(['OS', 'es'])
    'klutzes'.split_plural.should eq(['klutz', 'es'])
    'loaches'.split_plural.should eq(['loach', 'es'])
    'wishes'.split_plural.should eq(['wish', 'es'])
    'foxes'.split_plural.should eq(['fox', 'es'])
  end

  # rule: nouns ending in o: add 's' or 'es', no simple pattern to discriminate
  it "depluralizes nouns ending in o" do
    'potatoes'.split_plural.should eq(['potato', 'es'])
    'pros'.split_plural.should eq(['pro', 's'])
  end

  # rule: nounds ending in y: 'y' -> 'ies'
  it "depluralizes nouns ending in y" do
    'stories'.split_plural.should eq(['stor', 'ies'])
  end
end

describe "wiki word detector" do
  it "detects simple WikiWords" do
    wikiword?('WikiWord').should be_true
    wikiword?('WikiW0rd').should be_true
    wikiword?('WikiWord3').should be_true
  end

  it "rejects serial numbers" do
    wikiword?('B9A30316207').should be_false
    wikiword?('E600F9957Dd0p0').should be_false
  end

  it "accepts limited consecutive caps" do
    wikiword?('DvorakInXWindows').should be_true
    wikiword?('AltInOSX').should be_true
    wikiword?('OSXTerminal').should be_true
    wikiword?('NASA').should be_false
  end

  it "rejects non-wikiwords" do
    wikiword?('word').should be_false
    wikiword?('Word').should be_false
    wikiword?('weIRdcaps').should be_false
    wikiword?('ForwardX11Trusted').should be_false
    wikiword?('Either/Or').should be_false
  end
end

describe "table formatter" do
  t1 = <<EOD
|simple|table|
EOD
  h1 = <<EOD
<table class='wiki'>
  <tr>
    <td>simple</td>
    <td>table</td>
  </tr>
</table>
EOD

  t2 = <<EOD
|escaped \\| pipe|
EOD
  h2 = <<EOD
<table class='wiki'>
  <tr>
    <td>escaped \\| pipe</td>
  </tr>
</table>
EOD

  t3 = <<EOD
|simple|
|table|
EOD
  h3 = <<EOD
<table class='wiki'>
  <tr>
    <td>simple</td>
  </tr>
  <tr>
    <td>table</td>
  </tr>
</table>
EOD

t4 = <<EOD
|multi| line \
cell|
EOD
h4 = <<EOD
<table class='wiki'>
  <tr>
    <td>multi</td>
    <td>line cell</td>
  </tr>
</table>
EOD

  it "formats simple tables" do
    fmt_tables(t1).should == h1
    fmt_tables(t2).should == h2
    fmt_tables(t3).should == h3
    fmt_tables(t4).should == h4
  end

  r1 = <<EOD
some text |not |a table|
EOD
  r2 = <<EOD
|still|not| a table
EOD
  r3 = <<EOD
some text |not a|table| more text
EOD

  it "doesn't format pipes in random locations" do
    fmt_tables(r1).should == r1
    fmt_tables(r2).should == r2
  end

  it "formats cell attributes" do
    fmt_cell("_", "foo").should == "<th>foo</th>"
    fmt_cell("<", "foo").should == "<td align='left'>foo</td>"
    fmt_cell(">", "foo").should == "<td align='right'>foo</td>"
    fmt_cell("=", "foo").should == "<td align='center'>foo</td>"
    fmt_cell("#", "foo").should == "<td align='justify'>foo</td>"
    fmt_cell("^", "foo").should == "<td valign='top'>foo</td>"
    fmt_cell("~", "foo").should == "<td valign='bottom'>foo</td>"
    fmt_cell("\\2", "foo").should == "<td colspan='2'>foo</td>"
    fmt_cell("/3", "foo").should == "<td rowspan='3'>foo</td>"

    fmt_cell("_#/2", "s").should == "<th align='justify' rowspan='2'>s</th>"

    fmt_cell("", "").should == "<td></td>"
  end

  tc1 = <<EOD
|_. header|\\_.cen|
EOD
  thc1 = <<EOD
<table class='wiki'>
  <tr>
    <th>header</th>
    <td>_.cen</td>
  </tr>
</table>
EOD

  it "formats cell attributes in a table" do 
    fmt_tables(tc1).should == thc1
  end
end

describe "wiki chunk formatter" do
  it "links wiki words" do
    fmt_wiki_words("a StartPage appear").should == "a <a href='StartPage'>StartPage</a> appear"
    fmt_wiki_words("WikiWord").should == "WikiWord<a href='WikiWord/edit'>?</a>"
    fmt_wiki_words("PluralWords").should == "PluralWord<a href='PluralWord/edit'>?</a>s<a href='PluralWords/edit'>?</a>"
  end

  it "automatically links http and ftp urls" do
    fmt_urls("a http://example.com/index.html").should ==
      "a <a href='http://example.com/index.html'>http://example.com/index.html</a>"
    fmt_urls("https://example.com/ foo").should ==
      "<a href='https://example.com/'>https://example.com/</a> foo"
    fmt_urls("mailto:user@example.com").should ==
      "<a href='mailto:user@example.com'>mailto:user@example.com</a>"
  end

  it "translates markdown to html" do
  end

  it "combines all the above" do
  end

end
