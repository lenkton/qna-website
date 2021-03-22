require 'octokit'

module LinksHelper
  def gist_files(url)
    client = Octokit::Client.new
    hash = url.split('/').last
    gist = client.gist(hash)
    gist.files.to_h
  end
end
