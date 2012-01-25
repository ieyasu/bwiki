require 'bwiki-format'
include BWiki

describe "depluralizer" do
  it "doesn't depluralize singular words" do
    depluralize('thing').should eq('thing')
    depluralize('twenty').should eq('twenty')
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
    wikiword?('weIRdcaps').should be_false
    wikiword?('ForwardX11Trusted').should be_false
    wikiword?('Either/Or').should be_false
  end
end
