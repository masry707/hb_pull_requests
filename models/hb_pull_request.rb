class HbPullRequest
  attr_accessor :reviews

  def initialize(pr:, reviews:, files:)
    @pr = pr
    @reviews = reviews
    @files = files
  end

  def additions
    @files.map { |f| f.additions }.sum
  end

  def deletions
    @files.map { |f| f.deletions }.sum
  end

  def changes
    additions + deletions
  end

  def url
    html_url
  end

  def reviewed_by_me?
    !! @reviews.find { |review| review.user.login == username }
  end

  def labels_list
    labels.map { |label| label.name.downcase }
  end

  # If a method we call is missing, pass the call onto
  # the object we delegate to.
  def method_missing(m, *args, &block)
    @pr.send(m, *args, &block)
  end

  def username
    username ||= ENV['GITHUB_USERNAME']
  end
end