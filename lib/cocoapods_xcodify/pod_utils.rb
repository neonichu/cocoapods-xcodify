module Pod
  class Command
    class Xcodify < Command
      :private

      def install_pod(platform_name)
        podfile = podfile_from_spec(
          File.dirname(@path),
          @spec.name,
          platform_name,
          @spec.deployment_target(platform_name),
          @subspecs,
          @spec_sources,
        )

        sandbox = Sandbox.new(config.sandbox_root)
        installer = Installer.new(sandbox, podfile)
        installer.install!

        sandbox
      end

      def podfile_from_spec(path, spec_name, platform_name, deployment_target, subspecs, sources)
        Pod::Podfile.new do
          sources.each { |s| source s }
          platform(platform_name, deployment_target)
          if subspecs
            subspecs.each do |subspec|
              pod spec_name + '/' + subspec, :path => path
            end
          else
            pod spec_name, :path => path
          end
        end
      end

      def spec_with_path(path)
        return if path.nil? || !Pathname.new(path).exist?

        @path = path

        if Pathname.new(path).directory?
          help! path + ': is a directory.'
          return
        end

        unless ['.podspec', '.json'].include? Pathname.new(path).extname
          help! path + ': is not a podspec.'
          return
        end

        Specification.from_file(path)
      end
    end
  end
end
