require "thor"
require "gh/cards"

module Gh
  module Cards
    class CLI < Thor
      class_option :template, :type => :string, :aliases => "-t",
        :desc => "Template name or path to erb template", :default => "default"
      class_option :directory, :type => :string, :aliases => "-d",
        :desc => "The directory to use for output", :default => ".gh-cards"
      class_option :repo, :type => :string, :aliases => "-r",
        :desc => "The org/repo you want to generate cards for (autodetected when inside a repo)"

      desc "generate", "Generate your Github issue cards HTML file"
      def generate
        Gh::Cards.generate options[:template],  options[:directory], options[:repo]
      end
    end
  end
end
