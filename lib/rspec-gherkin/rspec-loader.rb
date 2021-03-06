require "rspec-gherkin"
require "rspec"

module RSpecGherkin
  module RSpec
    module Loader
      def load(*paths, &block)

        # Override feature exclusion filter if running features
        if paths.any? { |path| RSpecGherkin.feature?(path) }
          ::RSpec.configuration.filter_manager.exclusions.reject! do |key, value|
            key == :feature || (key == :type && value == 'feature')
          end
        end

        paths = paths.map do |path|
          if RSpecGherkin.feature?(path)
            spec_path = RSpecGherkin.feature_to_spec(path)
            if File.exist?(spec_path)
              spec_path
            else
              RSpecGherkin::Builder.build(path).features.each do |feature|
                ::RSpec::Core::ExampleGroup.describe(
                  "Feature: #{feature.name}", :type => :feature, :feature => true
                ) do
                  it do
                    example.metadata[:file_path] = spec_path
                    example.metadata[:line_number] = 1
                    pending('Not yet implemented')
                  end
                end.register
              end

              nil
            end
          else
            path
          end
        end.compact

        # Load needed features to RSpecGherkin.features array
        paths.each do |path|
          if RSpecGherkin.feature_spec?(path)
            feature_path = RSpecGherkin.spec_to_feature(path)

            if File.exists?(feature_path)
              RSpecGherkin.features += RSpecGherkin::Builder.build(feature_path).features
            end
          end
        end

        super(*paths, &block) if paths.size > 0
      end
    end
  end
end
