# gh-cards

Create HTML format cards from Github Issues for printing

## Installation

```
gem install gh-cards
```

## Usage

The `gh-cards` cli tool is designed to be run inside a repo. It will create a
directory `.gh-cards` containing a file named `last` which stores the last card
and a file `cards.html` which are the cards to be printed.

At least the `.gh-cards/last` file should be committed to your repo so that anyone
can print cards as necessary.

To generate cards from all open issues, `rm .gh-cards/last`.

```
Commands:
  gh-cards generate        # Generate your Github issue cards HTML file
  gh-cards help [COMMAND]  # Describe available commands or one specific command

Options:
  -t, [--template=TEMPLATE]    # Template name or path to erb template
                               # Default: default
  -d, [--directory=DIRECTORY]  # The directory to use for output
                               # Default: .gh-cards
  -r, [--repo=REPO]            # The org/repo you want to generate cards for (autodetected when inside a repo)
```

To generate cards:
```
cd my-repo
gh-cards generate
```

## Card Templates

Cards are generated using ERB Templates. The default template is in this repo
at: `templates/default.html.erb` which is designed to use minimal ink. If templates
are added in the future (Hint: open PRs) you'll be able to reference them with
the `-t` or `--template` option.

You can also create your own templates, for example if you create a template at:
`.gh-cards/my-template.html.erb` you can generate cards using your template:
```
gh-cards generate --template=.gh-cards/my-template.html.erb
```

The cards passed to the ERB are an array of objects:
```
[
  {
    :title=>"Test Issue",
    :number=>1,
    :labels=>[
      {
        :name=>"bug",
        :color=>"d73a4a"
      },
      {
        :name=>"good first issue",
        :color=>"7057ff"
      },
      {
        :name=>"help wanted",
        :color=>"008672"
      }
    ],
    :created_by=>"Tim Birkett",
    :created_at=>2019-11-07 15:07:31 UTC
  },
  ...
  ...
  ...
]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/gh-cards. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Gh::Cards project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/gh-cards/blob/master/CODE_OF_CONDUCT.md).
