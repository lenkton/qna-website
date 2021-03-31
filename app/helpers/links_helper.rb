require 'octokit'

module LinksHelper
  def gist?(url)
    url =~ %r{\Ahttps://gist.github.com/}
  end

  def gist_files(url)
    client = Octokit::Client.new(netrc: true)
    hash = url.split('/').last
    gist = client.gist(hash)
    gist.files.to_h
  end
end
