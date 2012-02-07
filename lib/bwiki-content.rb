require 'grit'

# Content storage-related methods.
module BWiki
  # Creates a new git repo in ./content/ by copying the contents of template/
  def create_content_repository
    `cp -r template/ content/`
    Dir.chdir 'content'
    s = `git init; git add .; git commit -m "copy from template/"`
    Dir.chdir('..')
    s
  end

  # make a new page
  # update a page (edit)
  # delete a page
  # list delete pages
  # show old versions of a page
  # diff between page versions
  # search wiki content
end
