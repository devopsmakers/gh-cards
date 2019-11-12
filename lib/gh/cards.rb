require "gh/cards/version"
require "git"
require "octokit"
require "active_support/inflector"
require "erb"

module Gh
  module Cards

    $user_names_cache = {}

    def self.generate(template, directory, repo)
      @template = template
      @directory = directory
      @repo = repo || _get_this_repo()

      @last_issue = _get_last_issue(@directory)

      @cards = _get_cards_from_gh_issues(@last_issue)

      _generate_cards_html(@template, @directory, @repo, @cards)

      _set_last_issue(@directory, @cards)

      system("open", "#{@directory}/cards.html")
      puts "Done!"
    end

    def self._get_this_repo
      @repo_regex = /^(https|git)(:\/\/|@)([^\/:]+)[\/:]([^\/:]+)\/(.+).git$/
      begin
        @g = Git.open('.')
      rescue
        abort("Unable to detect git repo! Make sure you're in a repo or use the --repo option")
      end
      @r = @g.remote('origin').url.match(@repo_regex)
      return "#{@r[4]}/#{@r[5]}"
    end

    def self._get_last_issue(directory)
      @last_file = "#{directory}/last"

      if ! File.directory?(directory)
        FileUtils.mkdir_p directory
      end

      if ! File.file?(@last_file)
        File.open(@last_file, "w") do |f|
          f.write(0)
        end
      end

      @last_issue_number = File.open(@last_file, "r"){ |file| file.read }
      return @last_issue_number.to_i

    end

    def self._set_last_issue(directory, cards)
      @last_file = "#{directory}/last"
      File.open(@last_file, "w") do |f|
        f.write(@cards[0][:number])
      end
    end

    def self._get_cards_from_gh_issues(last_issue)
      @client = Octokit::Client.new(:netrc => true)
      @client.auto_paginate = true

      @issues = @client.list_issues @repo
      @issues.reject!{ |issue| issue[:number] <= last_issue or issue[:pull_request]}

      if @issues.empty?
        @exit_msg = "No issues found in #{@repo}"
        if last_issue > 0
          @exit_msg << "\n\nFile: #{@directory}/last shows the last issue generated as #{last_issue}"
          @exit_msg << "\nTo reset and generate all cards, delete #{@directory}/last and re-run"
        end
        puts @exit_msg
        exit 0
      end

      puts "Found #{@issues.length} new #{"issue".pluralize @issues.length} in #{@repo} to generate cards from"

      @cards = @issues.map do |issue|
        {
          :title => issue[:title],
          :number => issue[:number],
          :labels => issue[:labels].map{|label| {:name => label[:name], :color => label[:color]}},
          :milestone => issue[:milestone] ? issue[:milestone][:title] : nil,
          :created_by => _get_gh_user_name(issue[:user][:login]),
          :created_at => issue[:created_at]
        }
      end
      return @cards
    end

    def self._get_gh_user_name(user_login)
      if $user_names_cache[user_login.to_sym].nil?
        $user_names_cache[user_login.to_sym] = @client.user(user_login)[:name] || user_login
      end
      return $user_names_cache[user_login.to_sym]
    end

    def self._generate_cards_html(template, directory, repo, cards)

      if File.file?("#{__dir__}/../../templates/#{template}.html.erb")
        @template_file = "#{__dir__}/../../templates/#{template}.html.erb"
      elsif File.file?("#{__dir__}/../../templates/#{template}")
        @template_file = "#{__dir__}/../../templates/#{template}"
      elsif File.file?(template)
        @template_file = template
      else
        abort("Unable to find template: #{template}")
      end

      @cards = cards
      @repo = repo

      puts "Generating cards using template: #{template}"
      erb = ERB.new(File.read(@template_file))
      File.write("#{directory}/cards.html", erb.result(binding))
    end
  end
end
