require 'bwiki-format'
include BWiki

describe "depluralizer" do
  it "doesn't depluralize singular words" do
    depluralize('thing').should eq('thing')
    depluralize('twenty').should eq('twenty')
    depluralize('snake').should eq('snake')
    depluralize('horse').should eq('horse')
    depluralize('monkey').should eq('monkey')
  end

  # rule: add 's'
  it "does simple depluralization" do
    depluralize('RFCs').should eq('RFC')
    depluralize('peas').should eq('pea')
  end

  # rule: nouns ending in s, z, ch, sh, x: add 'es'
  it "depluralizes nouns ending in s, z, ch, sh, x" do
    depluralize('OSes').should eq('OS')
    depluralize('klutzes').should eq('klutz')
    depluralize('loaches').should eq('loach')
    depluralize('wishes').should eq('wish')
    depluralize('foxes').should eq('fox')
  end

  # rule: nouns ending in o: add 's' or 'es', no simple pattern to discriminate
  it "depluralizes nouns ending in o" do
    depluralize('potatoes').should eq('potato')
    depluralize('pros').should eq('pro')
  end

  # rule: nounds ending in y: 'y' -> 'ies'
  it "depluralizes nouns ending in y" do
    depluralize('stories').should eq('story')
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
|multi|line \
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
end
