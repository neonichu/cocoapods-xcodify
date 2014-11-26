module Pod
  class Command
    class Xcodify < Command
      self.summary = 'A CocoaPods plugin that allows you to produce a throw-away Xcode project.'

      self.description = <<-DESC
        This plugin allows you to produce a throw-away Xcode project based on your podspec,
        so that library consumers can integrate that without using CocoaPods and you don’t
        have to spend time maintaining a feature you don’t use.
      DESC

      self.arguments = [
        CLAide::Argument.new('NAME', true),
      ]

      def self.options
        [
          ['--spec-sources=private,https://github.com/CocoaPods/Specs.git',
            'The sources to pull dependant pods from (defaults to master)'],
        ]
      end

      def initialize(argv)
        @name = argv.shift_argument
        @spec_sources = argv.option('spec-sources', 'https://github.com/CocoaPods/Specs.git').split(',')

        @spec = spec_with_path(@name)
        super
      end

      def validate!
        super
        help! 'A podspec path is required.' unless @spec
      end

      def run
        require 'cocoapods_xcodify/installer_patch.rb'

        if @spec.nil?
          help! 'Unable to find a podspec with path or name.'
          return
        end

        @spec.available_platforms.each do |platform|
          config.sandbox_root       = 'xcodify'
          config.integrate_targets  = false
          config.skip_repo_update   = true

          sandbox = install_pod(platform.name)

          FileUtils.rm_f('Podfile.lock')

          root = Pathname.new(config.sandbox_root)
          FileUtils.rm_f(root + 'Manifest.lock')
          FileUtils.rm_rf(root + 'Headers')
          FileUtils.rm_rf(root + 'Local Podspecs')
          FileUtils.rm_rf(root + 'Target Support Files' + 'Pods')

          pch = root + 'Target Support Files' + "Pods-#{@spec.name}" + "Pods-#{@spec.name}-prefix.pch"
          File.open(pch, 'w') {|file| file.truncate(0) }

          # TODO: Delete aggregate target from project
          FileUtils.mv(root + 'Pods.xcodeproj', root + "#{@spec.name}.xcodeproj")

          # TODO: Handle multiple platforms correctly
          break
        end
      end
    end
  end
end
